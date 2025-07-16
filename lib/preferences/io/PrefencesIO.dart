import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesIO {

  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  Future save(String keyValue, String inputValue) async {

    final keyPhrase = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(keyPhrase));

    final encryptedValue = encrypter.encrypt(inputValue, iv: iv);

    (await _sharedPreferences).setString(keyValue, encryptedValue.base16);
    
  }
  
  Future<String?> read(String keyValue) async {

    String? decryptedValue = (await _sharedPreferences).getString(keyValue);

    if (decryptedValue != null) {

      final keyPhrase = Key.fromUtf8('my 32 length key................');
      final iv = IV.fromLength(16);

      final encrypter = Encrypter(AES(keyPhrase));

      final encryptedValue = encrypter.encrypt(decryptedValue, iv: iv);

      decryptedValue = encrypter.decrypt(encryptedValue);

    }

    return decryptedValue;
  }

}