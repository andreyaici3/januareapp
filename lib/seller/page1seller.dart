import 'package:flutter/material.dart';
import 'package:januareapp1/const.dart';
import 'package:januareapp1/model/productmodel.dart';
import 'package:januareapp1/seller/newproduct.dart';

class Page1Seller extends StatefulWidget {
  final List product;

  Page1Seller({Key? key, required this.product}) : super(key: key);

  @override
  _Page1SellerState createState() => _Page1SellerState();
}

class _Page1SellerState extends State<Page1Seller> {
  late double width, height;

  @override
  Widget build(BuildContext context) {
    print(widget.product.length);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildTextProduct(),
            Expanded(
              child: Stack(
                children: [
                  _buildProduct(),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          backgroundColor: Colors.green,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => NewProduct()));
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextProduct() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: const Text(
        "Product",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProduct() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: height,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 25,
        scrollDirection: Axis.vertical,
        children: List.generate(widget.product.length, (index) {
          String name = widget.product[index]['name'];
          String price = widget.product[index]['price'];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImage(base + "images/" + widget.product[index]['image']),
                  buildInfo(name, price)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildInfo(String name, String price) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(price),
        ],
      ),
    );
  }

  Widget buildImage(String url) {
    return Stack(
      children: [
        Image.network(
          url,
          height: 100,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search Produk",
            suffixIcon: GestureDetector(
              child: Icon(Icons.search),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
              borderRadius: BorderRadius.circular(15.0),
            )),
      ),
    );
  }
}
