import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  void Function()? onTap;
  String text;
  final bool? isLoading;

  CustomButton({ required this.onTap, required this.text, this.isLoading});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 40.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.deepPurple,
              boxShadow: [
                BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(3,0)
                )
              ]
          ),
          child: isLoading == null ? Text(text,
            textAlign: TextAlign.center ,style: TextStyle(color: Colors.white, fontSize: 18.sp),) :
          const Center(child: CircularProgressIndicator(color: Colors.white,),),
        ),
      ),
    );
  }
}
