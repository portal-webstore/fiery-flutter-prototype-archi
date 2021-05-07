import 'dart:convert';

import 'patient_ocs_link.dart';

class Patient {
  final String patientIdentifier;
  final String lastName;
  final String firstName;
  final String birthDate;
  final PatientOcsLink patientOcsLink;
  Patient({
    required this.patientIdentifier,
    required this.lastName,
    required this.firstName,
    required this.birthDate,
    required this.patientOcsLink,
  });

  Patient copyWith({
    String? patientIdentifier,
    String? lastName,
    String? firstName,
    String? birthDate,
    PatientOcsLink? patientOcsLink,
  }) {
    return Patient(
      patientIdentifier: patientIdentifier ?? this.patientIdentifier,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      birthDate: birthDate ?? this.birthDate,
      patientOcsLink: patientOcsLink ?? this.patientOcsLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientIdentifier': patientIdentifier,
      'lastName': lastName,
      'firstName': firstName,
      'birthDate': birthDate,
      'patientOcsLink': patientOcsLink.toMap(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      patientIdentifier: map['patientIdentifier'],
      lastName: map['lastName'],
      firstName: map['firstName'],
      birthDate: map['birthDate'],
      patientOcsLink: PatientOcsLink.fromMap(map['patientOcsLink']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) => Patient.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Patient(patientIdentifier: $patientIdentifier, lastName: $lastName, firstName: $firstName, birthDate: $birthDate, patientOcsLink: $patientOcsLink)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Patient &&
      other.patientIdentifier == patientIdentifier &&
      other.lastName == lastName &&
      other.firstName == firstName &&
      other.birthDate == birthDate &&
      other.patientOcsLink == patientOcsLink;
  }

  @override
  int get hashCode {
    return patientIdentifier.hashCode ^
      lastName.hashCode ^
      firstName.hashCode ^
      birthDate.hashCode ^
      patientOcsLink.hashCode;
  }
}