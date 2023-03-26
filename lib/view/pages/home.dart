import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shop_app/view/product_details.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../services/product_service.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context, ref) {

    // Future refresh()async{
    //   ref.invalidate(productShow);
    // }

    final productData = ref.watch(productShow);
    return SafeArea(
      child: productData.when(
          data: (data){
            return data.isEmpty ? const Center(child: Text('No Data'),) : LiquidPullToRefresh(
              color: Colors.deepPurple,
              height: 100.h,
              animSpeedFactor: 2.0,
              onRefresh: ()async{
                ref.invalidate(productShow);
              },
              child: MasonryGridView.builder(
                key: const PageStorageKey<String>('page'),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: GestureDetector(
                          onTap: (){
                            Get.to(()=>ProductDetail(product: data[index]),transition: Transition.leftToRightWithFade);
                          },
                          child: Container(
                            color: Colors.grey,
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  errorWidget: (context, url, error) => const Center(child: Text('no image')),
                                  imageUrl: data[index].image,
                                  placeholder: (context,url)=> const Center(child: Text('Loading...'),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(child: Text(data[index].product_name,
                                        style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16.sp, fontWeight: FontWeight.w600),)),
                                      Text('Rs. ${data[index].price.toString()}'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );

          },
          error: (error, stack)=> Center(child: Text('$error')),
          loading:()=> const Center(child: CircularProgressIndicator())),
    );
  }
}
