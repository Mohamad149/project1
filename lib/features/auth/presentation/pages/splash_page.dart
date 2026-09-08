import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/route_app.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 2), _goToNextPage);
  }

  void _goToNextPage() {
    if (!mounted) return;

    final authState = context.read<AuthBloc>().state;
    final destination = authState is AuthAuthenticated
        ? AppRoutes.home
        : AppRoutes.login;

    Navigator.pushNamedAndRemoveUntil(
      context,
      destination,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFF8FF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Logo(),
              SizedBox(height: 32),
              Text(
                'Project',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Manage your work,\nachieve more.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Color(0xFF8E8798),
                ),
              ),
              SizedBox(height: 70),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: Color(0xFF7048B6),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF7048B6),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Text(
        'P',
        style: TextStyle(
          color: Colors.white,
          fontSize: 58,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
