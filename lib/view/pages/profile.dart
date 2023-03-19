import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app/provider/auth_provider.dart';
import '../common_widget/custom_button.dart';
import '../create_product.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black, fontSize: 24.sp),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit,
                  color: Colors.deepPurple,
                ))
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              height: 100.h,
              width: 100.h,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2.0),
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(18.0)),
            ),
            Text(auth.user[0].username),
            Text(auth.user[0].email),
            Spacer(),
            CustomButton(
              onTap: () {Get.to(() => CreateProduct(), transition: Transition.leftToRightWithFade);
              },
              text: 'Create Product',
            ),
            CustomButton(
              onTap: () {
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
                                  SizedBox(height: 8.h),
                                  Text(
                                      'Are you sure you want to Logout? ',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey)),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            CustomButton(onTap: () {
                              Navigator.of(context).pop();
                              ref.read(authProvider.notifier).userLogOut();
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
              },
              text: 'Log out',
            ),
          ],
        )));
  }
}
