import 'package:Eresse/preferences/io/PrefencesIO.dart';
import 'package:Eresse/utils/network/RemoteConfigurations.dart';

class ArwenEndpoints {

  static const aiTextEndpoint = 'aiTextEndpoint';

  final _preferencesIO = PreferencesIO();

  Future<String> retrieveEndpoint(String endpointKey) async {

    String? aiEndpoint = await _preferencesIO.read(endpointKey);

    if (aiEndpoint == null) {

      aiEndpoint = await retrieveRemoteConfig(endpointKey);

      await _preferencesIO.save(endpointKey, aiEndpoint);

    }

    return aiEndpoint;
  }

}