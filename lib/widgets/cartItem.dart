
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fresquisima/routes/router.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:fresquisima/screens/cart_management_screen.dart';
import 'package:fresquisima/theme.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';

class CartItem extends StatefulWidget
{
  final Product product;
  VoidCallback callback;
  CartItem({
    this.product,this.callback
  });


  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    int _units = carrito[widget.product];

    return Flex(
        direction: Axis.horizontal,
        children:<Widget>[
          Expanded(
            child:Card(
              clipBehavior: Clip.hardEdge,
              elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10,height: 80,),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(

                        onTap: ()=>{
                          Router.navigator.pushNamed(
                              Router.rootScreen,arguments:CurrentScreen(
                              currentScreen: CartManagement(product: widget.product,),
                              tab_no: 0
                          )).then((value) => {setState((){}),widget.callback()})
                        },
                        child: Container(
                          width: 200,
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              widget.product.image)
                                      )
                                  )),
                              SizedBox(width: 10,),
                              Expanded(
                                child:     Column(
                                  children: <Widget>[
                                    SizedBox(width: 150,),

                                    AutoSizeText(widget.product.name,overflow: TextOverflow.ellipsis,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        AutoSizeText(carrito[widget.product].toString()),
                                        SizedBox(width: 30,),
                                        AutoSizeText(formater.format(carrito[widget.product]*widget.product.price)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 1,
                        child: GestureDetector(
                          onTap: ()=>{
                          carrito.remove(widget.product),
                            widget.callback()
                          },
                          child:  Container(
                              height: 80,
                              color: Colors.redAccent,
                              child: Icon(Icons.delete,color: white,size: 50,)
                          ),
                        )
                    )
                  ],
                ),
            )
          )

        ],
    );
  }
}