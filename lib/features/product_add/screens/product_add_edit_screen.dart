// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:ecommerce_seller_app/features/product_add/controller/product_add_controller.dart';

import 'package:flutter/scheduler.dart';

import '../../../core/common/controller/common_get_category_controller.dart';
import '../../../core/common/controller/common_get_shipping_category_controller.dart';
import '../../../core/common/custom_button.dart';
import '../../../core/common/widgets/custom_textfield.dart';

import '../../../core/palette.dart';
import '../../../core/utils.dart';

import '../../../models/product.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/category_model.dart';
import '../../../models/shipping_category_model.dart';
import '../widget/delete_confimation.dart';
import '../widget/showDialog.dart';

class ProductAddEditScreen extends ConsumerStatefulWidget {
  static const routeName = '/addEdit-screen';
  final ProductModel? product;
  const ProductAddEditScreen({
    this.product,
    super.key,
  });

  @override
  ConsumerState<ProductAddEditScreen> createState() =>
      _ProductAddEditScreenConsumerState();
}

class _ProductAddEditScreenConsumerState
    extends ConsumerState<ProductAddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _kgController = TextEditingController();
  final _discountController = TextEditingController();

  List<File> _images = [];
  List<String> _imageUrls = [];
  final _addProductFormKey = GlobalKey<FormState>();

  //for the select category part
  List<CategoryModel> _selectedCategory = [];
  List<CategoryModel> _categoryList = [];

  //for the shipping select part
  List<ShippingCategoryModel> _shippingCategoryList = [
    ShippingCategoryModel(
        name: "Select an shipping method", id: "id", price: 0.0)
  ];
  ShippingCategoryModel _selectedShippingCategory = ShippingCategoryModel(
      name: "Select an shipping method", id: "id", price: 0.0);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productNameController.dispose();
    _productPriceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _kgController.dispose();
    _discountController.dispose();
  }

  void refreshCategoryList() async {
    final isOver = await ref
        .read(productAddControllerProvider.notifier)
        .getCategoryData(context);

    if (isOver) {
      _categoryList = await ref.read(categoryProvider)!;

      setState(() {
        _categoryList;
      });
    }
  }

  void getShippingCategoryList() async {
    final res = await ref
        .read(commonGetShippingCategoryControllerProvider.notifier)
        .getShippingCategoryData(context);

    if (res != null) {
      _shippingCategoryList.addAll(res);

      if (widget.product != null) {
        _selectedShippingCategory = widget.product!.shippingCategory;
      }

      setState(() {
        _shippingCategoryList;
      });
    }
  }

  @override
  void initState() {
    _addScreenOrNot();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      refreshCategoryList();
      getShippingCategoryList();
    });
    // TODO: implement initState
    super.initState();
  }

  void _addScreenOrNot() {
    // If the edit screen
    if (widget.product != null) {
      _productNameController.text = widget.product!.name;
      _productPriceController.text = widget.product!.price.toString();
      _quantityController.text = widget.product!.quantity.toString();
      _descriptionController.text = widget.product!.description;
      _imageUrls = widget.product!.images;
      _kgController.text =
          widget.product!.kg != null ? widget.product!.kg.toString() : "";
      _selectedCategory = widget.product!.category;
    }
  }

  void _selectImage(BuildContext ctx) async {
    final selectedImages = await pickImages(ctx);

    setState(() {
      _images = selectedImages;
    });
  }

  void _storeProductData(BuildContext ctx) {
    if (_images.isEmpty && _imageUrls.isEmpty) {
      showSnackBar(context: ctx, text: 'Please add product image');
      return;
    }

    if (_selectedCategory.isEmpty) {
      return showSnackBar(
          context: ctx, text: 'Please select 1 or more category');
    }

    if (_selectedShippingCategory.id == "id") {
      return showSnackBar(
          context: ctx, text: 'Please select your shipping method');
    }

    //save data in firebase
    ref.read(productAddControllerProvider.notifier).saveProductDataInFirebase(
          shippingCategory: _selectedShippingCategory,
          productImageUrls: _imageUrls,
          productImages: _images,
          productName: _productNameController.text,
          productDescription: _descriptionController.text,
          category: _selectedCategory,
          productPrice: double.parse(_productPriceController.text),
          quantity: int.parse(_quantityController.text),
          context: ctx,
          productID: widget.product != null ? widget.product!.id : "",
          kg: _kgController.text.isNotEmpty
              ? double.parse(_kgController.text)
              : null,
          discount: _discountController.text.isNotEmpty
              ? int.parse(_discountController.text)
              : null,
        );
  }

  void _deleteProduct(
      {required BuildContext ctx, required String productID}) async {
    ref
        .read(productAddControllerProvider.notifier)
        .deleteAProduct(context: context, productID: productID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          widget.product != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    backgroundColor: redColor,
                    text: 'Delete',
                    onPressed: () => deleteConfirmationDialog(
                      context: context,
                      onConfirm: () => _deleteProduct(
                          ctx: context, productID: widget.product!.id),
                    ),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              backgroundColor: greenColor,
              text: 'Sell',
              onPressed: () => _storeProductData(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                _images.isNotEmpty
                    ? GestureDetector(
                        onTap: () => _selectImage(context),
                        child: CarouselSlider(
                          items: _images.map((i) {
                            return Builder(builder: (context) {
                              return Image.file(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              );
                            });
                          }).toList(),
                          options:
                              CarouselOptions(viewportFraction: 1, height: 200),
                        ),
                      )
                    : _imageUrls.isNotEmpty
                        ? GestureDetector(
                            onTap: () => _selectImage(context),
                            child: CarouselSlider(
                              items: _imageUrls.map((i) {
                                return Builder(builder: (context) {
                                  return Image.network(
                                    i,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  );
                                });
                              }).toList(),
                              options: CarouselOptions(
                                  viewportFraction: 1, height: 200),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => _selectImage(context),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Select Product AImages',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: _productNameController,
                    hintText: 'Product Name'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _kgController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    hintText: "Kg  \"You can have this field EMPTY\"",
                  ),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _productPriceController,
                  hintText: 'Price',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _quantityController,
                  hintText: 'Quantity',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _discountController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    hintText:
                        "Discount Price \"You can have this field EMPTY\"",
                  ),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: _selectedShippingCategory.name,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items:
                        _shippingCategoryList.map((ShippingCategoryModel item) {
                      return DropdownMenuItem(
                        value: item.name,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.name),
                            const SizedBox(
                              width: 5,
                            ),
                            item.id != "id"
                                ? Text("\$${item.price}")
                                : const SizedBox(),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? shippingProductname) {
                      setState(() {
                        _selectedShippingCategory =
                            _shippingCategoryList.firstWhere((element) =>
                                element.name == shippingProductname);
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _selectedCategory.isEmpty
                    ? const Center(child: Text('No Category selected'))
                    : GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 82,
                                childAspectRatio: 15 / 6.5,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 10),
                        itemCount: _selectedCategory.length,
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                _selectedCategory[index].name,
                                style: const TextStyle(color: whiteColor),
                                maxLines: 1,
                              ),
                            ),
                          );
                        }),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: openFilterDialog,
                      child: const Text("Category")),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openFilterDialog() async {
    showMaterialDialog(
      context: context,
      selectedCategory: _selectedCategory,
      categoryList: _categoryList,
      choiceChipLabel: (category) => category!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (category, query) {
        return category.name.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          _selectedCategory = List.from(list!);
        });
        Navigator.pop(context);
      },
    );

    // await FilterListDialog.display<CategoryModel>(
    //   context,
    //   listData: _categoryList,
    //   selectedListData: _selectedCategory,
    //   choiceChipLabel: (category) => category!.name,
    //   validateSelectedItem: (list, val) => list!.contains(val),
    //   onItemSearch: (category, query) {
    //     return category.name.toLowerCase().contains(query.toLowerCase());
    //   },
    //   onApplyButtonClick: (list) {
    //     setState(() {
    //       _selectedCategory = List.from(list!);
    //     });
    //     Navigator.pop(context);
    //   },
    //   themeData: FilterListThemeData.light(context),
    //   backgroundColor: Colors.black,

    // );
  }
}
