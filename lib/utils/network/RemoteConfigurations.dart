import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<String> retrieveRemoteConfig(String configKey, {int minimumFetchInterval = 37000}) async {

  final firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(seconds: 3), minimumFetchInterval: Duration(milliseconds: minimumFetchInterval)));

  await firebaseRemoteConfig.fetchAndActivate();

  return firebaseRemoteConfig.getString(configKey);
}