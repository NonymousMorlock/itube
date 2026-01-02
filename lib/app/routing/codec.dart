import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/src/video/data/models/video_model.dart';

class RouterExtraCodec extends Codec<Object?, Object?> {
  const RouterExtraCodec();

  @override
  Converter<Object?, Object?> get decoder => const _RouterExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _RouterExtraEncoder();
}

class _RouterExtraDecoder extends Converter<Object?, Object?> {
  const _RouterExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input is! DataMap) return null;
    if (input case {'__type': 'Video'}) {
      debugPrint('[codec] Found video extra with id: ${input['id']}');
      return VideoModel.fromMap(input);
    }
    debugPrint('[codec] Found unknown extra: $input');
    return null;
  }
}

class _RouterExtraEncoder extends Converter<Object?, Object?> {
  const _RouterExtraEncoder();

  @override
  Object? convert(Object? input) {
    switch (input) {
      case VideoModel _:
        return {'__type': 'Video', ...input.toMap()};
      default:
        return null;
    }
  }
}
