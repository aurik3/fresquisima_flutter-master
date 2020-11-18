import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:fresquisima/theme.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget{
  @override
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController(  text :prefs.getString("lastAddress") ?? "");

  bool submittedOnce=false;
  
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PaymentScreenState();
  final List<bool> isSelected = [true,false];
  bool _isInPayU=false;
  String _reference;
  String sugested = "";

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    if(prefs.getString("lastAddress")!=null)
      {
        sugested= prefs.getString("lastAddress");
      }

    bool _isOnline=isSelected[1];


    return Scaffold(
      body: _isInPayU?onlinePayment():dataRequest(_formKey,_isOnline),

    );
  }


  Widget onlinePayment()
  {
    return Column(
      children: <Widget>[
        Expanded(
          child:  WebviewScaffold(
            withJavascript: true,
            appCacheEnabled: true,
            url: new Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
          ),
        ),
        RaisedButton(
          child: Text("VOLVER AL INICIO"),
          onPressed: ()=>{
            Router.navigator.pushNamedAndRemoveUntil(
              Router.rootScreen,
                  (Route<dynamic> route) => false,
            )
          },
        )
      ],

    );
  }

  String _loadHTML() {
    return """
      <html>
        <body onload="document.f.submit();">
         <form id="f" name="f" method="post" action="https://checkout.payulatam.com/ppp-web-gateway-payu/">
          <input name="merchantId"    type="hidden"  value="851808"   >
          <input name="accountId"     type="hidden"  value="859344" >
          <input name="description"   type="hidden"  value="productos_fresquisima"  >
          <input name="referenceCode" type="hidden"  value="${_reference}" >
          <input name="amount"        type="hidden"  value="${getTotalPriceNum().toString()}"   >
          <input name="tax"           type="hidden"  value="0"  >
          <input name="algorithmSignature"  type="hidden"  value="SHA"  >
          <input name="taxReturnBase" type="hidden"  value="0" >
          <input name="currency"      type="hidden"  value="COP" >
          <input name="signature"     type="hidden"  value= "${signature(_reference, getTotalPriceNum().toString())}"  >
          <input name="confirmationUrl"    type="hidden"  value="http://fresquisima.co/views/payment/PaymentSuccess.php" >
          <input name="buyerEmail"    type="hidden"  value="$mail" >
          <input name="telephone"    type="hidden"  value="${widget.phoneController.text}" >
          <input name="shippingAddress"    type="hidden"  value="${widget.addressController.text}" >
          <input name="Submit"        type="submit"  value="Enviar" >
        </form>
        </body>
      </html>
    """;
  }

  Widget dataRequest(GlobalKey<FormState> _formKey,_isOnline){
    return Container(
      child: Column(
        children: <Widget>[
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

            child: Text("Datos de Pago"),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child:  Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            icon:Icon(Icons.account_circle),
                            hintText: "Nombre Completo",
                            labelText: "Nombre *"
                        ),
                        style: TextStyle(color: Colors.black),
                        controller: widget.nameController,
                        autovalidate: widget.submittedOnce,
                        validator: (String value){
                          return value.length>=5?
                          null:"Ingrese un nombre valido";
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            icon:Icon(Icons.phone),
                            hintText: "Telefono",
                            labelText: "Telefono *"
                        ),
                        style: TextStyle(color: Colors.black),
                        controller: widget.phoneController,
                        autovalidate: widget.submittedOnce,
                        validator: (String value){
                          return value.length>=8&& RegExp('[0-9 ]+').hasMatch(value)?
                          null:"Ingrese un telefono valido";
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            icon:Icon(Icons.business),
                            hintText: "Direccion",
                            labelText: "Direccion *",
                        ),

                        style: TextStyle(color: Colors.black),
                        controller: widget.addressController,
                        autovalidate: widget.submittedOnce,
                        validator: (String value){
                          return value.length>=5?
                          null:"Ingrese un nombre valido";
                        },
                      ),
                      SizedBox(height: 20,),
                      ToggleButtons(
                        children: <Widget>[
                          Text("  CONTRAENTREGA  "),
                          Text("  ONLINE  "),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelected[buttonIndex] = true;
                              } else {
                                isSelected[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: isSelected,
                      ),
                      SizedBox(height: 20,),
                      Text('''Zona de cobertura: 
Desde calle 26 hasta calle 170 entre Av. Circunvalar y Av. Boyacá
(cobertura especial: La Calera y Chía los días jueves)

Tiempos de entrega: 
Entregas en 2 días hábiles para pedidos realizados antes de la 3:00pm.
Cualquier pedido realizado después de esa hora será despachado en 3 días.'''),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            child: Text("Volver",style: TextStyle(color: white),),
                            color: Colors.red,
                            onPressed: () => {
                              Router.navigator.pop()
                            },
                          ),
                          RaisedButton(
                            child: Text("Ordenar",style: TextStyle(color: white),),

                            onPressed: () => {
                              if(_formKey.currentState.validate())
                                {
                                  order(widget.nameController.text,widget.phoneController.text,widget.addressController.text,_isOnline)
                                }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          )



        ],

      ),
    );
  }


  void order(String deliverName,String deliverPhone,String deliverAddress,bool isOnline) async
  {
    //informar orden a db
    var curdate=  DateTime.now();
    String reference = curdate.millisecondsSinceEpoch.toString();

    String url = "http://fresquisima.co/views/json_api/Api.php?apicall=createventa";
    final String body =
            "usuario="+mail+
            "&productos="+carritoText()+
            "&referencia="+reference+
            "&costo="+getTotalPriceNum().toString()+
            "&nombre="+deliverName+
            "&telefono="+deliverPhone+
            "&direccion="+deliverAddress+
            "&fecha="+curdate.toString();

    var response = await http.post(url, body: body,headers: {"Content-Type":"application/x-www-form-urlencoded"});

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');



    prefs.setString("lastAddres", deliverAddress);
    if(!isOnline){
      handleContraEntrega(reference);
      showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return AlertDialog(
              content: Text("Se creo su pedido con exito"),
              actions: <Widget>[
                FlatButton(
                    onPressed: ()=>{
                    Router.navigator.pushNamedAndRemoveUntil(
                    Router.rootScreen,
                    (Route<dynamic> route) => false,
                    )
            },
                    child: Text("OK"))
              ],
            );
          }

      );
    }
    else{
      setState(() {
        _isInPayU=true;
        _reference=reference;
        getOrders();
      });
    }
  }

}


