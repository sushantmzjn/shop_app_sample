
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/model/cart.dart';
import 'package:shop_app/model/product.dart';

final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) => CartProvider(ref.watch(box1)));

class CartProvider extends StateNotifier<List<CartItem>>{
  CartProvider(super.state);

  String add(Product product){
    if(state.isEmpty){
      final newCart = CartItem(
          id: product.id,
          product_name: product.product_name,
          image: product.image,
          quantity: 1,
          price: product.price
      );
     final box= Hive.box<CartItem>('carts').add(newCart);
     // box.add(newCart);
      state = [...state, newCart];
      return 'Successfully Added';
    }else{
      final prev = state.firstWhere((element) => element.id == product.id,
          orElse: ()=> CartItem(id: '', product_name: 'no data', image: 'image', quantity: 0, price: 0));

      if(prev.product_name == 'no data'){
        final newCart = CartItem(
            id: product.id,
            product_name: product.product_name,
            image: product.image,
            quantity: 1,
            price: product.price
        );
        final box= Hive.box<CartItem>('carts').add(newCart);
        // box.add(newCart);
        state = [...state, newCart];
        return 'Successfully Added';
      }else{
        return 'Already Added';
      }
    }
  }

  void remove(CartItem cartItem){
    cartItem.delete();
    state.remove(cartItem);
    state = [...state];
  }
  void singleAdd(CartItem cartItem){
    cartItem.quantity = cartItem.quantity + 1;
    cartItem.save();
    state = [
      for(final c in state) if(c == cartItem) cartItem else c
    ];
  }

  void singleRemove(CartItem cartItem){
    if(cartItem.quantity > 1){
      cartItem.quantity = cartItem.quantity - 1;
      cartItem.save();
      state = [
        for(final c in state) if(c == cartItem) cartItem else c
      ];
    }
  }

  int get total {
    int total = 0;
    for(final cart in state){
      total += cart.price * cart.quantity;
    }
    return total;
  }


}