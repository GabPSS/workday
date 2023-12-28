import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class User {
  String email;
  String name;

  User({required this.email, required this.name});

  String get firstName => name.split(" ").first;

  static List<User> parseUsersList(supabase.PostgrestList source) {
    return source.map((e) {
      var name = e['name'] as String;
      var email = e['email'] as String;
      return User(email: email, name: name);
    }).toList();
  }
}
