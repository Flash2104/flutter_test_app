import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class WorkerData extends Equatable {
  late String id;
  late String name;
  late String familyname;
  late String? surname;
  late String email;
  late DateTime? birthDate;
  late String? note;

  WorkerData({
    required this.id,
    required this.name,
    required this.familyname,
    this.surname,
    required this.email,
    required this.birthDate,
    this.note,
  });

  WorkerData.empty()
      : id = '',
        birthDate = null,
        email = '',
        familyname = '',
        name = '',
        note = '',
        surname = '';

  WorkerData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    familyname = json['familyname'] as String;
    surname = json['surname'] as String?;
    email = json['email'] as String;
    birthDate = json['birthDateMs'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['birthDateMs']).toLocal();
    note = json['note'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'familyname': familyname,
        'surname': surname,
        'email': email,
        'birthDateMs': birthDate?.millisecondsSinceEpoch,
        'note': note,
        'id': id,
        'name': name,
      };

  WorkerData copyWith({
    String? name,
    String? familyname,
    String? surname,
    String? email,
    DateTime? birthDate,
    String? note,
  }) {
    return WorkerData(
      id: id,
      name: name ?? this.name,
      familyname: familyname ?? this.familyname,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
        familyname,
        name,
        surname,
        email,
        birthDate,
        note,
        id,
      ];
}
