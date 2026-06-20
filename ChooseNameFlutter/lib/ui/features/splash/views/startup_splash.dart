import 'dart:async';

import 'package:flutter/material.dart';

class StartupSplash extends StatefulWidget {
  const StartupSplash({
    required this.child,
    this.showDuration = const Duration(milliseconds: 1200),
    this.fadeDuration = const Duration(milliseconds: 250),
    super.key,
  });

  final Widget child;
  final Duration showDuration;
  final Duration fadeDuration;

  @override
  State<StartupSplash> createState() => _StartupSplashState();
}

class _StartupSplashState extends State<StartupSplash> {
  Timer? _timer;
  bool _showSplash = true;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.showDuration, () {
      if (!mounted) {
        return;
      }
      setState(() => _isVisible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_showSplash)
          Positioned.fill(
            child: AbsorbPointer(
              child: AnimatedOpacity(
                opacity: _isVisible ? 1 : 0,
                duration: widget.fadeDuration,
                onEnd: () {
                  if (!_isVisible && mounted) {
                    setState(() => _showSplash = false);
                  }
                },
                child: const SplashScreen(),
              ),
            ),
          ),
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const _backgroundAsset =
      'assets/images/bg_splash.imageset/bg_splash.png';
  static const _logoAsset = 'assets/images/logo.imageset/logo.png';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF008DA0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final logoBoxSize = width * 0.48;
          final logoTop = (height / 2) - (height * 0.067) - (logoBoxSize / 2);
          final titleTop = logoTop + logoBoxSize + (height * 0.039);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _backgroundAsset,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              Positioned(
                top: titleTop.clamp(height * 0.44, height * 0.68),
                left: 30,
                right: 30,
                child: const _SplashText(),
              ),
              Positioned(
                top: logoTop.clamp(height * 0.2, height * 0.5),
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox.square(
                    dimension: logoBoxSize,
                    child: Image.asset(_logoAsset, fit: BoxFit.contain),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SplashText extends StatelessWidget {
  const _SplashText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ім’я малюка',
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MontserratAlternates',
            fontSize: 30,
            fontWeight: FontWeight.w500,
            height: 1.18,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 17),
        Text(
          'Оберіть ім’я для вашої дитини',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MontserratAlternates',
            fontSize: 17,
            fontWeight: FontWeight.w400,
            height: 1.2,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
