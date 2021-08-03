import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fresquisima/routes/AppRouter.gr.dart';
import 'package:fresquisima/values/data.dart';
import 'package:fresquisima/values/values.dart';
import 'package:fresquisima/widgets/listingProduct.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget{

  final String _selectedCategory="";

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  List<Product> _products=getCategoryProducts();

  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;


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

                child: Text(selectedCategory),
              ),
               Expanded(
                 child: GridView.count(
                   childAspectRatio: (itemWidth / itemHeight),
                   physics: ScrollPhysics(),
                   shrinkWrap: true,
                   // crossAxisCount is the number of columns
                   crossAxisCount: 2,
                   children: List.generate(_products.length, (index) {
                     return Center(
                       child: ListingProduct(product: _products[index],),
                     );
                   }),
                 )
               )
            ],
          ),
        )
    );
  }

}
