import 'package:flutter/material.dart';
import 'package:sae_mobile/services/supabase_services.dart';
import 'package:sae_mobile/models/user.dart';

class UserViewModel extends ChangeNotifier {
  final SupabaseServices supabaseService = SupabaseServices();
}