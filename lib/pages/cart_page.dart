import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_vendor_app/data/cloud_database.dart';
import 'package:local_vendor_app/data/shared_prefs.dart';
import 'package:local_vendor_app/globals.dart';
import 'package:local_vendor_app/models/cart_item.dart';
import 'package:local_vendor_app/models/shop_user.dart';
import 'package:local_vendor_app/widgets/action_button.dart';
import 'package:local_vendor_app/widgets/cart_item_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double total = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Your cart",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            cloudDatabase.userCollection.doc(appData.value.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List<CartItem> data = ShopUser.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>)
                  .cart;
              total = 0;

              if (data.isEmpty) {
                return const Center(
                  child: Text("Your cart is empty."),
                );
              }

              for (var e in data) {
                total = total + ((e.amount) * (e.item.price));
              }
              return Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 0.15 * getHeight(context),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return CartItemWidget(
                            item: data[index],
                            updateAmount: (e) {
                              // data[index].amount = e;
                              // setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  _getBottomBar(),
                ],
              );
            }
          }
          return Center(
            child: Image.asset(
              "assets/images/loading.gif",
              height: 100,
              width: 100,
            ),
          );
        },
      ),
    );
  }

  Positioned _getBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5.0,
              spreadRadius: 3.0,
              offset: const Offset(0.0, -5.0),
            )
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  const Text("Total:"),
                  const Spacer(),
                  Text(
                    "₹ $total",
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              // height: kToolbarHeight,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ActionButton(
                  onPressed: () {},
                  text: "Place Order",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
