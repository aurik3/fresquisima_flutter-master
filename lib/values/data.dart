import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fresquisima/routes/router.gr.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'dart:convert';

class Product
{
  String name;
  String description;
  String image;
  num price;
  String category;


  Product({this.name, this.description, this.image, this.price, this.category});

  @override
  String toString() {
    return name;
  }

}

bool dataLoaded=false;

Map<Product,int> carrito= Map();

List<Product> products= List();

List<OrderData> orderHistory=List();

String selectedCategory="";
String name="name_placeholder";
String mail="mail_placeholder";
String profileurl="";

SharedPreferences prefs;

NumberFormat formater = new NumberFormat("\$##,###");

Future<List<Product>> getProducts() async
{

  var url = 'http://fresquisima.co/views/json_api/Api.php?apicall=readproductos';
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  Map<String, dynamic> data= jsonDecode(response.body);
  List<dynamic> requestProducts =data["contenido"];
  print(requestProducts[0].toString());
  requestProducts.forEach((element) {
    String categoria="";
    switch(element["categoria"])
    {
      case "18":
        categoria="VERDURAS";
        break;
      case "19":
        categoria="FRUTAS";
        break;
      case "20":
        categoria="PANADERIA";
        break;
    }
    Product temp=Product(
        name: element["titulo"],
        category: categoria,
        description: element["descripcion"],
        image: "http://fresquisima.co/backend/"+element["imagen"],
        price: int.parse(element["precio"]));
    if(temp!=null)
      {
        products.add(temp);
      }

  }
  );

  products.sort((a, b) => a.name.compareTo(b.name));

  dataLoaded=true;
 return products;
}



Future<List<OrderData>> getOrders() async
{

  var url = 'http://fresquisima.co/views/json_api/Api.php?apicall=readventas';
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  Map<String, dynamic> data= jsonDecode(response.body);
  List<dynamic> requestProducts =data["contenido"];
  print(requestProducts[0].toString());
  mail=prefs.getString("mail");
  requestProducts.forEach((element) {
    if(element["usuario"]==mail)
      {
        OrderData temp=OrderData(
          address: element["direccion"],
          products: element["productos"].toString().split("\n"),
          date: element["fecha"],
          code: element["id"],
          total: element["costo"],
        );
        orderHistory.add(temp);
      }
  }
  );
  dataLoaded=true;
  if(orderHistory.isNotEmpty)
    {
      prefs.setString("lastAddress",orderHistory[0].address.toLowerCase());
    }
  return orderHistory;
}


List<Product> getCategoryProducts()
{
  List<Product> ans=  products.where((element) => element.category==selectedCategory).toList();
  return ans;
}

Future<String> handleRegister(String pname,String pmail,String pw) async
{

  var url = 'http://fresquisima.co/views/json_api/Api.php?apicall=createusuario';
  String brequestBody = "mail=" + pmail + "&password=" + pw + "&usuario=" + pname + "&role=cliente";
  var response = await http.post(url, body: brequestBody,headers: {"Content-Type":"application/x-www-form-urlencoded"});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  Map<String, dynamic> data= jsonDecode(response.body);
  if(data["error"])
  {
    return "Error: "+data["message"];
  }
  else
  {
    name=pname;
    mail=pmail;
    prefs.setString("name", name);
    prefs.setString("mail", mail);
    return "success";
  }
}

updateCart(Product product,int units)
{
  carrito[product]=units;
  print(carrito.toString());
}


Future<String> handleSingIn(String pmail,String pw) async
{
  var url = 'http://fresquisima.co/views/json_api/Api.php?apicall=loginusuario';
  String body =  "mail="+pmail+"&"+ "password="+pw;
  var response = await http.post(url, body: body,headers: {"Content-Type":"application/x-www-form-urlencoded"});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  Map<String, dynamic> data= jsonDecode(response.body);

  if(data["error"])
    {
      return "Error: "+data["message"];
    }
  else
    {
      mail=data["contenido"]["mail"];
      name=data["contenido"]["usuario"];
      prefs.setString("name", name);
      prefs.setString("mail", mail);
      return "success";
    }
}


Future<String> handleContraEntrega(String reference ) async
{
  var url = 'http://fresquisima.co/views/payment/PaymentSuccess.php';
  String body =  "state_pol=666&"+ "reference_sale="+reference;
  var response = await http.post(url, body: body,headers: {"Content-Type":"application/x-www-form-urlencoded"});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');



}

String getTotalPrice()
{
  return formater.format(carrito.keys.fold(0, (sum, item) => sum + (item.price * carrito[item])));
}

num getTotalPriceNum()
{
  return carrito.keys.fold(0, (sum, item) => sum + (item.price * carrito[item]));
}
String signature(String pReference,String pAmmount){
String api_key="hTC9SdYly78hhnCvBF94lhOVNk";
String merchant_id="851808";
String reference=pReference;
String ammount=pAmmount;
String currency="COP";
String prehash= api_key+"~"+merchant_id+"~"+reference+"~"+ammount+"~"+currency;
print(prehash);

//719db35418429b8c614ff3dfb0c5b179bbea1b97
var bytes = utf8.encode(prehash);
Digest sha1Result = sha1.convert(bytes);
print(sha1Result.toString());
return sha1Result.toString();
}


class OrderData{
  List<String> products;
  String date;
  String total;
  String state;
  String address;
  String code;

  OrderData({this.products, this.date, this.total, this.state, this.address, this.code});
}
String carritoText() {
  String productos="";
  carrito.forEach((key, value) {

    productos+=value.toString()+" ${key.description} de ${key.name}\n";
  });
  print(productos);
  return productos;
}