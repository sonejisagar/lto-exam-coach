import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Reusable vector-rendered Road Sign widget using CustomPainter.
/// Provides accessible Semantics and scales cleanly to any size.
class RoadSignWidget extends StatelessWidget {
  final String signType;
  final double size;
  final String? semanticLabel;

  const RoadSignWidget({
    super.key,
    required this.signType,
    this.size = 80,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Road Sign: $signType',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          size: Size(size, size),
          painter: RoadSignPainter(signType: signType),
        ),
      ),
    );
  }
}

class RoadSignPainter extends CustomPainter {
  final String signType;

  RoadSignPainter({required this.signType});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    switch (signType) {
      // --- REGULATORY SIGNS ---
      case 'stop':
        _paintStop(canvas, size, center);
        break;
      case 'yield':
        _paintYield(canvas, size, center);
        break;
      case 'no_entry':
        _paintNoEntry(canvas, size, center);
        break;
      case 'no_u_turn':
        _paintNoUTurn(canvas, size, center);
        break;
      case 'no_left_turn':
        _paintNoLeftTurn(canvas, size, center);
        break;
      case 'no_right_turn':
        _paintNoRightTurn(canvas, size, center);
        break;
      case 'speed_limit_60':
        _paintSpeedLimit(canvas, size, center, '60');
        break;
      case 'speed_limit_80':
        _paintSpeedLimit(canvas, size, center, '80');
        break;
      case 'no_overtaking':
        _paintNoOvertaking(canvas, size, center);
        break;
      case 'keep_right':
        _paintKeepDirection(canvas, size, center, isRight: true);
        break;
      case 'keep_left':
        _paintKeepDirection(canvas, size, center, isRight: false);
        break;
      case 'no_parking':
        _paintNoParking(canvas, size, center);
        break;
      case 'no_stopping':
        _paintNoStopping(canvas, size, center);
        break;
      case 'no_horn':
        _paintNoHorn(canvas, size, center);
        break;
      case 'no_pedestrians':
        _paintNoPedestrians(canvas, size, center);
        break;

      // --- WARNING SIGNS ---
      case 'sharp_turn_left':
        _paintSharpTurn(canvas, size, center, isLeft: true);
        break;
      case 'sharp_turn_right':
        _paintSharpTurn(canvas, size, center, isLeft: false);
        break;
      case 'winding_road':
        _paintWindingRoad(canvas, size, center);
        break;
      case 'crossroad_ahead':
        _paintCrossroad(canvas, size, center);
        break;
      case 't_junction_ahead':
        _paintTJunction(canvas, size, center);
        break;
      case 'narrow_road_ahead':
        _paintNarrowRoad(canvas, size, center);
        break;
      case 'slippery_road':
        _paintSlipperyRoad(canvas, size, center);
        break;
      case 'steep_descent':
        _paintSteepDescent(canvas, size, center);
        break;
      case 'falling_rocks':
        _paintFallingRocks(canvas, size, center);
        break;
      case 'traffic_signals_ahead':
        _paintTrafficSignals(canvas, size, center);
        break;
      case 'roundabout_ahead':
        _paintRoundabout(canvas, size, center);
        break;
      case 'pedestrian_crossing_ahead':
        _paintPedestrianCrossing(canvas, size, center);
        break;
      case 'school_zone':
        _paintSchoolZone(canvas, size, center);
        break;
      case 'railroad_crossing':
        _paintRailroadCrossing(canvas, size, center);
        break;
      case 'two_way_traffic':
        _paintTwoWayTraffic(canvas, size, center);
        break;

      // --- INFORMATIVE & GUIDE SIGNS ---
      case 'hospital':
        _paintInfoLetter(canvas, size, 'H', Colors.blue.shade700);
        break;
      case 'first_aid':
        _paintFirstAid(canvas, size, center);
        break;
      case 'parking_area':
        _paintInfoLetter(canvas, size, 'P', Colors.blue.shade700);
        break;
      case 'one_way_right':
        _paintOneWayHorizontal(canvas, size, isRight: true);
        break;
      case 'one_way_straight':
        _paintOneWayStraight(canvas, size, center);
        break;
      case 'bus_stop':
        _paintBusStop(canvas, size, center);
        break;
      case 'disabled_access':
        _paintDisabledAccess(canvas, size, center);
        break;
      case 'fuel_station':
        _paintFuelStation(canvas, size, center);
        break;
      case 'expressway_exit':
        _paintExpresswayExit(canvas, size);
        break;
      case 'pedestrian_overpass':
        _paintPedestrianOverpass(canvas, size, center);
        break;

      // --- ROAD WORK & TEMPORARY SIGNS ---
      case 'road_work_ahead':
      case 'men_at_work':
        _paintRoadWorkWorker(canvas, size, center);
        break;
      case 'detour_ahead':
        _paintDetour(canvas, size);
        break;
      case 'road_closed':
        _paintRoadClosed(canvas, size);
        break;
      case 'flagman_ahead':
        _paintFlagman(canvas, size, center);
        break;

      default:
        _paintGenericSign(canvas, size, center);
    }
  }

  // ========================================================
  // PAINTER IMPLEMENTATIONS
  // ========================================================

  void _paintStop(Canvas canvas, Size size, Offset center) {
    final radius = size.width * 0.46;
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (math.pi / 8);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Red fill
    canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.fill);

    // White border
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..strokeWidth = size.width * 0.04
          ..style = PaintingStyle.stroke);

    // STOP Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'STOP',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  void _paintYield(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    // Outer Red Inverted Triangle
    final outerPath = Path()
      ..moveTo(w * 0.1, h * 0.15)
      ..lineTo(w * 0.9, h * 0.15)
      ..lineTo(center.dx, h * 0.88)
      ..close();

    canvas.drawPath(
        outerPath,
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.fill);

    // Inner White Triangle
    final innerPath = Path()
      ..moveTo(w * 0.22, h * 0.25)
      ..lineTo(w * 0.78, h * 0.25)
      ..lineTo(center.dx, h * 0.72)
      ..close();

    canvas.drawPath(
        innerPath,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
  }

  void _paintNoEntry(Canvas canvas, Size size, Offset center) {
    final radius = size.width * 0.44;

    // Red circle
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.fill);

    // White horizontal bar
    final barRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: radius * 1.5,
        height: radius * 0.38,
      ),
      Radius.circular(size.width * 0.02),
    );
    canvas.drawRRect(barRect, Paint()..color = Colors.white);
  }

  void _paintSpeedLimit(Canvas canvas, Size size, Offset center, String speed) {
    final radius = size.width * 0.44;

    // White circle
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    // Red ring
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..strokeWidth = size.width * 0.1
          ..style = PaintingStyle.stroke);

    // Speed digits
    final textPainter = TextPainter(
      text: TextSpan(
        text: speed,
        style: TextStyle(
          color: Colors.black,
          fontSize: size.width * 0.36,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  void _paintProhibitoryBase(Canvas canvas, Size size, Offset center,
      {required void Function() drawSymbol}) {
    final radius = size.width * 0.44;

    // White disc
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    // Draw symbol inside
    drawSymbol();

    // Red ring
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..strokeWidth = size.width * 0.09
          ..style = PaintingStyle.stroke);

    // Diagonal red slash
    final slashPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final slashDist = radius * 0.70;
    canvas.drawLine(
      Offset(center.dx - slashDist, center.dy - slashDist),
      Offset(center.dx + slashDist, center.dy + slashDist),
      slashPaint,
    );
  }

  void _paintNoUTurn(Canvas canvas, Size size, Offset center) {
    _paintProhibitoryBase(canvas, size, center, drawSymbol: () {
      final arrowPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.065
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final uPath = Path()
        ..moveTo(center.dx + size.width * 0.14, center.dy + size.height * 0.2)
        ..lineTo(center.dx + size.width * 0.14, center.dy - size.height * 0.08)
        ..arcToPoint(
          Offset(
              center.dx - size.width * 0.14, center.dy - size.height * 0.08),
          radius: Radius.circular(size.width * 0.14),
          clockwise: false,
        )
        ..lineTo(center.dx - size.width * 0.14, center.dy + size.height * 0.15);

      canvas.drawPath(uPath, arrowPaint);

      // Arrow head pointing down
      final head = Path()
        ..moveTo(center.dx - size.width * 0.22, center.dy + size.height * 0.1)
        ..lineTo(center.dx - size.width * 0.14, center.dy + size.height * 0.24)
        ..lineTo(center.dx - size.width * 0.06, center.dy + size.height * 0.1)
        ..close();
      canvas.drawPath(head, Paint()..color = Colors.black);
    });
  }

  void _paintNoLeftTurn(Canvas canvas, Size size, Offset center) {
    _paintProhibitoryBase(canvas, size, center, drawSymbol: () {
      final arrowPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.07
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(center.dx + size.width * 0.12, center.dy + size.height * 0.2)
        ..lineTo(center.dx + size.width * 0.12, center.dy - size.height * 0.05)
        ..quadraticBezierTo(
          center.dx + size.width * 0.12,
          center.dy - size.height * 0.15,
          center.dx - size.width * 0.15,
          center.dy - size.height * 0.15,
        );
      canvas.drawPath(path, arrowPaint);

      // Arrow head pointing left
      final head = Path()
        ..moveTo(center.dx - size.width * 0.12, center.dy - size.height * 0.23)
        ..lineTo(center.dx - size.width * 0.25, center.dy - size.height * 0.15)
        ..lineTo(center.dx - size.width * 0.12, center.dy - size.height * 0.07)
        ..close();
      canvas.drawPath(head, Paint()..color = Colors.black);
    });
  }

  void _paintNoRightTurn(Canvas canvas, Size size, Offset center) {
    _paintProhibitoryBase(canvas, size, center, drawSymbol: () {
      final arrowPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.07
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(center.dx - size.width * 0.12, center.dy + size.height * 0.2)
        ..lineTo(center.dx - size.width * 0.12, center.dy - size.height * 0.05)
        ..quadraticBezierTo(
          center.dx - size.width * 0.12,
          center.dy - size.height * 0.15,
          center.dx + size.width * 0.15,
          center.dy - size.height * 0.15,
        );
      canvas.drawPath(path, arrowPaint);

      // Arrow head pointing right
      final head = Path()
        ..moveTo(center.dx + size.width * 0.12, center.dy - size.height * 0.23)
        ..lineTo(center.dx + size.width * 0.25, center.dy - size.height * 0.15)
        ..lineTo(center.dx + size.width * 0.12, center.dy - size.height * 0.07)
        ..close();
      canvas.drawPath(head, Paint()..color = Colors.black);
    });
  }

  void _paintNoParking(Canvas canvas, Size size, Offset center) {
    _paintProhibitoryBase(canvas, size, center, drawSymbol: () {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'P',
          style: TextStyle(
            color: Colors.black,
            fontSize: size.width * 0.46,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2),
      );
    });
  }

  void _paintNoStopping(Canvas canvas, Size size, Offset center) {
    final radius = size.width * 0.44;

    // Blue circle
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF1976D2));

    // Red ring
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..strokeWidth = size.width * 0.09
          ..style = PaintingStyle.stroke);

    // Red Cross (X)
    final crossPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final dist = radius * 0.68;
    canvas.drawLine(
      Offset(center.dx - dist, center.dy - dist),
      Offset(center.dx + dist, center.dy + dist),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center.dx - dist, center.dy + dist),
      Offset(center.dx + dist, center.dy - dist),
      crossPaint,
    );
  }

  void _paintNoOvertaking(Canvas canvas, Size size, Offset center) {
    _paintProhibitoryBase(canvas, size, center, drawSymbol: () {
      // Right Car (Black)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(center.dx + size.width * 0.03,
              center.dy - size.height * 0.12, size.width * 0.18, size.height * 0.24),
          Radius.circular(size.width * 0.04),
        ),
        Paint()..color = Colors.black,
      );

      // Left Car (Red overtaking car)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(center.dx - size.width * 0.21,
              center.dy - size.height * 0.12, size.width * 0.18, size.height * 0.24),
          Radius.circular(size.width * 0.04),
        ),
        Paint()..color = const Color(0xFFD32F2F),
      );
    });
  }

  void _paintKeepDirection(Canvas canvas, Size size, Offset center,
      {required bool isRight}) {
    final radius = size.width * 0.44;

    // Blue disc
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF1976D2));

    // Diagonal White Arrow
    final arrowPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.08
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final factor = isRight ? 1.0 : -1.0;
    canvas.drawLine(
      Offset(center.dx - factor * size.width * 0.15,
          center.dy - size.height * 0.15),
      Offset(center.dx + factor * size.width * 0.12,
          center.dy + size.height * 0.15),
      arrowPaint,
    );

    // Arrowhead
    final head = Path()
      ..moveTo(
        center.dx + factor * size.width * 0.02,
        center.dy + size.height * 0.20,
      )
      ..lineTo(
        center.dx + factor * size.width * 0.20,
        center.dy + size.height * 0.22,
      )
      ..lineTo(
        center.dx + factor * size.width * 0.18,
        center.dy + size.height * 0.05,
      )
      ..close();
    canvas.drawPath(head, Paint()..color = Colors.white);
  }

  void _paintNoHorn(Canvas canvas, Size size, Offset center) {
    _paintProhibitoryBase(canvas, size, center, drawSymbol: () {
      final hornPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      // Horn horn bell and tube
      final path = Path()
        ..moveTo(center.dx - size.width * 0.15, center.dy - size.height * 0.04)
        ..lineTo(center.dx + size.width * 0.05, center.dy - size.height * 0.08)
        ..lineTo(center.dx + size.width * 0.18, center.dy - size.height * 0.16)
        ..lineTo(center.dx + size.width * 0.18, center.dy + size.height * 0.16)
        ..lineTo(center.dx + size.width * 0.05, center.dy + size.height * 0.08)
        ..lineTo(center.dx - size.width * 0.15, center.dy + size.height * 0.04)
        ..close();
      canvas.drawPath(path, hornPaint);

      // Squeeze bulb
      canvas.drawCircle(
        Offset(center.dx - size.width * 0.18, center.dy),
        size.width * 0.07,
        hornPaint,
      );
    });
  }

  void _paintNoPedestrians(Canvas canvas, Size size, Offset center) {
    _paintProhibitoryBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.05
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Head
      canvas.drawCircle(
        Offset(center.dx, center.dy - size.height * 0.18),
        size.width * 0.05,
        Paint()..color = Colors.black,
      );

      // Body
      canvas.drawLine(
        Offset(center.dx, center.dy - size.height * 0.12),
        Offset(center.dx, center.dy + size.height * 0.05),
        paint,
      );

      // Legs
      canvas.drawLine(
        Offset(center.dx, center.dy + size.height * 0.05),
        Offset(center.dx - size.width * 0.1, center.dy + size.height * 0.22),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy + size.height * 0.05),
        Offset(center.dx + size.width * 0.1, center.dy + size.height * 0.22),
        paint,
      );
    });
  }

  // --- WARNING BASE DIAMOND ---
  void _paintWarningDiamondBase(Canvas canvas, Size size, Offset center,
      {required void Function() drawSymbol, Color? bgColor}) {
    final r = size.width * 0.44;
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r, center.dy)
      ..close();

    // Fill (Yellow/Amber or Orange)
    canvas.drawPath(
      path,
      Paint()
        ..color = bgColor ?? const Color(0xFFFFB300)
        ..style = PaintingStyle.fill,
    );

    // Black border
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.05
        ..style = PaintingStyle.stroke,
    );

    drawSymbol();
  }

  void _paintSharpTurn(Canvas canvas, Size size, Offset center,
      {required bool isLeft}) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.075
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square;

      final factor = isLeft ? -1.0 : 1.0;
      final path = Path()
        ..moveTo(center.dx - factor * size.width * 0.06, center.dy + size.height * 0.18)
        ..lineTo(center.dx - factor * size.width * 0.06, center.dy - size.height * 0.04)
        ..lineTo(center.dx + factor * size.width * 0.14, center.dy - size.height * 0.04);
      canvas.drawPath(path, paint);

      // Arrow head
      final head = Path()
        ..moveTo(center.dx + factor * size.width * 0.12, center.dy - size.height * 0.12)
        ..lineTo(center.dx + factor * size.width * 0.24, center.dy - size.height * 0.04)
        ..lineTo(center.dx + factor * size.width * 0.12, center.dy + size.height * 0.04)
        ..close();
      canvas.drawPath(head, Paint()..color = Colors.black);
    });
  }

  void _paintWindingRoad(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.07
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(center.dx - size.width * 0.08, center.dy + size.height * 0.18)
        ..lineTo(center.dx - size.width * 0.08, center.dy + size.height * 0.06)
        ..quadraticBezierTo(
          center.dx - size.width * 0.08, center.dy - size.height * 0.04,
          center.dx + size.width * 0.08, center.dy - size.height * 0.04,
        )
        ..quadraticBezierTo(
          center.dx + size.width * 0.08, center.dy - size.height * 0.14,
          center.dx - size.width * 0.04, center.dy - size.height * 0.16,
        );
      canvas.drawPath(path, paint);

      final head = Path()
        ..moveTo(center.dx - size.width * 0.14, center.dy - size.height * 0.11)
        ..lineTo(center.dx - size.width * 0.06, center.dy - size.height * 0.22)
        ..lineTo(center.dx + size.width * 0.02, center.dy - size.height * 0.12)
        ..close();
      canvas.drawPath(head, Paint()..color = Colors.black);
    });
  }

  void _paintCrossroad(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.08
        ..strokeCap = StrokeCap.square;

      // Vertical line
      canvas.drawLine(
        Offset(center.dx, center.dy - size.height * 0.22),
        Offset(center.dx, center.dy + size.height * 0.22),
        paint,
      );
      // Horizontal line
      canvas.drawLine(
        Offset(center.dx - size.width * 0.22, center.dy),
        Offset(center.dx + size.width * 0.22, center.dy),
        paint,
      );
    });
  }

  void _paintTJunction(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.08
        ..strokeCap = StrokeCap.square;

      // Top bar
      canvas.drawLine(
        Offset(center.dx - size.width * 0.22, center.dy - size.height * 0.12),
        Offset(center.dx + size.width * 0.22, center.dy - size.height * 0.12),
        paint,
      );
      // Stem
      canvas.drawLine(
        Offset(center.dx, center.dy - size.height * 0.12),
        Offset(center.dx, center.dy + size.height * 0.22),
        paint,
      );
    });
  }

  void _paintNarrowRoad(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.06
        ..strokeCap = StrokeCap.round;

      // Left lane line tapering in
      final leftPath = Path()
        ..moveTo(center.dx - size.width * 0.20, center.dy + size.height * 0.22)
        ..lineTo(center.dx - size.width * 0.20, center.dy + size.height * 0.06)
        ..lineTo(center.dx - size.width * 0.10, center.dy - size.height * 0.06)
        ..lineTo(center.dx - size.width * 0.10, center.dy - size.height * 0.22);
      canvas.drawPath(leftPath, paint..style = PaintingStyle.stroke);

      // Right lane line tapering in
      final rightPath = Path()
        ..moveTo(center.dx + size.width * 0.20, center.dy + size.height * 0.22)
        ..lineTo(center.dx + size.width * 0.20, center.dy + size.height * 0.06)
        ..lineTo(center.dx + size.width * 0.10, center.dy - size.height * 0.06)
        ..lineTo(center.dx + size.width * 0.10, center.dy - size.height * 0.22);
      canvas.drawPath(rightPath, paint);
    });
  }

  void _paintSlipperyRoad(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      // Car chassis
      final car = Path()
        ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(center.dx - size.width * 0.14,
              center.dy - size.height * 0.14, size.width * 0.28, size.height * 0.12),
          Radius.circular(size.width * 0.03),
        ));
      canvas.drawPath(car, Paint()..color = Colors.black);

      // Wavy skid lines
      final skidPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.04
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final skidPath = Path()
        ..moveTo(center.dx - size.width * 0.12, center.dy + size.height * 0.02)
        ..quadraticBezierTo(center.dx - size.width * 0.04, center.dy + size.height * 0.08, center.dx - size.width * 0.12, center.dy + size.height * 0.18)
        ..moveTo(center.dx + size.width * 0.08, center.dy + size.height * 0.02)
        ..quadraticBezierTo(center.dx + size.width * 0.16, center.dy + size.height * 0.08, center.dx + size.width * 0.08, center.dy + size.height * 0.18);
      canvas.drawPath(skidPath, skidPaint);
    });
  }

  void _paintSteepDescent(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      // Incline wedge
      final wedge = Path()
        ..moveTo(center.dx - size.width * 0.22, center.dy + size.height * 0.18)
        ..lineTo(center.dx + size.width * 0.22, center.dy + size.height * 0.18)
        ..lineTo(center.dx - size.width * 0.22, center.dy - size.height * 0.08)
        ..close();
      canvas.drawPath(wedge, Paint()..color = Colors.black);

      // Car on slope
      final car = Path()
        ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(center.dx - size.width * 0.08,
              center.dy - size.height * 0.05, size.width * 0.18, size.height * 0.08),
          Radius.circular(size.width * 0.02),
        ));
      canvas.drawPath(car, Paint()..color = Colors.black);
    });
  }

  void _paintFallingRocks(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      // Cliff on left
      final cliff = Path()
        ..moveTo(center.dx - size.width * 0.24, center.dy - size.height * 0.22)
        ..lineTo(center.dx - size.width * 0.08, center.dy - size.height * 0.22)
        ..lineTo(center.dx - size.width * 0.14, center.dy + size.height * 0.22)
        ..lineTo(center.dx - size.width * 0.24, center.dy + size.height * 0.22)
        ..close();
      canvas.drawPath(cliff, Paint()..color = Colors.black);

      // Falling rocks
      final rockPaint = Paint()..color = Colors.black;
      canvas.drawCircle(Offset(center.dx + size.width * 0.05, center.dy - size.height * 0.08), size.width * 0.035, rockPaint);
      canvas.drawCircle(Offset(center.dx + size.width * 0.12, center.dy + size.height * 0.02), size.width * 0.045, rockPaint);
      canvas.drawCircle(Offset(center.dx + size.width * 0.02, center.dy + size.height * 0.12), size.width * 0.03, rockPaint);
    });
  }

  void _paintTrafficSignals(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      // Black rectangle box
      final box = RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: size.width * 0.16, height: size.height * 0.38),
        Radius.circular(size.width * 0.03),
      );
      canvas.drawRRect(box, Paint()..color = Colors.black);

      // Red light
      canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.11), size.width * 0.045, Paint()..color = Colors.red);
      // Yellow light
      canvas.drawCircle(Offset(center.dx, center.dy), size.width * 0.045, Paint()..color = Colors.amber);
      // Green light
      canvas.drawCircle(Offset(center.dx, center.dy + size.height * 0.11), size.width * 0.045, Paint()..color = Colors.green);
    });
  }

  void _paintRoundabout(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.05
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, size.width * 0.15, paint);

      // Circular arrows
      final arrowHead = Paint()..color = Colors.black;
      final h1 = Path()
        ..moveTo(center.dx + size.width * 0.15, center.dy - size.height * 0.08)
        ..lineTo(center.dx + size.width * 0.22, center.dy)
        ..lineTo(center.dx + size.width * 0.10, center.dy)
        ..close();
      canvas.drawPath(h1, arrowHead);
    });
  }

  void _paintPedestrianCrossing(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.045
        ..strokeCap = StrokeCap.round;

      // Head
      canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.14), size.width * 0.045, Paint()..color = Colors.black);
      // Body
      canvas.drawLine(Offset(center.dx, center.dy - size.height * 0.09), Offset(center.dx - size.width * 0.02, center.dy + size.height * 0.06), paint);
      // Walking legs
      canvas.drawLine(Offset(center.dx - size.width * 0.02, center.dy + size.height * 0.06), Offset(center.dx - size.width * 0.12, center.dy + size.height * 0.18), paint);
      canvas.drawLine(Offset(center.dx - size.width * 0.02, center.dy + size.height * 0.06), Offset(center.dx + size.width * 0.08, center.dy + size.height * 0.18), paint);
      // Ground zebra line
      canvas.drawLine(Offset(center.dx - size.width * 0.18, center.dy + size.height * 0.20), Offset(center.dx + size.width * 0.18, center.dy + size.height * 0.20), paint..strokeWidth = size.width * 0.03);
    });
  }

  void _paintSchoolZone(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.04
        ..strokeCap = StrokeCap.round;

      // Child 1 (Taller)
      canvas.drawCircle(Offset(center.dx - size.width * 0.06, center.dy - size.height * 0.15), size.width * 0.04, Paint()..color = Colors.black);
      canvas.drawLine(Offset(center.dx - size.width * 0.06, center.dy - size.height * 0.11), Offset(center.dx - size.width * 0.06, center.dy + size.height * 0.06), paint);
      canvas.drawLine(Offset(center.dx - size.width * 0.06, center.dy + size.height * 0.06), Offset(center.dx - size.width * 0.14, center.dy + size.height * 0.18), paint);
      canvas.drawLine(Offset(center.dx - size.width * 0.06, center.dy + size.height * 0.06), Offset(center.dx, center.dy + size.height * 0.18), paint);

      // Child 2 (Smaller)
      canvas.drawCircle(Offset(center.dx + size.width * 0.09, center.dy - size.height * 0.08), size.width * 0.035, Paint()..color = Colors.black);
      canvas.drawLine(Offset(center.dx + size.width * 0.09, center.dy - size.height * 0.04), Offset(center.dx + size.width * 0.09, center.dy + size.height * 0.08), paint);
      canvas.drawLine(Offset(center.dx + size.width * 0.09, center.dy + size.height * 0.08), Offset(center.dx + size.width * 0.04, center.dy + size.height * 0.18), paint);
      canvas.drawLine(Offset(center.dx + size.width * 0.09, center.dy + size.height * 0.08), Offset(center.dx + size.width * 0.15, center.dy + size.height * 0.18), paint);
    });
  }

  void _paintRailroadCrossing(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final crossPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.075
        ..strokeCap = StrokeCap.square;

      final dist = size.width * 0.18;
      canvas.drawLine(Offset(center.dx - dist, center.dy - dist), Offset(center.dx + dist, center.dy + dist), crossPaint);
      canvas.drawLine(Offset(center.dx - dist, center.dy + dist), Offset(center.dx + dist, center.dy - dist), crossPaint);
    });
  }

  void _paintTwoWayTraffic(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.06
        ..strokeCap = StrokeCap.round;

      // Up arrow (Right side)
      canvas.drawLine(Offset(center.dx + size.width * 0.08, center.dy + size.height * 0.18), Offset(center.dx + size.width * 0.08, center.dy - size.height * 0.14), paint);
      final headUp = Path()
        ..moveTo(center.dx + size.width * 0.02, center.dy - size.height * 0.08)
        ..lineTo(center.dx + size.width * 0.08, center.dy - size.height * 0.20)
        ..lineTo(center.dx + size.width * 0.14, center.dy - size.height * 0.08)
        ..close();
      canvas.drawPath(headUp, Paint()..color = Colors.black);

      // Down arrow (Left side)
      canvas.drawLine(Offset(center.dx - size.width * 0.08, center.dy - size.height * 0.18), Offset(center.dx - size.width * 0.08, center.dy + size.height * 0.14), paint);
      final headDown = Path()
        ..moveTo(center.dx - size.width * 0.14, center.dy + size.height * 0.08)
        ..lineTo(center.dx - size.width * 0.08, center.dy + size.height * 0.20)
        ..lineTo(center.dx - size.width * 0.02, center.dy + size.height * 0.08)
        ..close();
      canvas.drawPath(headDown, Paint()..color = Colors.black);
    });
  }

  // --- INFORMATIVE HELPERS ---
  void _paintInfoLetter(Canvas canvas, Size size, String letter, Color bgColor) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.08, size.width * 0.84, size.height * 0.84),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(rect, Paint()..color = bgColor);

    // Inner white border
    canvas.drawRRect(
      rect,
      Paint()
        ..color = Colors.white
        ..strokeWidth = size.width * 0.03
        ..style = PaintingStyle.stroke,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.52,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2),
    );
  }

  void _paintFirstAid(Canvas canvas, Size size, Offset center) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.08, size.width * 0.84, size.height * 0.84),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.blue.shade700);

    // White Cross
    final crossPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.14
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(Offset(center.dx, center.dy - size.height * 0.22), Offset(center.dx, center.dy + size.height * 0.22), crossPaint);
    canvas.drawLine(Offset(center.dx - size.width * 0.22, center.dy), Offset(center.dx + size.width * 0.22, center.dy), crossPaint);
  }

  void _paintOneWayHorizontal(Canvas canvas, Size size, {required bool isRight}) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.05, size.height * 0.20, size.width * 0.90, size.height * 0.60),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.black);

    // Arrow
    final arrowPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.10
      ..strokeCap = StrokeCap.square;

    final factor = isRight ? 1.0 : -1.0;
    canvas.drawLine(
      Offset(size.width * 0.5 - factor * size.width * 0.25, size.height * 0.5),
      Offset(size.width * 0.5 + factor * size.width * 0.20, size.height * 0.5),
      arrowPaint,
    );

    final head = Path()
      ..moveTo(size.width * 0.5 + factor * size.width * 0.12, size.height * 0.32)
      ..lineTo(size.width * 0.5 + factor * size.width * 0.35, size.height * 0.50)
      ..lineTo(size.width * 0.5 + factor * size.width * 0.12, size.height * 0.68)
      ..close();
    canvas.drawPath(head, Paint()..color = Colors.white);
  }

  void _paintOneWayStraight(Canvas canvas, Size size, Offset center) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.05, size.width * 0.70, size.height * 0.90),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.blue.shade700);

    // Arrow Up
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(Offset(center.dx, center.dy + size.height * 0.24), Offset(center.dx, center.dy - size.height * 0.18), paint);

    final head = Path()
      ..moveTo(center.dx - size.width * 0.16, center.dy - size.height * 0.10)
      ..lineTo(center.dx, center.dy - size.height * 0.28)
      ..lineTo(center.dx + size.width * 0.16, center.dy - size.height * 0.10)
      ..close();
    canvas.drawPath(head, Paint()..color = Colors.white);
  }

  void _paintBusStop(Canvas canvas, Size size, Offset center) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.08, size.width * 0.84, size.height * 0.84),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.blue.shade700);

    // Bus body
    final busRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - size.width * 0.22, center.dy - size.height * 0.20, size.width * 0.44, size.height * 0.38),
      Radius.circular(size.width * 0.06),
    );
    canvas.drawRRect(busRect, Paint()..color = Colors.white);

    // Windshield
    final winRect = Rect.fromLTWH(center.dx - size.width * 0.18, center.dy - size.height * 0.16, size.width * 0.36, size.height * 0.14);
    canvas.drawRect(winRect, Paint()..color = Colors.blue.shade700);

    // Wheels
    canvas.drawCircle(Offset(center.dx - size.width * 0.12, center.dy + size.height * 0.22), size.width * 0.04, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(center.dx + size.width * 0.12, center.dy + size.height * 0.22), size.width * 0.04, Paint()..color = Colors.white);
  }

  void _paintDisabledAccess(Canvas canvas, Size size, Offset center) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.08, size.width * 0.84, size.height * 0.84),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.blue.shade700);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.05
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Head
    canvas.drawCircle(Offset(center.dx + size.width * 0.04, center.dy - size.height * 0.16), size.width * 0.045, Paint()..color = Colors.white);

    // Wheel arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx - size.width * 0.04, center.dy + size.height * 0.06), radius: size.width * 0.14),
      math.pi * 0.3,
      math.pi * 1.3,
      false,
      paint,
    );

    // Spine & feet
    canvas.drawLine(Offset(center.dx + size.width * 0.04, center.dy - size.height * 0.08), Offset(center.dx + size.width * 0.02, center.dy + size.height * 0.06), paint);
    canvas.drawLine(Offset(center.dx + size.width * 0.02, center.dy + size.height * 0.06), Offset(center.dx + size.width * 0.18, center.dy + size.height * 0.06), paint);
  }

  void _paintFuelStation(Canvas canvas, Size size, Offset center) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.08, size.width * 0.84, size.height * 0.84),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.blue.shade700);

    // Pump body
    final pump = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - size.width * 0.18, center.dy - size.height * 0.18, size.width * 0.24, size.height * 0.38),
      Radius.circular(size.width * 0.03),
    );
    canvas.drawRRect(pump, Paint()..color = Colors.white);

    // Pump screen
    canvas.drawRect(
      Rect.fromLTWH(center.dx - size.width * 0.14, center.dy - size.height * 0.14, size.width * 0.16, size.height * 0.12),
      Paint()..color = Colors.blue.shade700,
    );

    // Hose & Nozzle
    final hosePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.035
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(center.dx + size.width * 0.06, center.dy - size.height * 0.08), Offset(center.dx + size.width * 0.16, center.dy - size.height * 0.02), hosePaint);
    canvas.drawLine(Offset(center.dx + size.width * 0.16, center.dy - size.height * 0.02), Offset(center.dx + size.width * 0.16, center.dy + size.height * 0.12), hosePaint);
  }

  void _paintExpresswayExit(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.05, size.height * 0.12, size.width * 0.90, size.height * 0.76),
      Radius.circular(size.width * 0.08),
    );
    // Green expressway background
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF2E7D32));

    // White border
    canvas.drawRRect(
      rect,
      Paint()
        ..color = Colors.white
        ..strokeWidth = size.width * 0.03
        ..style = PaintingStyle.stroke,
    );

    // EXIT Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'EXIT',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.14, size.height * 0.35));

    // Angled Arrow pointing up-right
    final arrowPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(Offset(size.width * 0.62, size.height * 0.62), Offset(size.width * 0.78, size.height * 0.36), arrowPaint);
    final head = Path()
      ..moveTo(size.width * 0.66, size.height * 0.32)
      ..lineTo(size.width * 0.84, size.height * 0.30)
      ..lineTo(size.width * 0.82, size.height * 0.48)
      ..close();
    canvas.drawPath(head, Paint()..color = Colors.white);
  }

  void _paintPedestrianOverpass(Canvas canvas, Size size, Offset center) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.08, size.width * 0.84, size.height * 0.84),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.blue.shade700);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.05
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    // Steps staircase path
    final steps = Path()
      ..moveTo(center.dx - size.width * 0.26, center.dy + size.height * 0.18)
      ..lineTo(center.dx - size.width * 0.14, center.dy + size.height * 0.18)
      ..lineTo(center.dx - size.width * 0.14, center.dy + size.height * 0.06)
      ..lineTo(center.dx - size.width * 0.02, center.dy + size.height * 0.06)
      ..lineTo(center.dx - size.width * 0.02, center.dy - size.height * 0.06)
      ..lineTo(center.dx + size.width * 0.22, center.dy - size.height * 0.06);
    canvas.drawPath(steps, paint);

    // Stick person on bridge
    canvas.drawCircle(Offset(center.dx + size.width * 0.10, center.dy - size.height * 0.18), size.width * 0.035, Paint()..color = Colors.white);
    canvas.drawLine(Offset(center.dx + size.width * 0.10, center.dy - size.height * 0.14), Offset(center.dx + size.width * 0.10, center.dy - size.height * 0.06), paint);
  }

  // --- ROAD WORK PAINTERS ---
  void _paintRoadWorkWorker(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, bgColor: const Color(0xFFFF6D00), drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.045
        ..strokeCap = StrokeCap.round;

      // Worker head
      canvas.drawCircle(Offset(center.dx - size.width * 0.04, center.dy - size.height * 0.14), size.width * 0.045, Paint()..color = Colors.black);
      // Torso bending forward
      canvas.drawLine(Offset(center.dx - size.width * 0.04, center.dy - size.height * 0.09), Offset(center.dx - size.width * 0.08, center.dy + size.height * 0.04), paint);
      // Legs
      canvas.drawLine(Offset(center.dx - size.width * 0.08, center.dy + size.height * 0.04), Offset(center.dx - size.width * 0.18, center.dy + size.height * 0.18), paint);
      canvas.drawLine(Offset(center.dx - size.width * 0.08, center.dy + size.height * 0.04), Offset(center.dx + size.width * 0.02, center.dy + size.height * 0.18), paint);
      // Shovel handle & pile
      canvas.drawLine(Offset(center.dx - size.width * 0.02, center.dy - size.height * 0.02), Offset(center.dx + size.width * 0.16, center.dy + size.height * 0.16), paint);
      // Mound of earth
      final mound = Path()
        ..moveTo(center.dx + size.width * 0.10, center.dy + size.height * 0.20)
        ..quadraticBezierTo(center.dx + size.width * 0.18, center.dy + size.height * 0.12, center.dx + size.width * 0.26, center.dy + size.height * 0.20)
        ..close();
      canvas.drawPath(mound, Paint()..color = Colors.black);
    });
  }

  void _paintDetour(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.05, size.height * 0.20, size.width * 0.90, size.height * 0.60),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFFF6D00));
    canvas.drawRRect(rect, Paint()..color = Colors.black..strokeWidth = size.width * 0.03..style = PaintingStyle.stroke);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'DETOUR',
        style: TextStyle(
          color: Colors.black,
          fontSize: size.width * 0.18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.10, size.height * 0.38));

    // Right Arrow
    final head = Path()
      ..moveTo(size.width * 0.72, size.height * 0.35)
      ..lineTo(size.width * 0.88, size.height * 0.50)
      ..lineTo(size.width * 0.72, size.height * 0.65)
      ..close();
    canvas.drawPath(head, Paint()..color = Colors.black);
  }

  void _paintRoadClosed(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.05, size.height * 0.18, size.width * 0.90, size.height * 0.64),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.white);
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFD32F2F)..strokeWidth = size.width * 0.05..style = PaintingStyle.stroke);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'ROAD\nCLOSED',
        style: TextStyle(
          color: Colors.black,
          fontSize: size.width * 0.18,
          fontWeight: FontWeight.w900,
          height: 1.1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2),
    );
  }

  void _paintFlagman(Canvas canvas, Size size, Offset center) {
    _paintWarningDiamondBase(canvas, size, center, bgColor: const Color(0xFFFF6D00), drawSymbol: () {
      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = size.width * 0.045
        ..strokeCap = StrokeCap.round;

      // Flagman figure
      canvas.drawCircle(Offset(center.dx - size.width * 0.06, center.dy - size.height * 0.14), size.width * 0.04, Paint()..color = Colors.black);
      canvas.drawLine(Offset(center.dx - size.width * 0.06, center.dy - size.height * 0.10), Offset(center.dx - size.width * 0.06, center.dy + size.height * 0.08), paint);
      // Legs
      canvas.drawLine(Offset(center.dx - size.width * 0.06, center.dy + size.height * 0.08), Offset(center.dx - size.width * 0.14, center.dy + size.height * 0.20), paint);
      canvas.drawLine(Offset(center.dx - size.width * 0.06, center.dy + size.height * 0.08), Offset(center.dx + size.width * 0.02, center.dy + size.height * 0.20), paint);

      // Arm holding flag horizontally
      canvas.drawLine(Offset(center.dx - size.width * 0.06, center.dy - size.height * 0.04), Offset(center.dx + size.width * 0.18, center.dy - size.height * 0.04), paint);
      // Flag banner
      final flag = Path()
        ..moveTo(center.dx + size.width * 0.18, center.dy - size.height * 0.04)
        ..lineTo(center.dx + size.width * 0.18, center.dy + size.height * 0.10)
        ..lineTo(center.dx + size.width * 0.08, center.dy + size.height * 0.03)
        ..close();
      canvas.drawPath(flag, Paint()..color = Colors.black);
    });
  }

  void _paintGenericSign(Canvas canvas, Size size, Offset center) {
    final radius = size.width * 0.44;
    canvas.drawCircle(center, radius, Paint()..color = Colors.blueGrey.shade700);
    final textPainter = TextPainter(
      text: TextSpan(
        text: '!',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.50,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant RoadSignPainter oldDelegate) =>
      oldDelegate.signType != signType;
}
