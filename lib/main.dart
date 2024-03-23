import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'MyApp.dart';

void main() async {

  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.get('VAR_URL'), // .envのURLを取得.
    anonKey: dotenv.get('VAR_ANONKEY'), // .envのanonキーを取得.
  );
  Supabase.instance.client.auth.signInWithPassword(
      email: "1706367906929@test.com", password: "password");

  runApp(const MyApp());
}
