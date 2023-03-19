import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/common_provider.dart';
import 'package:shop_app/view/common_widget/text_field.dart';
import 'package:shop_app/view/register_page.dart';

import 'common_widget/custom_button.dart';
import 'common_widget/snackbar.dart';

class LoginPage extends ConsumerStatefulWidget {



  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _from = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    ref.listen(authProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        SnackShow.showSuccess(context, 'Successful');
      }
    });

    final auth = ref.watch(authProvider);
    final mode = ref.watch(autoValidateMode);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _from,
          autovalidateMode: mode,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Sign In', style: TextStyle(fontSize: 24.sp,),),
              ),
              Image.asset('assets/images/shopping_cart.png', width: 100.w, height: 100.h,color: Colors.deepPurple,),
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
              CustomButton(
                isLoading: auth.isLoad ? true : null,
                onTap: auth.isLoad ? null : () {
                _from.currentState!.save();
                FocusScope.of(context).unfocus();
                if(_from.currentState!.validate()){
                  ref.read(authProvider.notifier).userLogin(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim()
                  );

                }else{
                  ref.read(autoValidateMode.notifier).toggle();
                }
              }, text: 'Sign In',),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                  Text('Don\'t have an account ? '),
                  GestureDetector(
                      onTap: (){
                        Get.to(()=> RegisterPage(), transition: Transition.leftToRight);
                        emailController.clear();
                        passwordController.clear();
                      },
                      child: Text('Register', style: TextStyle(color: Colors.deepPurple),)),

                  ]
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
