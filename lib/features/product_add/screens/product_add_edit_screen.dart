// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_seller_app/features/auth/controller/auth_controller.dart';
import 'package:ecommerce_seller_app/features/product_add/controller/product_add_controller.dart';
import 'package:uuid/uuid.dart';

import '../../../core/common/custom_button.dart';
import '../../../core/common/widgets/custom_textfield.dart';
import '../../../core/palette.dart';
import '../../../core/utils.dart';
import '../../../home/screens/home_screen.dart';
import '../../../models/product.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import '../../../models/seller_user_model.dart';
import '../../../models/category_model.dart';

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

  List<CategoryModel> selectedCategory = [];
  List<File> _images = [];
  List<String> _imageUrls = [];
  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productNameController.dispose();
    _productPriceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
  }

  final _categoryList = [
    CategoryModel(
        categoryName: 'Fruits', isCategoryMarked: false, categoryId: 01),
    CategoryModel(
        categoryName: 'Vegetable', isCategoryMarked: false, categoryId: 01),
    CategoryModel(
        categoryName: 'Drinks', isCategoryMarked: false, categoryId: 01),
    CategoryModel(
        categoryName: 'Meat', isCategoryMarked: false, categoryId: 01),
  ];

  @override
  void initState() {
    print('beforeProductCategoryListLength ${_categoryList.length}');

    _addScreenOrNot();
    // TODO: implement initState
    super.initState();
  }

  void _addScreenOrNot() {
    if (widget.product != null) {
      _productNameController.text = widget.product!.name;
      _productPriceController.text = widget.product!.price.toString();
      _quantityController.text = widget.product!.quantity.toString();
      _descriptionController.text = widget.product!.description;
      _imageUrls = widget.product!.images;
    }
  }

  void _selectImage(BuildContext ctx) async {
    final selectedImages = await pickImages(ctx);

    setState(() {
      _images = selectedImages;
    });
  }

  void _selectedCategoryCollector(
      CategoryModel selectedCategoryModel, bool isAdd) {
    if (isAdd) {
      selectedCategory.add(selectedCategoryModel);
      print(selectedCategoryModel.categoryId);
    } else {
      var index = selectedCategory.indexWhere(
          (element) => element.categoryId == selectedCategoryModel.categoryId);
      selectedCategory.removeAt(index);
    }
  }

  void _storeProductData(BuildContext ctx) {
    if (_images.isEmpty && _imageUrls.isEmpty) {
      showSnackBar(context: ctx, text: 'Please add product image');
      return;
    }

    if (selectedCategory.isEmpty) {
      return showSnackBar(
          context: ctx, text: 'Please select 1 or more category');
    }

    ref.read(productAddControllerProvider.notifier).saveProductDataInFirebase(
          productImageUrls: _imageUrls,
          productImages: _images,
          productName: _productNameController.text,
          productDescription: _descriptionController.text,
          category: selectedCategory,
          productPrice: double.parse(_productPriceController.text),
          quantity: int.parse(_quantityController.text),
          context: ctx,
          productID: widget.product != null ? widget.product!.id : "",
        );
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              backgroundColor: Colors.green,
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
                CustomTextField(
                    controller: _productPriceController, hintText: 'Price'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: _quantityController, hintText: 'Quantity'),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  width: 300,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 80,
                              childAspectRatio: 15 / 6.5,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 10),
                      itemCount: _categoryList.length,
                      itemBuilder: (context, categoryIndex) {
                        return InkWell(
                          onTap: () {
                            final category = _categoryList[categoryIndex];
                            if (category.isCategoryMarked) {
                              _categoryList[categoryIndex] = CategoryModel(
                                  categoryName: category.categoryName,
                                  isCategoryMarked: false,
                                  categoryId: category.categoryId);
                              setState(() {
                                _categoryList;
                              });
                              _selectedCategoryCollector(
                                  _categoryList[categoryIndex], false);
                            } else {
                              _categoryList[categoryIndex] = CategoryModel(
                                  categoryName: category.categoryName,
                                  isCategoryMarked: true,
                                  categoryId: category.categoryId);
                              setState(() {
                                _categoryList;
                              });
                              _selectedCategoryCollector(
                                  _categoryList[categoryIndex], true);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                                color: _categoryList[categoryIndex]
                                        .isCategoryMarked
                                    ? const Color.fromARGB(255, 92, 230, 97)
                                    : const Color.fromARGB(255, 192, 192, 192),
                                borderRadius: BorderRadius.circular(30)),
                            child:
                                Text(_categoryList[categoryIndex].categoryName),
                          ),
                        );
                      }),
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
}
