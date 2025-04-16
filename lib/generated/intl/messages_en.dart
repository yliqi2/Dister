// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "Chat with ${name}";

  static String m1(error) => "Error during logout: ${error}";

  static String m2(error) => "Error: ${error}";

  static String m3(message) => "Unexpected error: ${message}";

  static String m4(error) => "Error uploading image: ${error}";

  static String m5(date) => "• Expires on ${date}";

  static String m6(count) => "• ${count} Likes";

  static String m7(count) => "${count} Likes";

  static String m8(percent) => "${percent}% off";

  static String m9(time) => "• Posted ${time} ago";

  static String m10(rating) => "• Rating: ${rating} ⭐";

  static String m11(name) => "• ${name}";

  static String m12(time) => "${time} ago";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AlreadyAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account? ",
    ),
    "allCategoriesFilter": MessageLookupByLibrary.simpleMessage(
      "All categories",
    ),
    "allSubcategoriesFilter": MessageLookupByLibrary.simpleMessage(
      "All subcategories",
    ),
    "cannotFollowAgain": MessageLookupByLibrary.simpleMessage(
      "You cannot follow this user again.",
    ),
    "cannotOpenLink": MessageLookupByLibrary.simpleMessage(
      "Cannot open the link",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Categories"),
    "categorydropdown": MessageLookupByLibrary.simpleMessage(
      "Select a category",
    ),
    "categoryerror": MessageLookupByLibrary.simpleMessage(
      "Please select a category",
    ),
    "categorylabel": MessageLookupByLibrary.simpleMessage("Category"),
    "chatWith": m0,
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "containsSpace": MessageLookupByLibrary.simpleMessage(
      "Username cannot contain spaces",
    ),
    "continuebtn": MessageLookupByLibrary.simpleMessage("Continue"),
    "continues": MessageLookupByLibrary.simpleMessage("Start Hunting"),
    "datehelptext": MessageLookupByLibrary.simpleMessage(
      "This camp is optional",
    ),
    "datehintText": MessageLookupByLibrary.simpleMessage("Select a date"),
    "datelabel": MessageLookupByLibrary.simpleMessage("Deal expires at..."),
    "descriptionerror": MessageLookupByLibrary.simpleMessage(
      "Please enter a description",
    ),
    "descriptionerror2": MessageLookupByLibrary.simpleMessage(
      "Description cannot be less than 10 characters",
    ),
    "descriptionerror3": MessageLookupByLibrary.simpleMessage(
      "Description cannot be more than 200 characters",
    ),
    "descriptionhint": MessageLookupByLibrary.simpleMessage(
      "Enter a description for the product",
    ),
    "descriptionlabel": MessageLookupByLibrary.simpleMessage("Description"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "emailInUse": MessageLookupByLibrary.simpleMessage("Email already in use"),
    "emptyConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Please confirm your password",
    ),
    "emptyEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email address",
    ),
    "emptyPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter a password",
    ),
    "emptyUsername": MessageLookupByLibrary.simpleMessage(
      "Please enter your username",
    ),
    "errorCredential": MessageLookupByLibrary.simpleMessage(
      "Incorrect credentials",
    ),
    "errorDuringLogout": m1,
    "errorGeneric": m2,
    "errorLoadingListings": MessageLookupByLibrary.simpleMessage(
      "Error loading listings. Please try again.",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage("Network Problem"),
    "errorUnknow": m3,
    "errorUploadingImage": m4,
    "errorhighlight": MessageLookupByLibrary.simpleMessage(
      "Please select at least one highlight.",
    ),
    "errorimage": MessageLookupByLibrary.simpleMessage(
      "Please upload at least one image.",
    ),
    "erroruploading": MessageLookupByLibrary.simpleMessage(
      "Error uploading listing, please try again.",
    ),
    "exampleUrl": MessageLookupByLibrary.simpleMessage(
      "www.dister.com/example",
    ),
    "expiresOn": m5,
    "finalpriceerror": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid price",
    ),
    "finalpriceerror2": MessageLookupByLibrary.simpleMessage(
      "Final price must be less than original price",
    ),
    "finalpricelabel": MessageLookupByLibrary.simpleMessage("Final Price"),
    "firstpage": MessageLookupByLibrary.simpleMessage(
      "Share a deal\nwith millions of users",
    ),
    "firstpagesubtitle": MessageLookupByLibrary.simpleMessage(
      "Reach millions and make the offer stand out!",
    ),
    "follow": MessageLookupByLibrary.simpleMessage("Follow"),
    "followers": MessageLookupByLibrary.simpleMessage("Followers"),
    "following": MessageLookupByLibrary.simpleMessage("Following"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "Forgot your password? ",
    ),
    "formError": MessageLookupByLibrary.simpleMessage("Fix the form"),
    "goForDiscount": MessageLookupByLibrary.simpleMessage(
      "Go for the discount",
    ),
    "goback": MessageLookupByLibrary.simpleMessage("Go back to home"),
    "hintConfirmPass": MessageLookupByLibrary.simpleMessage(
      "Confirm your password",
    ),
    "hintEmail": MessageLookupByLibrary.simpleMessage(
      "Enter your email address",
    ),
    "hintPass": MessageLookupByLibrary.simpleMessage("Enter your password"),
    "hintUser": MessageLookupByLibrary.simpleMessage("Enter your username"),
    "infoTerms": MessageLookupByLibrary.simpleMessage(
      "By signing up, you agree to our ",
    ),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "joinUs": MessageLookupByLibrary.simpleMessage("Join Us"),
    "lenghtPassword": MessageLookupByLibrary.simpleMessage(
      "Password must be a least 8 characters",
    ),
    "likesCount": m6,
    "likesText": m7,
    "link": MessageLookupByLibrary.simpleMessage("Link"),
    "linkempty": MessageLookupByLibrary.simpleMessage("Please enter a link"),
    "linkerror": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid link",
    ),
    "linkhelptext": MessageLookupByLibrary.simpleMessage(
      "Paste the link to where other users can find the deal",
    ),
    "listings": MessageLookupByLibrary.simpleMessage("Listings"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter your details to start saving and\n shopping smarter!",
    ),
    "loginTitle": MessageLookupByLibrary.simpleMessage(
      "Welcome back,\nLog in your deals.",
    ),
    "loginbtn": MessageLookupByLibrary.simpleMessage("Login"),
    "longUsername": MessageLookupByLibrary.simpleMessage(
      "Username cannot be more than 15 characters",
    ),
    "messages": MessageLookupByLibrary.simpleMessage("Messages"),
    "noAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? ",
    ),
    "noDescription": MessageLookupByLibrary.simpleMessage(
      "No description has been added.",
    ),
    "noListingsAvailable": MessageLookupByLibrary.simpleMessage(
      "No listings available.",
    ),
    "noMessages": MessageLookupByLibrary.simpleMessage("No messages yet."),
    "noUserData": MessageLookupByLibrary.simpleMessage(
      "No user data available",
    ),
    "notValidDomainEmail": MessageLookupByLibrary.simpleMessage(
      "Email must end with @gmail.com",
    ),
    "originalMessage": MessageLookupByLibrary.simpleMessage("Original message"),
    "originalprice": MessageLookupByLibrary.simpleMessage("Original Price"),
    "originalpriceerror": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid price",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "percentOff": m8,
    "postedTimeAgo": m9,
    "privacy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "productDetails": MessageLookupByLibrary.simpleMessage("Product Details"),
    "profileUpdated": MessageLookupByLibrary.simpleMessage(
      "Profile picture updated successfully.",
    ),
    "publish": MessageLookupByLibrary.simpleMessage("Publish"),
    "publishing": MessageLookupByLibrary.simpleMessage("Publishing..."),
    "ratingWithStars": m10,
    "readLess": MessageLookupByLibrary.simpleMessage(" Read Less"),
    "readMore": MessageLookupByLibrary.simpleMessage(" Read More"),
    "registerbtn": MessageLookupByLibrary.simpleMessage("Register"),
    "resetPassword": MessageLookupByLibrary.simpleMessage(
      "Reset your password",
    ),
    "searchHint": MessageLookupByLibrary.simpleMessage(
      "Search for \"clothes\"",
    ),
    "searchHint2": MessageLookupByLibrary.simpleMessage("Search for \"tech\""),
    "searchHint3": MessageLookupByLibrary.simpleMessage(
      "Search for \"furniture\"",
    ),
    "secondpagesubtitle": MessageLookupByLibrary.simpleMessage(
      "You must upload at least one image to continue.",
    ),
    "secondpagetitle": MessageLookupByLibrary.simpleMessage(
      "Add Images for the Deal",
    ),
    "segurityConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "segurityPassword": MessageLookupByLibrary.simpleMessage(
      "Password must include letters and numbers",
    ),
    "selectCategoryFilter": MessageLookupByLibrary.simpleMessage(
      "Select a category",
    ),
    "selectSubcategoryFilter": MessageLookupByLibrary.simpleMessage(
      "Select a subcategory",
    ),
    "selecthighlights": MessageLookupByLibrary.simpleMessage(
      "Select highlights for the Deal",
    ),
    "sendMessage": MessageLookupByLibrary.simpleMessage("Send Message"),
    "shoppingDetails": MessageLookupByLibrary.simpleMessage("Shopping Details"),
    "shortUsername": MessageLookupByLibrary.simpleMessage(
      "Username must be more than 5 characters",
    ),
    "signSubtitle": MessageLookupByLibrary.simpleMessage(
      "Let\'s get started & create your account.",
    ),
    "signTitle": MessageLookupByLibrary.simpleMessage(
      "Sign up, to unlock deals!",
    ),
    "storePrefix": m11,
    "subcategorydropdown": MessageLookupByLibrary.simpleMessage(
      "Select a subcategory",
    ),
    "subcategoryerror": MessageLookupByLibrary.simpleMessage(
      "Please select a subcategory",
    ),
    "subcategorylabel": MessageLookupByLibrary.simpleMessage("Subcategory"),
    "subtitle_onboarding": MessageLookupByLibrary.simpleMessage(
      "Discover treasures and great deals.\nConnect today!",
    ),
    "subtitle_onboarding2": MessageLookupByLibrary.simpleMessage(
      "Compare prices and get the best deals \nwith a tap!",
    ),
    "subtitle_onboarding3": MessageLookupByLibrary.simpleMessage(
      "Your next great deal is just\na notification away.",
    ),
    "subtitlehigh": MessageLookupByLibrary.simpleMessage(
      "Choose any highlights that apply to your deal.",
    ),
    "terms": MessageLookupByLibrary.simpleMessage("Terms"),
    "tiendaerror": MessageLookupByLibrary.simpleMessage(
      "Please enter the store name",
    ),
    "tiendahint": MessageLookupByLibrary.simpleMessage(
      "E.g.: Zalando, Amazon...",
    ),
    "tiendalabel": MessageLookupByLibrary.simpleMessage("Store name"),
    "timeAgo": m12,
    "timeDay": MessageLookupByLibrary.simpleMessage("d"),
    "timeHour": MessageLookupByLibrary.simpleMessage("H"),
    "timeMinute": MessageLookupByLibrary.simpleMessage("min."),
    "title_onboarding": MessageLookupByLibrary.simpleMessage(
      "Find what\nyou need and more",
    ),
    "title_onboarding2": MessageLookupByLibrary.simpleMessage(
      "Get More,\nSpend Less",
    ),
    "title_onboarding3": MessageLookupByLibrary.simpleMessage(
      "Never\nMiss Out Again",
    ),
    "titleerror": MessageLookupByLibrary.simpleMessage("Please enter a title"),
    "titleerror2": MessageLookupByLibrary.simpleMessage(
      "Title cannot be less than 3 characters",
    ),
    "titlehint": MessageLookupByLibrary.simpleMessage("Product name"),
    "titlelabel": MessageLookupByLibrary.simpleMessage("Title"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "translate": MessageLookupByLibrary.simpleMessage("Translate"),
    "translatedMessage": MessageLookupByLibrary.simpleMessage(
      "Translated message",
    ),
    "translating": MessageLookupByLibrary.simpleMessage("Translating..."),
    "typeMessage": MessageLookupByLibrary.simpleMessage("Type a message..."),
    "unfollow": MessageLookupByLibrary.simpleMessage("Unfollow"),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "userLabel": MessageLookupByLibrary.simpleMessage("Username"),
    "userNotFound": MessageLookupByLibrary.simpleMessage("User not found"),
    "usernameInUse": MessageLookupByLibrary.simpleMessage(
      "Username already in use",
    ),
    "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
  };
}
