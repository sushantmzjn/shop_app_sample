import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/view/common_widget/custom_button.dart';
import 'package:shop_app/view/common_widget/snackbar.dart';
import 'package:shop_app/view/home_page.dart';
import 'package:shop_app/view/update_product.dart';


import '../provider/auth_provider.dart';
import '../services/product_service.dart';

class ProductDetail extends ConsumerWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});


  @override
  Widget build(BuildContext context,ref) {

    ref.listen(productProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        ref.invalidate(productShow);
        Get.off(()=> HomePage());
        SnackShow.showSuccess(context, 'Success');
      }
    });


    final delete = ref.watch(productProvider);
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  width: 300.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    // color: Colors.deepPurple,
                      border: Border.all(color: Colors.deepPurple, width: 2.0),
                      borderRadius: BorderRadius.circular(18.0)
                  ),
                  child: product.image.isEmpty ? const Text('No Image') : Image.network(product.image)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Expanded(child: Text(product.product_name, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),)),
              Text('Rs. ${product.price.toString()}', style: TextStyle(fontSize: 16.sp, color: Colors.blue[500]),),
              ],),
            ),
            Text(product.product_detail, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),),

            //update
            CustomButton(onTap: (){
              Get.to(()=> UpdateProduct(productData: product,));
            }, text: 'Update'),


            //delete
            CustomButton(onTap: (){

              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 250.h,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            height: 4.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('Are you sure?',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          CustomButton(onTap: () {
                            Navigator.of(context).pop();
                                  ref.read(productProvider.notifier).deleteProduct(
                                      productId: product.id,
                                      publicId: product.public_id,
                                      token: auth.user[0].token);

                          }, text: 'Confirm'),
                          GestureDetector(
                              onTap: () {Navigator.of(context).pop();},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: Border.all(color: Colors.deepPurple, width: 2.0)
                                  ),
                                  child: Text('Cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontSize: 18.sp)),
                                ),
                              ))
                        ],
                      ),
                    );
                  });

              // ref.read(productProvider.notifier).deleteProduct(
              //     productId: product.public_id,
              //     publicId: product.public_id,
              //     token: auth.user[0].token
              // );
            }, text: 'Delete'),
          ],
        ),
      ),
    );
  }
}
