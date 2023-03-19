import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_app/api.dart';
import 'package:shop_app/model/user.dart';

import '../api_exception.dart';


class AuthService {
  static Dio dio = Dio();

  //user login
  static Future<Either<String, User>> userLogin({
    required String email,
    required String password
})async{
    try{
      final response = await dio.post(Api.userLogin, data: {
        'email' : email,
        'password' : password
      });
      final user = User.fromJson(response.data);
      final box = Hive.box<User>('user');
      box.add(user);
      return Right(user);
    } on DioError catch(err){
      return Left(DioException.getDioError(err));
    }
  }

  //user signup
  static Future<Either<String, bool>> userSignUp({
    required String email,
    required String password,
    required String full_name
  })async{
    try{
      final response = await dio.post(Api.userSignUp, data: {
        'email' : email,
        'password' : password,
        'full_name': full_name

      });
      return const Right(true);
    } on DioError catch(err){
      return Left(DioException.getDioError(err));

    }
  }

}
