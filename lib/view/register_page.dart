import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../provider/auth_provider.dart';
import '../provider/common_provider.dart';
import 'common_widget/custom_button.dart';
import 'common_widget/snackbar.dart';
import 'common_widget/text_field.dart';
import 'login_page.dart';

class RegisterPage extends ConsumerStatefulWidget {

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _from = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        Get.off(()=> LoginPage());
        SnackShow.showSuccess(context, 'Successful');
      }
    });

    final auth = ref.watch(authProvider);
    final mode = ref.watch(autoValidateMode);
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
                  Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.sp),),
                  Spacer()
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _from,
                  autovalidateMode: mode,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset('assets/images/shopping_cart.png', width: 100.w, height: 100.h,color: Colors.deepPurple,),
                      ),
                      MyTextField(
                          validator: (val){
                            if (val!.isEmpty) {
                              return 'required';
                            }
                            return null;
                          },
                          controller: fullNameController, hintText: 'Full Name', obscureText: false, keyboardType: TextInputType.text),
                      MyTextField(
                          validator: (val){
                            if (val!.isEmpty) {
                              return 'required';
                            } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)) {
                              return 'Please provide a valid email';
                            }
                            return null;
                          },
                          controller: emailController, hintText: 'Email', obscureText: false, keyboardType: TextInputType.emailAddress),
                      MyTextField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'required';
                            } else if (val.length <=5) {
                              return 'password must be at least 6 character ';
                            }
                            return null;
                          },
                          controller: passwordController, hintText: 'Password', obscureText: true, keyboardType: TextInputType.text),
                      CustomButton(onTap: auth.isLoad ? null : () {
                        _from.currentState!.save();
                        FocusScope.of(context).unfocus();
                        if(_from.currentState!.validate()){

                          ref.read(authProvider.notifier).userSignUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              full_name: fullNameController.text.trim()
                          );
                        }else{
                          ref.read(autoValidateMode.notifier).toggle();
                        }
                      }, text: 'Sign Up',),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children:[
                              const Text('Already have an account ? '),
                              GestureDetector(
                                  onTap: (){
                                    Get.to(()=> RegisterPage(), transition: Transition.leftToRight);
                                  },
                                  child:  GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sign In', style: TextStyle(color: Colors.deepPurple),))),

                            ]
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
