
import 'package:flutter/material.dart';
import 'package:fresquisima/values/data.dart';
import 'package:intl/intl.dart';



class OrderDetails extends StatelessWidget {
  final OrderData boardingPass;
  final TextStyle titleTextStyle = TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 11,
      height: 1,
      letterSpacing: .2,
      fontWeight: FontWeight.w600,
      color: Color(0xffafafaf),
     );
  final TextStyle contentTextStyle =
  TextStyle(fontFamily: 'Oswald', fontSize: 16, height: 1.8, letterSpacing: .3, color: Color(0xff083e64),);

  OrderDetails(this.boardingPass);

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4.0),
    ),
    width: double.infinity,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: boardingPass.products.length,
            itemBuilder: (BuildContext context,int index){
              return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Text(boardingPass.products[index], style: contentTextStyle),
              ]);
            },
          ),
        ),
         Text("Cerrar"),
        SizedBox(height: 10,)
      ],
    ),
  );
}