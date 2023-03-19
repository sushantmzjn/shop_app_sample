import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';
import 'home_page.dart';
import 'login_page.dart';



class StatusPage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: auth.user.isEmpty ? LoginPage() : HomePage(),
    );
  }
}