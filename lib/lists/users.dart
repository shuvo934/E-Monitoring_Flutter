class Users {
  final int _id;
  final String _name;
  final String _email;

  Users(this._id, this._name, this._email);

  String get email => _email;

  String get name => _name;

  int get id => _id;
}
