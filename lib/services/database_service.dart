import 'package:ig/models/user_models.dart';
import 'package:ig/utilities/constants.dart';

class DatabaseService {

  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

}