import 'package:makeup_webapp/ApiCalls/api_calls.dart';
import 'package:makeup_webapp/Model/Product/product_model/product_model.dart';
import 'package:makeup_webapp/Model/User/UserModel/register_user_model/register_user_model.dart';
import 'package:makeup_webapp/Model/User/UserModelResponse/user_model_response/user_model_response.dart';
import 'package:makeup_webapp/Screens/screen_login.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  double _screenSize = 0;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //call product list api
      await ProductDB.instance.getAllProducts();
    });
    setState(
      () => _screenSize = screenWidth(context: context),
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('All products'),
            IconButton(
                onPressed: () {
                  signout(context);
                },
                icon: const Icon(Icons.exit_to_app)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              margin: const EdgeInsets.all(8),
              width: screenWidth(context: context),
              child: ValueListenableBuilder(
                valueListenable: ProductDB.instance.productListNotifier,
                builder: (context, List<ProductModel> productList, _) {
                  if (productList.isEmpty) {
                    return const Center(
                      child: Text("No products fetched!"),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (_screenSize >= 600) ? 4 : 1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: productList.length,
                      itemBuilder: (_, index) {
                        final product =
                            ProductDB.instance.productListNotifier.value[index];
                        if (product.name != null &&
                            product.price != null &&
                            product.imageLink != null) {
                          return ProductItem(
                              index: index,
                              name: product.name!,
                              price: product.price!,
                              imageUrl: product.imageLink!);
                        } else {
                          return const SizedBox();
                        }
                      },
                      controller: _scrollController,
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  double screenWidth({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }

  signout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx1) => ScreenLogin()), (route) => false);
  }
}

class ProductItem extends StatelessWidget {
  final int index;
  final String name;
  final String price;
  final String imageUrl;

  const ProductItem({
    Key? key,
    required this.index,
    required this.name,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          FadeInImage(
            placeholder:
                const AssetImage("assets/images/No-Image-Placeholder.png"),
            image: NetworkImage(imageUrl),
          ),
          //const Image(
          //image: AssetImage("assets/images/No-Image-Placeholder.png")),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  child: Text(name),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  child: Text(price),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
