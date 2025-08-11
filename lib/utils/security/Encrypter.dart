import 'package:Eresse/profile/credentials/CredentialsIO.dart';
import 'package:encrypt/encrypt.dart';

extension StringEncrypter on String {

  Future<String> encrypt(CredentialsIO credentialsIO) async {

    final keyPhrase = await credentialsIO.cipherKeyPhrase();

    final keyPhraseUtf8 = Key.fromUtf8(keyPhrase);

    final encrypter = Encrypter(AES(keyPhraseUtf8));

    final encryptedValue = encrypter.encrypt(this, iv: IV.fromUtf8(keyPhrase));

    return encryptedValue.base64;
  }

  Future<String> decrypt(CredentialsIO credentialsIO) async {

    final keyPhrase = await credentialsIO.cipherKeyPhrase();

    final keyPhraseUtf8 = Key.fromUtf8(keyPhrase);

    final encrypter = Encrypter(AES(keyPhraseUtf8));

    final encryptedValue = Encrypted.fromBase64(this);

    final decryptedValue = encrypter.decrypt(encryptedValue, iv: IV.fromUtf8(keyPhrase));

    return decryptedValue;
  }

}