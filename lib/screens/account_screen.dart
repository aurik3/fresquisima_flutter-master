import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fresquisima/routes/AppRouter.gr.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';
import 'package:fresquisima/widgets/order.dart';

class AccountScreen extends StatefulWidget{
  static const int TAB_NO = 2;

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  _AccountScreenState(){
    name= prefs.getString("name");
    mail=prefs.getString("mail");
  }

  final List<OrderData> _boardingPasses = orderHistory;

  final Color _backgroundColor = Color(0xFFf0f0f0);

  final ScrollController _scrollController = ScrollController();

  final List<int> _openTickets = [];

  bool _areOrdersLoaded=false;


  Widget build(BuildContext context) {

    getOrders().then((value) => {
      if(this.mounted)
        {
          setState((){
            _areOrdersLoaded = true;
          })
        }
    });

    return !_areOrdersLoaded? Center(child: CircularProgressIndicator(),):Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              profileurl.length>0?
              Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              profileurl)
                      )
                  )):
              Image.asset(ImagePath.user,width: 100,),
              SizedBox(height: 10,),
              Text(name),
              SizedBox(height: 10,),
              Text(mail),
              SizedBox(height: 10,),
              RaisedButton(onPressed: ()=>{
                prefs.setBool("loggedIn", false),
                AppRouter.navigator.pushNamed(
                  AppRouter.loginScreen
                )
              },
                child: Text("CERRAR SESIÓN"),
              )
              ,
              Expanded(
                child: Flex(direction: Axis.vertical, children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: _boardingPasses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OrderUI(
                          boardingPass: _boardingPasses.elementAt(index),
                          onClick: () => _handleClickedTicket(index),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ],
          ),
        )
    );
  }
  bool _handleClickedTicket(int clickedTicket) {
    // Scroll to ticket position
    // Add or remove the item of the list of open tickets
    _openTickets.contains(clickedTicket) ? _openTickets.remove(clickedTicket) : _openTickets.add(clickedTicket);

    // Calculate heights of the open and closed elements before the clicked item
    double openTicketsOffset = OrderUI.nominalOpenHeight * _getOpenTicketsBefore(clickedTicket);
    double closedTicketsOffset = OrderUI.nominalClosedHeight * (clickedTicket - _getOpenTicketsBefore(clickedTicket));

    double offset = openTicketsOffset + closedTicketsOffset - (OrderUI.nominalClosedHeight * .5);

    // Scroll to the clicked element
    _scrollController.animateTo(max(0, offset), duration: Duration(seconds: 1), curve: Interval(.25, 1, curve: Curves.easeOutQuad));
    // Return true to stop the notification propagation
    return true;
  }

  _getOpenTicketsBefore(int ticketIndex) {
    // Search all indexes that are smaller to the current index in the list of indexes of open tickets
    return _openTickets.where((int index) => index < ticketIndex).length;
  }

}