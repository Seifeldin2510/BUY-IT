import 'package:ecommerce/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService{
  static List<User> users = [];

  void addUsers(User user)
  {
    if(findUser(user.email)==-1)
      {
        users.add(user);
      }
  }


  int findUser(String email)
  {
    for(int i = 0 ; i<users.length;i++)
      {
        if(users[i].email==email)
          {
            return i;
          }
      }
    return -1;
  }

}