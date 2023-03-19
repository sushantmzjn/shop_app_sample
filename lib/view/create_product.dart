import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/common_provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/services/product_service.dart';
import 'package:shop_app/view/common_widget/custom_button.dart';
import 'package:shop_app/view/common_widget/snackbar.dart';
import 'package:shop_app/view/common_widget/text_field.dart';
import 'package:shop_app/view/home_page.dart';

class CreateProduct extends ConsumerStatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends ConsumerState<CreateProduct> {
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ref.listen(productProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        ref.invalidate(productShow);
        Get.off(()=> HomePage());
        SnackShow.showSuccess(context, 'Successful');
      }
    });

    final image = ref.watch(imageProvider);
    final product = ref.watch(productProvider);
    final mode = ref.watch(autoValidateMode);
    final auth = ref.watch(authProvider);
    return Scaffold(
        body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        } ,
                        child: Container(
                          height: 30.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(3,0)
                                )
                              ]
                          ),
                          child: Icon(Icons.chevron_left, size: 35,color: Colors.white,),
                        ),
                      ),
                      Spacer(),
                      Text('Create Product', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.sp),),
                      Spacer()
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _form,
                      autovalidateMode: mode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                              onTap: (){
                                Get.defaultDialog(
                                    title: 'Select',
                                  content:Text('Choose from'),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.of(context).pop();
                                      ref.read(imageProvider.notifier).imagePick(true);
                                    }, child: const Text('Camera')),
                                    TextButton(onPressed: (){
                                      Navigator.of(context).pop();
                                      ref.read(imageProvider.notifier).imagePick(false);
                                    }, child: const Text('Gallery')),
                                  ]
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 300.w,
                                height: 200.h,
                                decoration: BoxDecoration(
                                  // color: Colors.deepPurple,
                                  border: Border.all(color: Colors.deepPurple, width: 2.0),
                                  borderRadius: BorderRadius.circular(18.0)
                                ),
                                child: image == null ? const Text('Select an Image') : Image.file(File(image.path)),
                              ),
                            ),
                          ),
                          MyTextField(
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'required';
                                }
                              },
                              controller: productController, hintText: 'product name', obscureText: false, keyboardType: TextInputType.text),
                          MyTextField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'required';
                                } else if (val.length > 9) {
                                  return 'price must be less  than 10 character ';
                                }
                                return null;
                              },
                              controller: priceController, hintText: 'product price', obscureText: false, keyboardType: TextInputType.number),
                          MyTextField(
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'required';
                                }
                                return null;
                              },
                              controller: detailController, hintText: 'product detail', obscureText: false, keyboardType: TextInputType.text),
                          CustomButton(
                            isLoading: product.isLoad ? true : null,
                            onTap: product.isLoad ? null : () {
                            _form.currentState!.save();
                            FocusScope.of(context).unfocus();
                            if(_form.currentState!.validate()){
                              if(image == null){
                                SnackShow.showFailure(context, 'image required');
                              }else{
                                ref.read(productProvider.notifier).productCreate(
                                    product_name: productController.text.trim(),
                                    product_detail: detailController.text.trim(),
                                    price:int.parse( priceController.text.trim()),
                                    image: image,
                                    token: auth.user[0].token
                                );
                              }

                            }else{
                              ref.read(autoValidateMode.notifier).toggle();
                            }
                          }, text: 'Create',)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
