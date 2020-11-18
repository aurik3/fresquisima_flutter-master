import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fresquisima/values/data.dart';


import 'folding_order.dart';
import 'order_details.dart';
import 'order_summary.dart';

class OrderUI extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final OrderData boardingPass;
  final Function onClick;

  const OrderUI({Key key, @required this.boardingPass, @required this.onClick}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _OrderUIState();
}

class _OrderUIState extends State<OrderUI> {
  OrderSummary frontCard;
  OrderSummary topCard;
  OrderDetails middleCard;
  bool _isOpen;

  Widget get backCard =>
      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Color(0xffdce6ef)));

  @override
  void initState() {
    super.initState();
    _isOpen = false;
    frontCard = OrderSummary(boardingPass: widget.boardingPass);
    middleCard = OrderDetails(widget.boardingPass);
  }

  @override
  Widget build(BuildContext context) {
    return FoldingOrder(entries: _getEntries(), isOpen: _isOpen, onClick: _handleOnTap);
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: 160.0, front: topCard),
      FoldEntry(height: 160.0, front: middleCard, back: frontCard),
    ];
  }

  void _handleOnTap() {
    widget.onClick();
    setState(() {
      _isOpen = !_isOpen;
      topCard = OrderSummary(boardingPass: widget.boardingPass, theme: SummaryTheme.dark, isOpen: _isOpen);
    });
  }
}