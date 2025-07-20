class ProfileEndpoint {

  String profileDocument(String emailAddress) {

    return "Eresse/${emailAddress.toUpperCase()}";
  }

}