import 'dart:convert';

extension StringEncoder on String {

  String encode() {
    List<int> bytes = utf8.encode(this);
    String hexString = bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
    return hexString;
  }

  String decode() {

    List<String> hexPairs = [];
    for (int i = 0; i < length; i += 2) {
      hexPairs.add(substring(i, i + 2));
    }

    String decodedString = hexPairs.map((hexPair) => String.fromCharCode(int.parse(hexPair, radix: 16))).join();

    return decodedString;
  }

}