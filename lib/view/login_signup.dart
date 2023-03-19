import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/view/common_widget/snackbar.dart';
import 'package:shop_app/view/common_widget/text_field.dart';
import 'package:shop_app/view/home_page.dart';

import '../provider/common_provider.dart';
import 'common_widget/button.dart';

class LoginSignup extends ConsumerStatefulWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _from = GlobalKey<FormState>();

  @override
  ConsumerState<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends ConsumerState<LoginSignup> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
        if(next.isError){
          SnackShow.showFailure(context, next.errMessage);
        }else if(next.isSuccess){
          SnackShow.showSuccess(context, 'success');
        }
    });

    final isLogin =  ref.watch(loginSignupProvider);
    final mode = ref.watch(autoValidateMode);
    final auth =  ref.watch(authProvider);


    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Form(
            key:widget._from,
            autovalidateMode: mode,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text( isLogin ? 'Login' : 'Sign Up', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),),
                ),

                Image.asset('assets/images/logo.png',width: 150.w, height: 150.h, ),

                //email
                MyTextField(
                  controller: widget.emailController,
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
                  hintText: 'Email',
                  obscureText: false,
                    keyboardType: TextInputType.text
                ),
               //full name
               if(!isLogin) MyTextField(
                 controller: widget.fullNameController,
                 validator: (val){
                   if (val!.isEmpty) {
                     return 'required';
                   }
                   return null;
                 },
                 hintText: 'Full Name',
                 obscureText: false,keyboardType: TextInputType.text),
                //password
                MyTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'required';
                    } else if (val.length <=5) {
                      return 'password must be at least 6 character ';
                    }
                    return null;
                  },
                  controller: widget.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                    keyboardType: TextInputType.text
                ),

                //buttons
                MyButton(
                  isLoading: auth.isLoad ? true : null,
                  onPressed: auth.isLoad ? null : () {
                   widget._from.currentState!.save();
                   FocusScope.of(context).unfocus();
                    if(widget._from.currentState!.validate()){
                        if(isLogin){
                          //login provider
                          ref.read(authProvider.notifier).userLogin(
                              email: widget.emailController.text.trim(),
                              password: widget.passwordController.text.trim()
                          );
                        }else{
                          //signup provider
                          ref.read(authProvider.notifier).userSignUp(
                              email: widget.emailController.text.trim(),
                              password: widget.passwordController.text.trim(),
                              full_name: widget.fullNameController.text.trim()
                          );
                        }
                    }else{
                      ref.read(autoValidateMode.notifier).toggle();
                    }
                  },
                  text: isLogin ? 'Login' : 'Sign Up',
                  btnColor: Colors.green,
                ),
                SizedBox(
                  height: 20.h,
                    child: const Text('Or')),
                MyButton(
                  onPressed: () {
                    widget._from.currentState!.reset();
                    widget.emailController.clear();
                    widget.fullNameController.clear();
                    widget.passwordController.clear();
                    ref.read(loginSignupProvider.notifier).toggle();
                    ref.watch(autoValidateMode.notifier).autoValidateDisable();
                  },
                  text: isLogin ? 'Go to Sign Up' : 'Go to Login',
                  btnColor: Colors.green,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
