import 'package:flutter/material.dart';
import 'package:fresquisima/routes/AppRouter.gr.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';
import 'package:fresquisima/widgets/cartItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget{
  static const int TAB_NO = 1;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  bool _loggedIn=false;




  Widget build(BuildContext context) {

    List _carritolist = carrito.keys.toList();

    SharedPreferences.getInstance().then((value) => {
    if(value.getBool("loggedIn")==null)
    {
          setState(() {
        _loggedIn = false;
      })
    }
    else
    {
      setState(() {
      _loggedIn = value.getBool("loggedIn");
      })
    }
    });

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
                  _loggedIn?
                  ElevatedButton(
                    child: Text("ir a pago >>",style: TextStyle(color: Colors.white),),
                    onPressed: _carritolist.length>0?()=>{
                      AppRouter.navigator.pushNamed(AppRouter.paymentScreen)
                    }
                        :null
                  ):
                  ElevatedButton(
                      child: Text("Iniciar Sesion >>",style: TextStyle(color: Colors.white),),
                      onPressed: ()=>{
                        AppRouter.navigator.pushNamed(AppRouter.splashScreen)
                      }
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