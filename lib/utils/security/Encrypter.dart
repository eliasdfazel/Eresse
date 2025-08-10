import 'package:Eresse/utils/network/RemoteConfigurations.dart';
import 'package:encrypt/encrypt.dart';

extension StringEncrypter on String {

  Future<String> encrypt() async {

    final keyPhrase = await retrieveRemoteConfig('keyPhrase');

    final keyPhraseUtf8 = Key.fromUtf8(keyPhrase);

    final encrypter = Encrypter(AES(keyPhraseUtf8));

    final encryptedValue = encrypter.encrypt(this, iv: IV.fromUtf8(keyPhrase));

    return encryptedValue.base64;
  }

  Future<String> decrypt() async {

    final keyPhrase = await retrieveRemoteConfig('keyPhrase');

    final keyPhraseUtf8 = Key.fromUtf8(keyPhrase);

    final encrypter = Encrypter(AES(keyPhraseUtf8));

    final encryptedValue = Encrypted.fromBase64(this);

    final decryptedValue = encrypter.decrypt(encryptedValue, iv: IV.fromUtf8(keyPhrase));

    return decryptedValue;
  }

}