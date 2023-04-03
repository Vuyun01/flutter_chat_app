class FireStoreHelper {
  //firebase const
  static const String collectionUsersPath = 'users';
  static const String collectionChatsPath = 'chats';
  static const String subCollectionChatsPath = 'messages';

//user const
  static const String userInfo = 'userInfo';
  static const String userId = 'userId';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String email = 'email';
  static const String password = 'password';
  static const String imageURL = 'imageURL';

//message const
  static const String idFrom = 'idFrom';
  static const String idTo = 'idTo';
  static const String content = 'content';
  static const String type = 'type';
  static const String createdAt = 'createdAt';

  //firebase storage const
  static const String user_images = 'user_images';
  static const String user_image_messages = 'user_image_messages';
}
