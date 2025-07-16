import 'package:Eresse/utils/network/RemoteConfigurations.dart';
import 'package:encrypt/encrypt.dart';

extension StringEncrypter on String {

  Future<String> encrypt() async {

    final keyPhrase = await retrieveRemoteConfig('keyPhrase');

    final keyPhraseUtf8 = Key.fromUtf8(keyPhrase);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(keyPhraseUtf8));

    final encryptedValue = encrypter.encrypt(this, iv: iv);

    return encryptedValue.base64;
  }

  Future<String> decrypt() async {

    final keyPhrase = await retrieveRemoteConfig('keyPhrase');

    final keyPhraseUtf8 = Key.fromUtf8(keyPhrase);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(keyPhraseUtf8));

    final encryptedValue = encrypter.encrypt(this, iv: iv);

    final decryptedValue = encrypter.decrypt(encryptedValue);

    return decryptedValue;
  }

}