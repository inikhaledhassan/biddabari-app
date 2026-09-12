import 'dart:async';

import 'package:flutter/material.dart';

class DiscountCountdown extends StatefulWidget {
  final String endDate;
  final TextStyle? style;
  final String prefix;
  final String expiredText;

  const DiscountCountdown({
    super.key,
    required this.endDate,
    this.style,
    this.prefix = 'অফার শেষ হতে বাকি ',
    this.expiredText = 'অফার শেষ হয়ে গেছে',
  });

  @override
  State<DiscountCountdown> createState() => _DiscountCountdownState();
}

class _DiscountCountdownState extends State<DiscountCountdown> {
  Timer? _timer;
  DateTime? _endDate;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _endDate = _parse(widget.endDate);
    _updateRemaining();
    if (_endDate != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateRemaining();
      });
    }
  }

  DateTime? _parse(String value) {
    if (value.isEmpty) return null;
    try {
      return DateTime.parse(value.replaceFirst(' ', 'T'));
    } catch (e) {
      return null;
    }
  }

  void _updateRemaining() {
    final endDate = _endDate;
    if (endDate == null) return;
    final remaining = endDate.difference(DateTime.now());
    if (!mounted) return;
    setState(() {
      _remaining = remaining.isNegative ? Duration.zero : remaining;
    });
    if (remaining.isNegative) {
      _timer?.cancel();
    }
  }

  String _format(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    final hh = hours.toString().padLeft(2, '0');
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    if (days > 0) return '${days}d ${hh}h ${mm}m';
    if (hours > 0) return '${hh}h ${mm}m ${ss}s';
    if (minutes > 0) return '${mm}m ${ss}s';
    return '${ss}s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_endDate == null) return const SizedBox.shrink();
    final defaultStyle = TextStyle(fontSize: 12, color: Colors.red.shade400);
    if (_remaining == Duration.zero) {
      return Text(widget.expiredText, style: widget.style ?? defaultStyle);
    }
    return Text(
      '${widget.prefix}${_format(_remaining)}',
      style: widget.style ?? defaultStyle,
    );
  }
}
