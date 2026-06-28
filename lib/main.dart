import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xtacy_backoffice/app.dart';
import 'package:xtacy_backoffice/core/constants/supabase_constants.dart';
import 'package:xtacy_backoffice/data/services/hive_service.dart';
import 'package:xtacy_backoffice/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  if (SupabaseConstants.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConstants.url,
      publishableKey: SupabaseConstants.anonKey,
    );
  }

  await HiveService.instance.init();

  runApp(const XtacyApp());
}
