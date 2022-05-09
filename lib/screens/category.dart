import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test_demo/screens/args/sub_category_args.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _ListDemoState();
}

class _ListDemoState extends State<CategoryPage> {
  Future<Map<String, dynamic>> getCategories() async {
    final api = 'http://139.59.71.156:8000/user/get_categories';
    try {
      final response = await http.post(
        Uri.parse(api),
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
          title: Text("Think Beyond Healthcare"),
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
          future: getCategories(),
          builder: (context, listSnap) {
            if (listSnap.hasError) {
              return Text('errror');
            } else if (listSnap.hasData) {
              var list = listSnap.data!;
              return ListView(
                shrinkWrap: true,
                children: [
                  Image.network(
                    list['image'],
                    height: 150,
                    width: double.maxFinite,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: Container(
                      height: 450,
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: list['category'].length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 15.0,
                                  mainAxisSpacing: 30.0),
                          itemBuilder: (context, index) {
                            var oneCategory = list['category'][index];
                            String cTitle = oneCategory['title'],
                                catId = oneCategory['_id'],
                                image = oneCategory['image'];
                            return Wrap(
                              direction: Axis.horizontal,
                              spacing: 8.0, // gap between adjacent chips
                              runSpacing: 4.0,
                              children: [
                                Container(
                                  height: 70,
                                  width: 100,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/subcategory',
                                              arguments: SubCategoryArguments(
                                                  catId, cTitle));
                                        },
                                        child: Image.network(image)),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    cTitle,
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
