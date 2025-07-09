class ProfileEndpoint {

  String profileDocument(String emailAddress) {

    return "Eresse/Profiles/${emailAddress.toUpperCase()}/Information";
  }

}