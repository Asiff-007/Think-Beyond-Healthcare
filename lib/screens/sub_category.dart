import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubCategoryPage extends StatefulWidget {
  final String catId, cTitle;

  SubCategoryPage({required this.catId, required this.cTitle});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  late String catId = widget.catId, cTitle = widget.cTitle;

  Future<Map<String, dynamic>> getSubCategory() async {
    final api = 'http://139.59.71.156:8000/user/get_subcategories';
    try {
      final response = await http.post(
        Uri.parse(api),
        body: {'cat_id': catId},
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyMGNkYjE5ZjAwNjkwZTMxOTcxYTZhNCIsImlhdCI6MTY1MTY2NDM2MiwiZXhwIjoxNjU0MjU2MzYyfQ.qWou414CZMj1DWm-eY3TxJa51wMXa9FIOk2ZjRfkO7w'
        },
      );
      final resp = json.decode(response.body);
      return resp['data'];
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(cTitle),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.favorite),
              tooltip: 'Show Snackbar',
              onPressed: () {
                log('Favorite button Pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'Show Snackbar',
              onPressed: () {
                log('Cart button Pressed');
              },
            ),
          ]),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: getSubCategory(),
          builder: (context, listSnap) {
            if (listSnap.hasError) {
              return Text('errror');
            } else if (listSnap.hasData) {
              var list = listSnap.data!;
              return ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    color: Colors.green,
                    child: Image.network(
                      list['image'],
                      height: 150,
                      width: double.maxFinite,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: Container(
                      height: 200,
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: list['sub_category'].length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 5.0),
                          itemBuilder: (context, index) {
                            var oneSubCategory = list['sub_category'][index];
                            String subTitle = oneSubCategory['title'],
                                image = oneSubCategory['image'];
                            return Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 120,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                        onTap: () {
                                          log('button pressed');
                                        },
                                        child: Image.network(image)),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    subTitle,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: list['products'].length,
                        itemBuilder: (context, index) {
                          var productList = list['products'][index];
                          String pTitle = productList['title'],
                              pImage = productList['image'],
                              pPrice = productList['price'].toString(),
                              pSprice = productList['spl_price'].toString(),
                              pDiscount = productList['discount'],
                              pUom = productList['uom'];
                          return Card(
                            child: Column(children: [
                              Container(
                                height: 20,
                                child: Row(children: [
                                  Text(pUom),
                                  Spacer(),
                                  Text(
                                    pDiscount + ' Discount',
                                    style: TextStyle(
                                        backgroundColor: Colors.red,
                                        color: Colors.white),
                                  )
                                ]),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 60,
                                child: Image.network(pImage),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(pTitle,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '₹ ' + pSprice,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      pPrice,
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 80,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 24, 240, 31),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    log('Add to cart pressed');
                                  },
                                  child: Text(
                                    'add to cart',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                            ]),
                          );
                        }),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
