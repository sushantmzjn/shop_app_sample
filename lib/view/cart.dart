import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shop_app/provider/cart_provider.dart';

class CartPage extends ConsumerWidget  {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,ref) {
    final cartData = ref.watch(cartProvider);
    final cartTotal = ref.read(cartProvider.notifier).total;
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                  itemCount: cartData.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [

                            SlidableAction(
                              onPressed: (context){
                                ref.read(cartProvider.notifier).remove(cartData[index]);
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                            )
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(3,0)
                                )
                              ]
                          ),
                          child: Stack(
                              children:[
                                Row(
                                  children: [
                                    Container(
                                      height: 100.h,
                                      width: 150.h,
                                      decoration:BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(6.0)
                                      ),
                                      child: Image.network(cartData[index].image, fit: BoxFit.fill,),
                                    ),
                                    Spacer(),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(cartData[index].product_name),
                                        Text(cartData[index].price.toString()),
                                      ],
                                    ),
                                    Spacer()
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 260.0,top: 100.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(6.0)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                          child: Icon(Icons.minimize, size: 25),
                                      onTap: (){
                                            ref.read(cartProvider.notifier).singleRemove(cartData[index]);
                                      },
                                      ),
                                      SizedBox(width: 18.w),
                                      Text(cartData[index].quantity.toString(),style: TextStyle(fontSize: 16.sp),),
                                      SizedBox(width: 18.w),
                                      InkWell(
                                        child: Icon(Icons.add, size: 25),
                                        onTap: (){
                                          ref.read(cartProvider.notifier).singleAdd(cartData[index]);
                                        },
                                      ),
                                    ],
                                  ),
                                )

                              ]
                          ),
                        ),
                      ),
                    );
                }),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),),
                    Text('Rs. $cartTotal', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            
            ],
          )
      ),
    );
  }
}
