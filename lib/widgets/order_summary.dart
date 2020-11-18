import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';

import '../main.dart';



enum SummaryTheme { dark, light }

class OrderSummary extends StatelessWidget {
  final OrderData boardingPass;
  final SummaryTheme theme;
  final bool isOpen;

  const OrderSummary({Key key, this.boardingPass, this.theme = SummaryTheme.light, this.isOpen = false}) : super(key: key);

  Color get mainTextColor {
    Color textColor;
    if (theme == SummaryTheme.dark) textColor = Colors.white;
    if (theme == SummaryTheme.light) textColor = Color(0xFF083e64);
    return textColor;
  }

  Color get secondaryTextColor {
    Color textColor;
    if (theme == SummaryTheme.dark) textColor = Color(0xff61849c);
    if (theme == SummaryTheme.light) textColor = Color(0xFF838383);
    return textColor;
  }

  Color get separatorColor {
    Color color;
    if (theme == SummaryTheme.light) color = Color(0xffeaeaea);
    if (theme == SummaryTheme.dark) color = Color(0xff396583);
    return color;
  }

  TextStyle get bodyTextStyle => TextStyle(color: mainTextColor, fontSize: 13, fontFamily: 'Oswald');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getBackgroundDecoration(),
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildLogoHeader(),
            _buildSeparationLine(),
            _buildTicketHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Stack(
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: _buildTicketOrigin()),
                  Align(alignment: Alignment.centerRight, child: _buildTicketDuration()),
                ],
              ),
            ),
            _buildBottomIcon()
          ],
        ),
      ),
    );
  }

  _getBackgroundDecoration() {
    if (theme == SummaryTheme.light)
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      );
    if (theme == SummaryTheme.dark)
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: AppColors.secondaryText
      );
  }

  _buildLogoHeader() {
    if (theme == SummaryTheme.light)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Fresquisima'.toUpperCase(),
              style: TextStyle(
                  color: mainTextColor,
                  fontFamily: 'OpenSans',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5))
        ],
      );
    else
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Fresquisima'.toUpperCase(),
              style: TextStyle(
                  color: AppColors.primaryShadow,
                  fontFamily: 'OpenSans',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5))
        ],
      );
  }

  Widget _buildSeparationLine() {
    return Container(
      width: double.infinity,
      height: 1,
      color: separatorColor,
    );
  }

  Widget _buildTicketHeader(context) {

    var headerStyle =
    TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryColor);
    if (theme == SummaryTheme.dark)
      {
        headerStyle=TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.headingText);
      }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Ordenado el ", style: headerStyle),
        Text('${boardingPass.date}', style: headerStyle),
      ],
    );
  }

  Widget _buildTicketOrigin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            "direccion de entrega",style: bodyTextStyle.copyWith(color: secondaryTextColor)
          ),
        ),
        Text(boardingPass.address, style: bodyTextStyle.copyWith(fontSize: 21),),
      ],
    );
  }

  Widget _buildTicketDuration() {
    String planeRoutePath;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 120,
            height: 58,
            child: Stack(),
          ),
          Text("Total: "+boardingPass.total, textAlign: TextAlign.center, style: bodyTextStyle),
        ],
      ),
    );
  }


  Widget _buildBottomIcon() {
    IconData icon;
    if (theme == SummaryTheme.light) icon = Icons.keyboard_arrow_down;
    if (theme == SummaryTheme.dark) icon = Icons.keyboard_arrow_up;
    return Icon(
      icon,
      color: mainTextColor,
      size: 18,
    );
  }
}

class _AnimatedSlideToRight extends StatefulWidget {
  final Widget child;
  final bool isOpen;

  const _AnimatedSlideToRight({Key key, this.child, @required this.isOpen}) : super(key: key);

  @override
  _AnimatedSlideToRightState createState() => _AnimatedSlideToRightState();
}

class _AnimatedSlideToRightState extends State<_AnimatedSlideToRight> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1700));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen) _controller.forward(from: 0);
    return SlideTransition(
      position: Tween(begin: Offset(-2, 0), end: Offset(1, 0)).animate(CurvedAnimation(curve: Curves.easeOutQuad, parent: _controller)),
      child: widget.child,
    );
  }
}