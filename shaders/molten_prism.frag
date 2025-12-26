#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uTime;
uniform vec2 uBlob1; // Red/Left Blob Position
uniform vec2 uBlob2; // Green/Right Blob Position
uniform vec2 uBlob3; // Blue/Top Blob Position
uniform float uMorph; // 0.0 = Blobs, 1.0 = Triangle
uniform float uDistortion; // Amount of liquid wobble
uniform float uScale; // Expansion scale for the "Hole Punch"

out vec4 fragColor;

// --- UTILS ---

// Smooth Minimum (The Liquid Effect)
float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

// 2D Rotation
vec2 rotate(vec2 v, float a) {
    float s = sin(a);
    float c = cos(a);
    mat2 m = mat2(c, -s, s, c);
    return m * v;
}

// --- SHAPES (SDFs) ---

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

float sdTriangle(vec2 p, float r) {
    const float k = sqrt(3.0);
    p.x = abs(p.x) - 1.0;
    p.y = p.y + 1.0 / k;
    if (p.x + k * p.y > 0.0) p = vec2(p.x - k * p.y, -k * p.x - p.y) / 2.0;
    p.x -= clamp(p.x, -2.0, 0.0);
    return -length(p) * sign(p.y);
}

void main() {
    // 1. Normalize Coordinates (-1.0 to 1.0), fixed aspect ratio
    vec2 st = FlutterFragCoord().xy / uResolution.xy;
    vec2 p = (2.0 * FlutterFragCoord().xy - uResolution.xy) / min(uResolution.x, uResolution.y);

    // 2. Apply Scale (for the Outro Zoom)
    // We scale P inversely to zoom the content
    p /= uScale;

    // 3. Distortion (The "Breathing" Liquid)
    // We add a wave to the coordinates themselves
    vec2 distortedP = p;
    distortedP.x += sin(p.y * 4.0 + uTime * 2.0) * uDistortion;
    distortedP.y += cos(p.x * 4.0 + uTime * 2.5) * uDistortion;

    // 4. Blob Phase (SDFs)
    // We use the positions passed from Dart
    float d1 = sdCircle(distortedP - uBlob1, 0.35);
    float d2 = sdCircle(distortedP - uBlob2, 0.35);
    float d3 = sdCircle(distortedP - uBlob3, 0.35);

    // Smoothly merge them. 0.3 is the "Goo Factor"
    float dBlobs = smin(d1, smin(d2, d3, 0.3), 0.3);

    // 5. Crystal Phase (Triangle SDF)
    // Rotate -90deg (1.57 rad) to point right like a Play Button
    // Use raw 'p' (not distorted) so it looks sharp
    float dTriangle = sdTriangle(rotate(p, -1.57), 0.5);

    // 6. Morph
    // Linearly interpolate between the Blob shape and Triangle shape
    float finalShape = mix(dBlobs, dTriangle, uMorph);

    // 7. Render
    // 'smoothstep' creates a nice anti-aliased edge
    // We inverse it because SDFs are negative inside the shape
    float alpha = 1.0 - smoothstep(0.0, 0.01, finalShape);

    // 8. Color Logic
    // Start black
    vec3 color = vec3(0.0);

    // Add a subtle "sheen" or gradient inside the white shape
    // This makes it look like 3D glass instead of flat white
    if (alpha > 0.1) {
        color = vec3(1.0); // Base White
        // Slight gradient based on Y position for depth
        color -= vec3(0.1) * (p.y + 0.5);
    }

    fragColor = vec4(color, alpha);
}