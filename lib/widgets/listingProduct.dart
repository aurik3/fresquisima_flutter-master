
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fresquisima/routes/router.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:fresquisima/screens/cart_management_screen.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';

class ListingProduct extends StatefulWidget
{
  final Product product;
  ListingProduct({this.product});

  @override
  _ListingProductState createState() => _ListingProductState();
}

class _ListingProductState extends State<ListingProduct> {
  @override
  Widget build(BuildContext context) {
    bool isInCart= carrito.containsKey(widget.product);

    return Flex(
        direction: Axis.horizontal,
        children:<Widget>[
          Expanded(
            child:
                GestureDetector(
                  onTap: ()=>{
                  Router.navigator.pushNamed(
                  Router.rootScreen,arguments:CurrentScreen(
                  currentScreen: CartManagement(product: widget.product,),
                  tab_no: 0
                  )).then((value) => setState((){}))
                  },
                    child:   Card(
            elevation: 10,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child:AutoSizeText(widget.product.toString(),maxLines: 2,textAlign: TextAlign.center,),),
                  SizedBox(height: 10,),
                  Expanded(
                    child: Image.network(widget.product.image,fit: BoxFit.fitHeight,),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(formater.format(widget.product.price)),
                      isInCart?Icon(Icons.add_shopping_cart,color: AppColors.secondaryColor):Container()
                    ],
                  )

                ],
              ),
            )
        ),
                  )
          )

        ],
    );
  }
}