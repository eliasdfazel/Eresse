import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class NetworkInterface {
  void networkEnabled();
  void networkDisabled();
}

class Networking {

  static const networkStatus = 'networkStatus';
  static const networkHeaders = 'networkHeaders';
  static const networkBody = 'networkBody';

  Networking() {

    /*
     * Start - Cache Offline Indicator Image
     */
    offlineMode();
    /*
     * End - Cache Offline Indicator Image
     */

  }

  void networkCheckpoint(NetworkInterface networkInterface, List<ConnectivityResult> connectivityResults) async {

    if (connectivityResults.contains(ConnectivityResult.mobile)
        || connectivityResults.contains(ConnectivityResult.wifi)
        || connectivityResults.contains(ConnectivityResult.vpn)
        || connectivityResults.contains(ConnectivityResult.ethernet)) {

      final firstInternetLookup = await getRequest('https://8.8.8.8/');

      bool firstInternetConnection = (int.parse(firstInternetLookup[Networking.networkStatus].toString()) == 200);

      if (firstInternetConnection) {

        networkInterface.networkEnabled();

      } else {

        final secondInternetLookup = await getRequest('https://1.1.1.1/');

        bool secondInternetConnection = (int.parse(secondInternetLookup[Networking.networkStatus].toString()) == 200);

        if (secondInternetConnection) {

          networkInterface.networkEnabled();

        } else {

          networkInterface.networkDisabled();

        }

      }

    } else {

      networkInterface.networkDisabled();

    }

  }

  Future<Map<String, dynamic>> getRequest(String networkEndpoint) async {

    final internetLookup = await http.get(Uri.parse(networkEndpoint));

    return {
      Networking.networkStatus: internetLookup.statusCode,
      Networking.networkHeaders: internetLookup.headers,
      Networking.networkBody: internetLookup.body,
    };
  }

  Widget offlineMode() {

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: InkWell(
        onTap: () async {



        },
        child: CachedNetworkImage(
          imageUrl: "https://firebasestorage.googleapis.com/v0/b/arwen-productivity.firebasestorage.app/o/Eresse%2FAssets%2FIcons%2Fno_internet_connection.jpg?alt=media",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      )
    );
  }

}