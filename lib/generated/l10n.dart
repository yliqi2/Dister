// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Find what\nyou need and more`
  String get title_onboarding {
    return Intl.message(
      'Find what\nyou need and more',
      name: 'title_onboarding',
      desc: '',
      args: [],
    );
  }

  /// `Discover treasures and great deals.\nConnect today!`
  String get subtitle_onboarding {
    return Intl.message(
      'Discover treasures and great deals.\nConnect today!',
      name: 'subtitle_onboarding',
      desc: '',
      args: [],
    );
  }

  /// `Get More,\nSpend Less`
  String get title_onboarding2 {
    return Intl.message(
      'Get More,\nSpend Less',
      name: 'title_onboarding2',
      desc: '',
      args: [],
    );
  }

  /// `Compare prices and get the best deals \nwith a tap!`
  String get subtitle_onboarding2 {
    return Intl.message(
      'Compare prices and get the best deals \nwith a tap!',
      name: 'subtitle_onboarding2',
      desc: '',
      args: [],
    );
  }

  /// `Never\nMiss Out Again`
  String get title_onboarding3 {
    return Intl.message(
      'Never\nMiss Out Again',
      name: 'title_onboarding3',
      desc: '',
      args: [],
    );
  }

  /// `Your next great deal is just\na notification away.`
  String get subtitle_onboarding3 {
    return Intl.message(
      'Your next great deal is just\na notification away.',
      name: 'subtitle_onboarding3',
      desc: '',
      args: [],
    );
  }

  /// `Start Hunting`
  String get continues {
    return Intl.message('Start Hunting', name: 'continues', desc: '', args: []);
  }

  /// `Enter your username`
  String get hintUser {
    return Intl.message(
      'Enter your username',
      name: 'hintUser',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userLabel {
    return Intl.message('Username', name: 'userLabel', desc: '', args: []);
  }

  /// `Enter your email address`
  String get hintEmail {
    return Intl.message(
      'Enter your email address',
      name: 'hintEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get hintPass {
    return Intl.message(
      'Enter your password',
      name: 'hintPass',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get hintConfirmPass {
    return Intl.message(
      'Confirm your password',
      name: 'hintConfirmPass',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginbtn {
    return Intl.message('Login', name: 'loginbtn', desc: '', args: []);
  }

  /// `Register`
  String get registerbtn {
    return Intl.message('Register', name: 'registerbtn', desc: '', args: []);
  }

  /// `Please enter your username`
  String get emptyUsername {
    return Intl.message(
      'Please enter your username',
      name: 'emptyUsername',
      desc: '',
      args: [],
    );
  }

  /// `Username must be more than 5 characters`
  String get shortUsername {
    return Intl.message(
      'Username must be more than 5 characters',
      name: 'shortUsername',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be more than 15 characters`
  String get longUsername {
    return Intl.message(
      'Username cannot be more than 15 characters',
      name: 'longUsername',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot contain spaces`
  String get containsSpace {
    return Intl.message(
      'Username cannot contain spaces',
      name: 'containsSpace',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address`
  String get emptyEmail {
    return Intl.message(
      'Please enter your email address',
      name: 'emptyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email must end with @gmail.com`
  String get notValidDomainEmail {
    return Intl.message(
      'Email must end with @gmail.com',
      name: 'notValidDomainEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get emptyPassword {
    return Intl.message(
      'Please enter a password',
      name: 'emptyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be a least 8 characters`
  String get lenghtPassword {
    return Intl.message(
      'Password must be a least 8 characters',
      name: 'lenghtPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must include letters and numbers`
  String get segurityPassword {
    return Intl.message(
      'Password must include letters and numbers',
      name: 'segurityPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get emptyConfirmPassword {
    return Intl.message(
      'Please confirm your password',
      name: 'emptyConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get segurityConfirmPassword {
    return Intl.message(
      'Passwords do not match',
      name: 'segurityConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Fix the form`
  String get formError {
    return Intl.message('Fix the form', name: 'formError', desc: '', args: []);
  }

  /// `Incorrect credentials`
  String get errorCredential {
    return Intl.message(
      'Incorrect credentials',
      name: 'errorCredential',
      desc: '',
      args: [],
    );
  }

  /// `Network Problem`
  String get errorNetwork {
    return Intl.message(
      'Network Problem',
      name: 'errorNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error: {message}`
  String errorUnknow(Object message) {
    return Intl.message(
      'Unexpected error: $message',
      name: 'errorUnknow',
      desc: '',
      args: [message],
    );
  }

  /// `Username already in use`
  String get usernameInUse {
    return Intl.message(
      'Username already in use',
      name: 'usernameInUse',
      desc: '',
      args: [],
    );
  }

  /// `Email already in use`
  String get emailInUse {
    return Intl.message(
      'Email already in use',
      name: 'emailInUse',
      desc: '',
      args: [],
    );
  }

  /// `Sign up, to unlock deals!`
  String get signTitle {
    return Intl.message(
      'Sign up, to unlock deals!',
      name: 'signTitle',
      desc: '',
      args: [],
    );
  }

  /// `Let's get started & create your account.`
  String get signSubtitle {
    return Intl.message(
      'Let\'s get started & create your account.',
      name: 'signSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `By signing up, you agree to our `
  String get infoTerms {
    return Intl.message(
      'By signing up, you agree to our ',
      name: 'infoTerms',
      desc: '',
      args: [],
    );
  }

  /// `Terms`
  String get terms {
    return Intl.message('Terms', name: 'terms', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacy {
    return Intl.message('Privacy Policy', name: 'privacy', desc: '', args: []);
  }

  /// `Welcome back,\nLog in your deals.`
  String get loginTitle {
    return Intl.message(
      'Welcome back,\nLog in your deals.',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your details to start saving and\n shopping smarter!`
  String get loginSubtitle {
    return Intl.message(
      'Enter your details to start saving and\n shopping smarter!',
      name: 'loginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password? `
  String get forgotPassword {
    return Intl.message(
      'Forgot your password? ',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset your password`
  String get resetPassword {
    return Intl.message(
      'Reset your password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get noAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Join Us`
  String get joinUs {
    return Intl.message('Join Us', name: 'joinUs', desc: '', args: []);
  }

  /// `Already have an account? `
  String get AlreadyAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'AlreadyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Search for "clothes"`
  String get searchHint {
    return Intl.message(
      'Search for "clothes"',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Search for "tech"`
  String get searchHint2 {
    return Intl.message(
      'Search for "tech"',
      name: 'searchHint2',
      desc: '',
      args: [],
    );
  }

  /// `Search for "furniture"`
  String get searchHint3 {
    return Intl.message(
      'Search for "furniture"',
      name: 'searchHint3',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Upload`
  String get upload {
    return Intl.message('Upload', name: 'upload', desc: '', args: []);
  }

  /// `Share a deal\nwith millions of users`
  String get firstpage {
    return Intl.message(
      'Share a deal\nwith millions of users',
      name: 'firstpage',
      desc: '',
      args: [],
    );
  }

  /// `Reach millions and make the offer stand out!`
  String get firstpagesubtitle {
    return Intl.message(
      'Reach millions and make the offer stand out!',
      name: 'firstpagesubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Paste the link to where other users can find the deal`
  String get linkhelptext {
    return Intl.message(
      'Paste the link to where other users can find the deal',
      name: 'linkhelptext',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a link`
  String get linkempty {
    return Intl.message(
      'Please enter a link',
      name: 'linkempty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid link`
  String get linkerror {
    return Intl.message(
      'Please enter a valid link',
      name: 'linkerror',
      desc: '',
      args: [],
    );
  }

  /// `Product name`
  String get titlehint {
    return Intl.message('Product name', name: 'titlehint', desc: '', args: []);
  }

  /// `Title`
  String get titlelabel {
    return Intl.message('Title', name: 'titlelabel', desc: '', args: []);
  }

  /// `Please enter a title`
  String get titleerror {
    return Intl.message(
      'Please enter a title',
      name: 'titleerror',
      desc: '',
      args: [],
    );
  }

  /// `Title cannot be less than 3 characters`
  String get titleerror2 {
    return Intl.message(
      'Title cannot be less than 3 characters',
      name: 'titleerror2',
      desc: '',
      args: [],
    );
  }

  /// `E.g.: Zalando, Amazon...`
  String get tiendahint {
    return Intl.message(
      'E.g.: Zalando, Amazon...',
      name: 'tiendahint',
      desc: '',
      args: [],
    );
  }

  /// `Store name`
  String get tiendalabel {
    return Intl.message('Store name', name: 'tiendalabel', desc: '', args: []);
  }

  /// `Please enter the store name`
  String get tiendaerror {
    return Intl.message(
      'Please enter the store name',
      name: 'tiendaerror',
      desc: '',
      args: [],
    );
  }

  /// `Enter a description for the product`
  String get descriptionhint {
    return Intl.message(
      'Enter a description for the product',
      name: 'descriptionhint',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get descriptionlabel {
    return Intl.message(
      'Description',
      name: 'descriptionlabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a description`
  String get descriptionerror {
    return Intl.message(
      'Please enter a description',
      name: 'descriptionerror',
      desc: '',
      args: [],
    );
  }

  /// `Description cannot be less than 10 characters`
  String get descriptionerror2 {
    return Intl.message(
      'Description cannot be less than 10 characters',
      name: 'descriptionerror2',
      desc: '',
      args: [],
    );
  }

  /// `Description cannot be more than 200 characters`
  String get descriptionerror3 {
    return Intl.message(
      'Description cannot be more than 200 characters',
      name: 'descriptionerror3',
      desc: '',
      args: [],
    );
  }

  /// `Original Price`
  String get originalprice {
    return Intl.message(
      'Original Price',
      name: 'originalprice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid price`
  String get originalpriceerror {
    return Intl.message(
      'Please enter a valid price',
      name: 'originalpriceerror',
      desc: '',
      args: [],
    );
  }

  /// `Final Price`
  String get finalpricelabel {
    return Intl.message(
      'Final Price',
      name: 'finalpricelabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid price`
  String get finalpriceerror {
    return Intl.message(
      'Please enter a valid price',
      name: 'finalpriceerror',
      desc: '',
      args: [],
    );
  }

  /// `Final price must be less than original price`
  String get finalpriceerror2 {
    return Intl.message(
      'Final price must be less than original price',
      name: 'finalpriceerror2',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continuebtn {
    return Intl.message('Continue', name: 'continuebtn', desc: '', args: []);
  }

  /// `Add Images for the Deal`
  String get secondpagetitle {
    return Intl.message(
      'Add Images for the Deal',
      name: 'secondpagetitle',
      desc: '',
      args: [],
    );
  }

  /// `You must upload at least one image to continue.`
  String get secondpagesubtitle {
    return Intl.message(
      'You must upload at least one image to continue.',
      name: 'secondpagesubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Select a category`
  String get categorydropdown {
    return Intl.message(
      'Select a category',
      name: 'categorydropdown',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get categorylabel {
    return Intl.message('Category', name: 'categorylabel', desc: '', args: []);
  }

  /// `Please select a category`
  String get categoryerror {
    return Intl.message(
      'Please select a category',
      name: 'categoryerror',
      desc: '',
      args: [],
    );
  }

  /// `Select a subcategory`
  String get subcategorydropdown {
    return Intl.message(
      'Select a subcategory',
      name: 'subcategorydropdown',
      desc: '',
      args: [],
    );
  }

  /// `Subcategory`
  String get subcategorylabel {
    return Intl.message(
      'Subcategory',
      name: 'subcategorylabel',
      desc: '',
      args: [],
    );
  }

  /// `Please select a subcategory`
  String get subcategoryerror {
    return Intl.message(
      'Please select a subcategory',
      name: 'subcategoryerror',
      desc: '',
      args: [],
    );
  }

  /// `Deal expires at...`
  String get datelabel {
    return Intl.message(
      'Deal expires at...',
      name: 'datelabel',
      desc: '',
      args: [],
    );
  }

  /// `This camp is optional`
  String get datehelptext {
    return Intl.message(
      'This camp is optional',
      name: 'datehelptext',
      desc: '',
      args: [],
    );
  }

  /// `Select a date`
  String get datehintText {
    return Intl.message(
      'Select a date',
      name: 'datehintText',
      desc: '',
      args: [],
    );
  }

  /// `Select highlights for the Deal`
  String get selecthighlights {
    return Intl.message(
      'Select highlights for the Deal',
      name: 'selecthighlights',
      desc: '',
      args: [],
    );
  }

  /// `Choose any highlights that apply to your deal.`
  String get subtitlehigh {
    return Intl.message(
      'Choose any highlights that apply to your deal.',
      name: 'subtitlehigh',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading listing, please try again.`
  String get erroruploading {
    return Intl.message(
      'Error uploading listing, please try again.',
      name: 'erroruploading',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one highlight.`
  String get errorhighlight {
    return Intl.message(
      'Please select at least one highlight.',
      name: 'errorhighlight',
      desc: '',
      args: [],
    );
  }

  /// `Please upload at least one image.`
  String get errorimage {
    return Intl.message(
      'Please upload at least one image.',
      name: 'errorimage',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message('Publish', name: 'publish', desc: '', args: []);
  }

  /// `Publishing...`
  String get publishing {
    return Intl.message(
      'Publishing...',
      name: 'publishing',
      desc: '',
      args: [],
    );
  }

  /// `Error loading listings. Please try again.`
  String get errorLoadingListings {
    return Intl.message(
      'Error loading listings. Please try again.',
      name: 'errorLoadingListings',
      desc: '',
      args: [],
    );
  }

  /// `No listings available.`
  String get noListingsAvailable {
    return Intl.message(
      'No listings available.',
      name: 'noListingsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Go back to home`
  String get goback {
    return Intl.message('Go back to home', name: 'goback', desc: '', args: []);
  }

  /// `Chat with {name}`
  String chatWith(Object name) {
    return Intl.message(
      'Chat with $name',
      name: 'chatWith',
      desc: '',
      args: [name],
    );
  }

  /// `No messages yet.`
  String get noMessages {
    return Intl.message(
      'No messages yet.',
      name: 'noMessages',
      desc: '',
      args: [],
    );
  }

  /// `Type a message...`
  String get typeMessage {
    return Intl.message(
      'Type a message...',
      name: 'typeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message('Translate', name: 'translate', desc: '', args: []);
  }

  /// `Translating...`
  String get translating {
    return Intl.message(
      'Translating...',
      name: 'translating',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `Original message`
  String get originalMessage {
    return Intl.message(
      'Original message',
      name: 'originalMessage',
      desc: '',
      args: [],
    );
  }

  /// `Translated message`
  String get translatedMessage {
    return Intl.message(
      'Translated message',
      name: 'translatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cannot open the link`
  String get cannotOpenLink {
    return Intl.message(
      'Cannot open the link',
      name: 'cannotOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Details`
  String get shoppingDetails {
    return Intl.message(
      'Shopping Details',
      name: 'shoppingDetails',
      desc: '',
      args: [],
    );
  }

  /// `• Rating: {rating} ⭐`
  String ratingWithStars(Object rating) {
    return Intl.message(
      '• Rating: $rating ⭐',
      name: 'ratingWithStars',
      desc: '',
      args: [rating],
    );
  }

  /// `• {count} Likes`
  String likesCount(Object count) {
    return Intl.message(
      '• $count Likes',
      name: 'likesCount',
      desc: '',
      args: [count],
    );
  }

  /// `• Posted {time} ago`
  String postedTimeAgo(Object time) {
    return Intl.message(
      '• Posted $time ago',
      name: 'postedTimeAgo',
      desc: '',
      args: [time],
    );
  }

  /// `• Expires on {date}`
  String expiresOn(Object date) {
    return Intl.message(
      '• Expires on $date',
      name: 'expiresOn',
      desc: '',
      args: [date],
    );
  }

  /// `Go for the discount`
  String get goForDiscount {
    return Intl.message(
      'Go for the discount',
      name: 'goForDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Profile picture updated successfully.`
  String get profileUpdated {
    return Intl.message(
      'Profile updated successfully.',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading image: {error}`
  String errorUploadingImage(Object error) {
    return Intl.message(
      'Error uploading image: $error',
      name: 'errorUploadingImage',
      desc: '',
      args: [error],
    );
  }

  /// `Error: {error}`
  String errorGeneric(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'errorGeneric',
      desc: '',
      args: [error],
    );
  }

  /// `No user data available`
  String get noUserData {
    return Intl.message(
      'No user data available',
      name: 'noUserData',
      desc: '',
      args: [],
    );
  }

  /// `Error during logout: {error}`
  String errorDuringLogout(Object error) {
    return Intl.message(
      'Error during logout: $error',
      name: 'errorDuringLogout',
      desc: '',
      args: [error],
    );
  }

  /// `No description has been added.`
  String get noDescription {
    return Intl.message(
      'No description has been added.',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// ` Read Less`
  String get readLess {
    return Intl.message(' Read Less', name: 'readLess', desc: '', args: []);
  }

  /// ` Read More`
  String get readMore {
    return Intl.message(' Read More', name: 'readMore', desc: '', args: []);
  }

  /// `You cannot follow this user again.`
  String get cannotFollowAgain {
    return Intl.message(
      'You cannot follow this user again.',
      name: 'cannotFollowAgain',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get follow {
    return Intl.message('Follow', name: 'follow', desc: '', args: []);
  }

  /// `Unfollow`
  String get unfollow {
    return Intl.message('Unfollow', name: 'unfollow', desc: '', args: []);
  }

  /// `Send Message`
  String get sendMessage {
    return Intl.message(
      'Send Message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get followers {
    return Intl.message('Followers', name: 'followers', desc: '', args: []);
  }

  /// `Following`
  String get following {
    return Intl.message('Following', name: 'following', desc: '', args: []);
  }

  /// `Listings`
  String get listings {
    return Intl.message('Listings', name: 'listings', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `User not found`
  String get userNotFound {
    return Intl.message(
      'User not found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `www.dister.com/example`
  String get exampleUrl {
    return Intl.message(
      'www.dister.com/example',
      name: 'exampleUrl',
      desc: '',
      args: [],
    );
  }

  /// `Link`
  String get link {
    return Intl.message('Link', name: 'link', desc: '', args: []);
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `{percent}% off`
  String percentOff(Object percent) {
    return Intl.message(
      '$percent% off',
      name: 'percentOff',
      desc: '',
      args: [percent],
    );
  }

  /// `• {name}`
  String storePrefix(Object name) {
    return Intl.message('• $name', name: 'storePrefix', desc: '', args: [name]);
  }

  /// `{time} ago`
  String timeAgo(Object time) {
    return Intl.message('$time ago', name: 'timeAgo', desc: '', args: [time]);
  }

  /// `{count} Likes`
  String likesText(Object count) {
    return Intl.message(
      '$count Likes',
      name: 'likesText',
      desc: '',
      args: [count],
    );
  }

  /// `d`
  String get timeDay {
    return Intl.message('d', name: 'timeDay', desc: '', args: []);
  }

  /// `H`
  String get timeHour {
    return Intl.message('H', name: 'timeHour', desc: '', args: []);
  }

  /// `min.`
  String get timeMinute {
    return Intl.message('min.', name: 'timeMinute', desc: '', args: []);
  }

  /// `Select a category`
  String get selectCategoryFilter {
    return Intl.message(
      'Select a category',
      name: 'selectCategoryFilter',
      desc: '',
      args: [],
    );
  }

  /// `All categories`
  String get allCategoriesFilter {
    return Intl.message(
      'All categories',
      name: 'allCategoriesFilter',
      desc: '',
      args: [],
    );
  }

  /// `Select a subcategory`
  String get selectSubcategoryFilter {
    return Intl.message(
      'Select a subcategory',
      name: 'selectSubcategoryFilter',
      desc: '',
      args: [],
    );
  }

  /// `All subcategories`
  String get allSubcategoriesFilter {
    return Intl.message(
      'All subcategories',
      name: 'allSubcategoriesFilter',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
