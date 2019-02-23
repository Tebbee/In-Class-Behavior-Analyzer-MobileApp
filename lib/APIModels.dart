class ModelLookup {
  int _id;
  String _name;

  int get id => _id;
  String get name => _name;

  ModelLookup(int id, String name) {
    this._id = id;
    this._name = name;
  }
}

class GenderLookup extends ModelLookup {
  GenderLookup(int id, String name) : super(id, name);
}

class GradeYearLookup extends ModelLookup {
  GradeYearLookup(int id, String name) : super(id, name);
}

class RaceLookup extends ModelLookup {
  RaceLookup(int id, String name) : super(id, name);
}

class EthnicityLookup extends ModelLookup {
  EthnicityLookup(int id, String name) : super(id, name);
}