import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shop_app/view/product_details.dart';

import '../../services/product_service.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productData = ref.watch(productShow);
    return SafeArea(
      child: productData.when(
          data: (data){
            return data.isEmpty ? const Center(child: Text('No Data'),) : MasonryGridView.builder(
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
                        child: GridTile(child:
                        CachedNetworkImage(
                          errorWidget: (context, url, error) => const Center(child: Text('no image')),
                          imageUrl: data[index].image,
                          placeholder: (context,url)=> const Center(child: Text('Loading...'),),
                        ),
                        ),
                      ),
                    ),
                  );
                });

          },
          error: (error, stack)=> Center(child: Text('$error')),
          loading:()=> const Center(child: CircularProgressIndicator())),
    );
  }
}