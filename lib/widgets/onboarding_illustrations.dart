import 'dart:math' as math;
import 'package:flutter/material.dart';

class PrepareSmarterIllustration extends StatelessWidget {
  const PrepareSmarterIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomPaint(
      size: const Size(260, 200),
      painter: _PrepareSmarterPainter(
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.secondary,
        containerColor: colorScheme.primaryContainer,
      ),
    );
  }
}

class _PrepareSmarterPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color containerColor;

  _PrepareSmarterPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.containerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Background circle
    final bgPaint = Paint()
      ..color = containerColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.42, bgPaint);

    // Road path
    final roadPaint = Paint()
      ..color = const Color(0xFF37474F)
      ..style = PaintingStyle.fill;

    final roadPath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width * 0.85,
        size.height * 0.85,
      )
      ..lineTo(size.width * 0.75, size.height * 0.95)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.65,
        size.width * 0.25,
        size.height * 0.95,
      )
      ..close();

    canvas.drawPath(roadPath, roadPaint);

    // Road dashes
    final dashPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dashPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.9)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.58,
        size.width * 0.8,
        size.height * 0.9,
      );

    canvas.drawPath(dashPath, dashPaint);

    // Car Body
    final carPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final carRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.35, 80, 45),
      const Radius.circular(10),
    );
    canvas.drawRRect(carRRect, carPaint);

    // Car Roof
    final roofPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    final roofRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.42, size.height * 0.25, 45, 25),
      const Radius.circular(8),
    );
    canvas.drawRRect(roofRRect, roofPaint);

    // Wheels
    final wheelPaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.58), 10, wheelPaint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.58), 10, wheelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MasterRoadSignsIllustration extends StatelessWidget {
  const MasterRoadSignsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomPaint(
      size: const Size(260, 200),
      painter: _MasterRoadSignsPainter(
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.secondary,
        containerColor: colorScheme.secondaryContainer,
      ),
    );
  }
}

class _MasterRoadSignsPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color containerColor;

  _MasterRoadSignsPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.containerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Background circle
    final bgPaint = Paint()
      ..color = containerColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.42, bgPaint);

    // 1. Octagon Stop Sign (Left)
    final stopBg = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;

    final stopPath = Path();
    const double radius = 32;
    final centerLeft = Offset(size.width * 0.3, size.height * 0.45);
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (math.pi / 8);
      final x = centerLeft.dx + radius * math.cos(angle);
      final y = centerLeft.dy + radius * math.sin(angle);
      if (i == 0) {
        stopPath.moveTo(x, y);
      } else {
        stopPath.lineTo(x, y);
      }
    }
    stopPath.close();
    canvas.drawPath(stopPath, stopBg);

    // 2. Triangular Yield / Warning Sign (Center Right)
    final yieldBg = Paint()
      ..color = Colors.amber.shade800
      ..style = PaintingStyle.fill;

    final yieldCenter = Offset(size.width * 0.68, size.height * 0.4);
    final yieldPath = Path()
      ..moveTo(yieldCenter.dx, yieldCenter.dy - 35)
      ..lineTo(yieldCenter.dx - 32, yieldCenter.dy + 25)
      ..lineTo(yieldCenter.dx + 32, yieldCenter.dy + 25)
      ..close();

    canvas.drawPath(yieldPath, yieldBg);

    // Inner White Triangle
    final yieldInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final yieldInnerPath = Path()
      ..moveTo(yieldCenter.dx, yieldCenter.dy - 22)
      ..lineTo(yieldCenter.dx - 20, yieldCenter.dy + 18)
      ..lineTo(yieldCenter.dx + 20, yieldCenter.dy + 18)
      ..close();
    canvas.drawPath(yieldInnerPath, yieldInner);

    // 3. Circular Speed Limit (Bottom Center)
    final circleSignCenter = Offset(size.width * 0.48, size.height * 0.68);
    final circleBorder = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final circleFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(circleSignCenter, 28, circleFill);
    canvas.drawCircle(circleSignCenter, 28, circleBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrackProgressIllustration extends StatelessWidget {
  const TrackProgressIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomPaint(
      size: const Size(260, 200),
      painter: _TrackProgressPainter(
        primaryColor: colorScheme.primary,
        secondaryColor: colorScheme.secondary,
        tertiaryColor: colorScheme.tertiary,
        containerColor: colorScheme.tertiaryContainer,
      ),
    );
  }
}

class _TrackProgressPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color containerColor;

  _TrackProgressPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.containerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Background circle
    final bgPaint = Paint()
      ..color = containerColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.42, bgPaint);

    // Chart Bar 1
    final bar1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.28, size.height * 0.45, 24, 60),
        const Radius.circular(6),
      ),
      bar1,
    );

    // Chart Bar 2
    final bar2 = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.44, size.height * 0.32, 24, 85),
        const Radius.circular(6),
      ),
      bar2,
    );

    // Chart Bar 3
    final bar3 = Paint()
      ..color = tertiaryColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.6, size.height * 0.22, 24, 105),
        const Radius.circular(6),
      ),
      bar3,
    );

    // Target Checkmark Star Badge
    final badgeCenter = Offset(size.width * 0.72, size.height * 0.25);
    final badgeBg = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    canvas.drawCircle(badgeCenter, 18, badgeBg);

    final checkPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(badgeCenter.dx - 6, badgeCenter.dy)
      ..lineTo(badgeCenter.dx - 2, badgeCenter.dy + 5)
      ..lineTo(badgeCenter.dx + 6, badgeCenter.dy - 4);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
