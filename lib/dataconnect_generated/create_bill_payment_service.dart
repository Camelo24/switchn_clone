part of 'generated.dart';

class CreateBillPaymentServiceVariablesBuilder {
  String serviceName;
  String providerName;
  String serviceType;
  Optional<String> _instructions = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _logoUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateBillPaymentServiceVariablesBuilder instructions(String? t) {
   _instructions.value = t;
   return this;
  }
  CreateBillPaymentServiceVariablesBuilder logoUrl(String? t) {
   _logoUrl.value = t;
   return this;
  }

  CreateBillPaymentServiceVariablesBuilder(this._dataConnect, {required  this.serviceName,required  this.providerName,required  this.serviceType,});
  Deserializer<CreateBillPaymentServiceData> dataDeserializer = (dynamic json)  => CreateBillPaymentServiceData.fromJson(jsonDecode(json));
  Serializer<CreateBillPaymentServiceVariables> varsSerializer = (CreateBillPaymentServiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateBillPaymentServiceData, CreateBillPaymentServiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateBillPaymentServiceData, CreateBillPaymentServiceVariables> ref() {
    CreateBillPaymentServiceVariables vars= CreateBillPaymentServiceVariables(serviceName: serviceName,providerName: providerName,serviceType: serviceType,instructions: _instructions,logoUrl: _logoUrl,);
    return _dataConnect.mutation("CreateBillPaymentService", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateBillPaymentServiceBillPaymentServiceInsert {
  final String id;
  CreateBillPaymentServiceBillPaymentServiceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBillPaymentServiceBillPaymentServiceInsert otherTyped = other as CreateBillPaymentServiceBillPaymentServiceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateBillPaymentServiceBillPaymentServiceInsert({
    required this.id,
  });
}

@immutable
class CreateBillPaymentServiceData {
  final CreateBillPaymentServiceBillPaymentServiceInsert billPaymentService_insert;
  CreateBillPaymentServiceData.fromJson(dynamic json):
  
  billPaymentService_insert = CreateBillPaymentServiceBillPaymentServiceInsert.fromJson(json['billPaymentService_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBillPaymentServiceData otherTyped = other as CreateBillPaymentServiceData;
    return billPaymentService_insert == otherTyped.billPaymentService_insert;
    
  }
  @override
  int get hashCode => billPaymentService_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['billPaymentService_insert'] = billPaymentService_insert.toJson();
    return json;
  }

  CreateBillPaymentServiceData({
    required this.billPaymentService_insert,
  });
}

@immutable
class CreateBillPaymentServiceVariables {
  final String serviceName;
  final String providerName;
  final String serviceType;
  late final Optional<String>instructions;
  late final Optional<String>logoUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateBillPaymentServiceVariables.fromJson(Map<String, dynamic> json):
  
  serviceName = nativeFromJson<String>(json['serviceName']),
  providerName = nativeFromJson<String>(json['providerName']),
  serviceType = nativeFromJson<String>(json['serviceType']) {
  
  
  
  
  
    instructions = Optional.optional(nativeFromJson, nativeToJson);
    instructions.value = json['instructions'] == null ? null : nativeFromJson<String>(json['instructions']);
  
  
    logoUrl = Optional.optional(nativeFromJson, nativeToJson);
    logoUrl.value = json['logoUrl'] == null ? null : nativeFromJson<String>(json['logoUrl']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateBillPaymentServiceVariables otherTyped = other as CreateBillPaymentServiceVariables;
    return serviceName == otherTyped.serviceName && 
    providerName == otherTyped.providerName && 
    serviceType == otherTyped.serviceType && 
    instructions == otherTyped.instructions && 
    logoUrl == otherTyped.logoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([serviceName.hashCode, providerName.hashCode, serviceType.hashCode, instructions.hashCode, logoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceName'] = nativeToJson<String>(serviceName);
    json['providerName'] = nativeToJson<String>(providerName);
    json['serviceType'] = nativeToJson<String>(serviceType);
    if(instructions.state == OptionalState.set) {
      json['instructions'] = instructions.toJson();
    }
    if(logoUrl.state == OptionalState.set) {
      json['logoUrl'] = logoUrl.toJson();
    }
    return json;
  }

  CreateBillPaymentServiceVariables({
    required this.serviceName,
    required this.providerName,
    required this.serviceType,
    required this.instructions,
    required this.logoUrl,
  });
}

