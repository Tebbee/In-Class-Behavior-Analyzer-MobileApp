
///Description: The purpose of this class was to automatically update the demographics form with
///selections changed by the backend
///*This was not fully implemented and unused as of 4/1/19
///
///Location: DemographicForm
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