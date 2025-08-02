import 'package:Eresse/arwen/endpoints/ArwenEndpoints.dart';
import 'package:Eresse/database/cache/CacheIO.dart';
import 'package:Eresse/profile/credentials/CredentialsIO.dart';

class AskDI {

  CredentialsIO credentialsIO = CredentialsIO();

  ArwenEndpoints arwenEndpoints = ArwenEndpoints();

  CacheIO cacheIO = CacheIO();

}