import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future<Uri> createDynamicLinkForUserProfile(String userId) async {
    print("start building link");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://iduteapp.page.link',
      link: Uri.parse('https://iduteapp/page/link/user?user=$userId'),
      androidParameters:
          const AndroidParameters(packageName: 'com.example.idute_app'),
    );

    Uri dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
    // dynamicLink = Uri.parse(dynamicLink.queryParameters["link"]!);
    return dynamicLink;
  }

  Future<Uri> createDynamicLinkForGroup(String groupid) async {
    print("start building link");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://iduteapp.page.link',
      link: Uri.parse('https://iduteapp/page/link/group?group=$groupid'),
      androidParameters:
          const AndroidParameters(packageName: 'com.example.idute_app'),
    );

    Uri dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
    // dynamicLink = Uri.parse(dynamicLink.queryParameters["link"]!);
    return dynamicLink;
  }

  Future<Uri> createDynamicLinkForPost(String postId) async {
    print("start building link");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://iduteapp.page.link',
      link: Uri.parse('https://iduteapp/page/link/post?post=$postId'),
      androidParameters:
          const AndroidParameters(packageName: 'com.example.idute_app'),
    );

    Uri dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
    // dynamicLink = Uri.parse(dynamicLink.queryParameters["link"]!);
    return dynamicLink;
  }
}
