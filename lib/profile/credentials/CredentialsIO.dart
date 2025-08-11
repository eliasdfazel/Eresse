import 'package:Eresse/preferences/io/PrefencesIO.dart';
import 'package:Eresse/utils/network/RemoteConfigurations.dart';

class CredentialsIO {

  static const String apiKEY = 'aiKeyAPI';
  static const String cipherPhraseKey = 'keyPhrase';

  final _preferencesIO = PreferencesIO();

  Future<String> generateApiKey() async {

    String? aiApiKey = await _preferencesIO.read(CredentialsIO.apiKEY);

    if (aiApiKey == null) {

      aiApiKey = await retrieveRemoteConfig(CredentialsIO.apiKEY);

      await _preferencesIO.store(CredentialsIO.apiKEY, aiApiKey);

    }

    return aiApiKey;
  }

  Future<String> cipherKeyPhrase() async {

    String? keyPhrase = await _preferencesIO.read(CredentialsIO.cipherPhraseKey);

    if (keyPhrase == null) {

      keyPhrase = await retrieveRemoteConfig('keyPhrase');

      await _preferencesIO.store(CredentialsIO.cipherPhraseKey, keyPhrase);

    }

    return keyPhrase;
  }

}