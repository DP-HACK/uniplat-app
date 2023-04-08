final String baseUrl = "https://dev.unify21.com/";
String getUrl(Urls url) {
  switch (url) {
    case Urls.signUp:
      return "${baseUrl}signup";
    case Urls.forgotPassword:
      return "${baseUrl}signup/find-password";
    case Urls.login:
      return "${baseUrl}login";
    case Urls.home:
      return baseUrl;
    case Urls.mylab:
      return "${baseUrl}mylab";
    case Urls.search:
      return "${baseUrl}search/";
    case Urls.upload:
      return "${baseUrl}mylab";
    case Urls.notice:
      return "${baseUrl}notice";
    case Urls.appLogin:
      return "${baseUrl}app/login";
    case Urls.apiLogin:
      return "${baseUrl}api/login";
    case Urls.streamingNew:
      return "${baseUrl}mylab/streaming/new";
    case Urls.videoNew:
      return "${baseUrl}mylab/video/new";
    case Urls.documentNew:
      return "${baseUrl}mylab/document/new";
    default:
      return "";
  }
}

enum Urls {
  signUp,
  forgotPassword,
  login,
  home,
  mylab,
  search,
  upload,
  notice,
  appLogin,
  apiLogin,
  streamingNew,
  videoNew,
  documentNew
}
