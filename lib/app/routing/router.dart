import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/di/injection_container.dart';
import 'package:itube/app/providers/current_user_provider.dart';
import 'package:itube/app/routing/route_constants.dart';
import 'package:itube/app/view/shell.dart';
import 'package:itube/core/network/interfaces/token_provider.dart';
import 'package:itube/src/auth/presentation/adapters/auth_adapter.dart';
import 'package:itube/src/auth/presentation/views/confirm_signup_page.dart';
import 'package:itube/src/auth/presentation/views/login_page.dart';
import 'package:itube/src/auth/presentation/views/signup_page.dart';
import 'package:itube/src/dashboard/presentation/views/home_page.dart';
import 'package:itube/src/splash/presentation/views/splash_page.dart';

part 'router.main.dart';
