import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fresquisima/routes/AppRouter.gr.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';

class CartManagement extends StatefulWidget{

  final Product product;
  int units= 1;
  CartManagement({
    @required
    this.product
  }){
   if(carrito.containsKey(product)){
     this.units=carrito[product];
   }
  }

  @override
  _CartManagementState createState() => _CartManagementState(units);
}

class _CartManagementState extends State<CartManagement> {

  _CartManagementState(int units){
    _units=units;
  }
  int _units=1;
  int _price=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.product.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40
            ),
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.network(widget.product.image),
            ),
            SizedBox(height: 20,),
            Text(widget.product.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: ()=>{
                   if(_units>1)
                     {
                       setState((){
                         _units--;
                       })
                     }
                  },
                ),
                Text(_units.toString()),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: ()=>{
                    setState((){
                      _units++;
                    })
                  },
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text(
                formater.format(widget.product.price*_units)
            ),
            SizedBox(height: 20,),
            RaisedButton(
              child: Text("AGREGAR AL CARRITO",style: TextStyle(color: AppColors.primaryColor),),
              onPressed: ()=>{
                  updateCart(widget.product, _units),
                  AppRouter.navigator.pop()
              },
            )
          ],
        ),
      ),
    );
  }
}