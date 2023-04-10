import 'package:ecommerce_seller_app/features/product_add/controller/product_add_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/common/controller/common_get_date_and_time_controller.dart';
import '../../product_add/screens/product_add_edit_screen.dart';
import '../../../models/product.dart';
import '../controller/home_controller.dart';
import '../widgets/appbar_menu.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = "/home-screen";
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenConsumerState();
}

class _HomeScreenConsumerState extends ConsumerState<HomeScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        navigaToExit();
        return false;
      }),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const FittedBox(child: Text('Home Screen')),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 1, left: 7),
              child: AppBarMenu(
                ref: ref,
              ),
            )
          ],
        ),
        body: StreamBuilder(
            stream: ref.watch(homeControllerProvider.notifier).getProductData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator.adaptive(),
                      SizedBox(
                        height: 20,
                      ),
                      Text('We are Loading..'),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong! ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final products = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: productUi(products),
                );
              } else {
                return Center(
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: IconButton(
                        onPressed: () {
                          ProductModel? product;
                          navigaToProductAddEditScreen(product);
                        },
                        icon: const Icon(
                          Icons.add_circle_rounded,
                          size: 100,
                          color: Color.fromARGB(255, 226, 226, 226),
                        )),
                  ),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ProductModel? product;
            navigaToProductAddEditScreen(product);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget productUi(List<ProductModel> products) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 190,
            childAspectRatio: 3 / 6,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              navigaToProductAddEditScreen(product);
            },
            child: Card(
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: NetworkImage(product.images[0])),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 243, 243, 243),
                  ),
                  height: 100,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${product.name}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Price: ${product.price}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Description: ${product.description}',
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Quantity: ${product.quantity}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Category: ${product.category.map((e) => e.name)}, ',
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Rating: ${product.rating}',
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'kg: ${product.kg}',
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'discount: ${product.discount}',
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          );
        });
  }

  void navigaToExit() {
    Navigator.pop(context);
  }

  void navigaToProductAddEditScreen(ProductModel? product) async {
    Navigator.pushNamed(context, ProductAddEditScreen.routeName,
        arguments: product);

    //dev codes
    // ref.read(homeControllerProvider.notifier).getAndSaveProductData(context);
  }
}
