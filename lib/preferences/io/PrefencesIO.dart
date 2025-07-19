import 'package:Eresse/utils/security/Encoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesIO {

  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  Future save(String keyValue, String inputValue) async {

    (await _sharedPreferences).setString(keyValue.encode(), inputValue);
    
  }
  
  Future<String?> read(String keyValue) async {

    return (await _sharedPreferences).getString(keyValue.encode());
  }

}