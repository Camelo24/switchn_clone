part of 'generated.dart';

class ListAllOperatorsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListAllOperatorsVariablesBuilder(this._dataConnect, );
  Deserializer<ListAllOperatorsData> dataDeserializer = (dynamic json)  => ListAllOperatorsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListAllOperatorsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListAllOperatorsData, void> ref() {
    
    return _dataConnect.query("ListAllOperators", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListAllOperatorsOperators {
  final String id;
  final String name;
  final String code;
  final String country;
  final String? logoUrl;
  ListAllOperatorsOperators.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  code = nativeFromJson<String>(json['code']),
  country = nativeFromJson<String>(json['country']),
  logoUrl = json['logoUrl'] == null ? null : nativeFromJson<String>(json['logoUrl']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAllOperatorsOperators otherTyped = other as ListAllOperatorsOperators;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    code == otherTyped.code && 
    country == otherTyped.country && 
    logoUrl == otherTyped.logoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, code.hashCode, country.hashCode, logoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['code'] = nativeToJson<String>(code);
    json['country'] = nativeToJson<String>(country);
    if (logoUrl != null) {
      json['logoUrl'] = nativeToJson<String?>(logoUrl);
    }
    return json;
  }

  ListAllOperatorsOperators({
    required this.id,
    required this.name,
    required this.code,
    required this.country,
    this.logoUrl,
  });
}

@immutable
class ListAllOperatorsData {
  final List<ListAllOperatorsOperators> operators;
  ListAllOperatorsData.fromJson(dynamic json):
  
  operators = (json['operators'] as List<dynamic>)
        .map((e) => ListAllOperatorsOperators.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAllOperatorsData otherTyped = other as ListAllOperatorsData;
    return operators == otherTyped.operators;
    
  }
  @override
  int get hashCode => operators.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['operators'] = operators.map((e) => e.toJson()).toList();
    return json;
  }

  ListAllOperatorsData({
    required this.operators,
  });
}

