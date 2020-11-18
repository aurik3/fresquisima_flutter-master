import 'package:flutter/material.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';
import 'package:fresquisima/widgets/cartItem.dart';

class CartScreen extends StatefulWidget{
  static const int TAB_NO = 1;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Widget build(BuildContext context) {
    List _carritolist=carrito.keys.toList();

    return Scaffold(
        body: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(child: Image.asset(ImagePath.vegetable_bg_short,fit: BoxFit.fitWidth,),),
                  Center(heightFactor: 1,
                    child: Image.asset(ImagePath.fresquisima_logo,height: 100,),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Center(

                child: Text("CARRITO"),
              ),
              Expanded(

                  child: Container(
                    child: ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(_carritolist.length, (index) {
                        return Center(
                          child: CartItem(product: _carritolist[index],callback:()=>{setState((){})}),
                        );
                      }),
                    ),
                  )
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Total: "+getTotalPrice()),
                  RaisedButton(
                    child: Text("ir a pago >>",style: TextStyle(color: AppColors.white),),
                    onPressed: _carritolist.length>0?()=>{
                      Router.navigator.pushNamed(Router.paymentScreen)
                    }
                        :null
                  ),
                ],
              ),
              SizedBox(height: 20,)
            ],
          ),
        )
    );
  }
}