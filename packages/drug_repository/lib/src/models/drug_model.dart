import 'dart:convert' show jsonDecode, jsonEncode;

/// {@template drug_model}
/// Drug name units model ported from ocs scrape.
/// {@endtemplate}
class Drug {
  const Drug({
    required this.drugName,
    required this.drugUnitsOfMeasurement,
    required this.ocsDrugLink,
  });

  factory Drug.fromMap(Map<String, dynamic> map) {
    return Drug(
      drugName: map['drugName'] as String,
      drugUnitsOfMeasurement: map['drugUnitsOfMeasurement'] as String,
      ocsDrugLink: map['ocsDrugLink'] as int,
    );
  }

  factory Drug.fromJson(String source) => Drug.fromMap(
        jsonDecode(source) as Map<String, dynamic>,
      );

  final String drugName;
  final String drugUnitsOfMeasurement;

  /// ocsDrugLink is only optional for us reusing this model in ad-hoc product
  ///
  /// otherwise it will always be directly taken from OCS scrape query to always
  /// have an OCS drug ID.
  ///
  final int ocsDrugLink;

  Drug copyWith({
    String? drugName,
    String? drugUnitsOfMeasurement,
    int? ocsDrugLink,
  }) {
    return Drug(
      drugName: drugName ?? this.drugName,
      drugUnitsOfMeasurement:
          drugUnitsOfMeasurement ?? this.drugUnitsOfMeasurement,
      ocsDrugLink: ocsDrugLink ?? this.ocsDrugLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'drugName': drugName,
      'drugUnitsOfMeasurement': drugUnitsOfMeasurement,
      'ocsDrugLink': ocsDrugLink,
    };
  }

  String toJson() => jsonEncode(toMap());

  @override
  String toString() =>
      'Drug(drugName: $drugName, drugUnitsOfMeasurement: $drugUnitsOfMeasurement, ocsDrugLink: $ocsDrugLink)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Drug &&
        other.drugName == drugName &&
        other.drugUnitsOfMeasurement == drugUnitsOfMeasurement &&
        other.ocsDrugLink == ocsDrugLink;
  }

  @override
  int get hashCode =>
      drugName.hashCode ^
      drugUnitsOfMeasurement.hashCode ^
      ocsDrugLink.hashCode;
}
