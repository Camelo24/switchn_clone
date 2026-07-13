part of 'generated.dart';

class RecordNewTransactionVariablesBuilder {
  String senderAccountId;
  double amount;
  String currency;
  String transactionType;
  String status;
  Optional<String> _receiverAccountId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  RecordNewTransactionVariablesBuilder receiverAccountId(String? t) {
   _receiverAccountId.value = t;
   return this;
  }

  RecordNewTransactionVariablesBuilder(this._dataConnect, {required  this.senderAccountId,required  this.amount,required  this.currency,required  this.transactionType,required  this.status,});
  Deserializer<RecordNewTransactionData> dataDeserializer = (dynamic json)  => RecordNewTransactionData.fromJson(jsonDecode(json));
  Serializer<RecordNewTransactionVariables> varsSerializer = (RecordNewTransactionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RecordNewTransactionData, RecordNewTransactionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RecordNewTransactionData, RecordNewTransactionVariables> ref() {
    RecordNewTransactionVariables vars= RecordNewTransactionVariables(senderAccountId: senderAccountId,amount: amount,currency: currency,transactionType: transactionType,status: status,receiverAccountId: _receiverAccountId,);
    return _dataConnect.mutation("RecordNewTransaction", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RecordNewTransactionTransactionInsert {
  final String id;
  RecordNewTransactionTransactionInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordNewTransactionTransactionInsert otherTyped = other as RecordNewTransactionTransactionInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RecordNewTransactionTransactionInsert({
    required this.id,
  });
}

@immutable
class RecordNewTransactionData {
  final RecordNewTransactionTransactionInsert transaction_insert;
  RecordNewTransactionData.fromJson(dynamic json):
  
  transaction_insert = RecordNewTransactionTransactionInsert.fromJson(json['transaction_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordNewTransactionData otherTyped = other as RecordNewTransactionData;
    return transaction_insert == otherTyped.transaction_insert;
    
  }
  @override
  int get hashCode => transaction_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['transaction_insert'] = transaction_insert.toJson();
    return json;
  }

  RecordNewTransactionData({
    required this.transaction_insert,
  });
}

@immutable
class RecordNewTransactionVariables {
  final String senderAccountId;
  final double amount;
  final String currency;
  final String transactionType;
  final String status;
  late final Optional<String>receiverAccountId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RecordNewTransactionVariables.fromJson(Map<String, dynamic> json):
  
  senderAccountId = nativeFromJson<String>(json['senderAccountId']),
  amount = nativeFromJson<double>(json['amount']),
  currency = nativeFromJson<String>(json['currency']),
  transactionType = nativeFromJson<String>(json['transactionType']),
  status = nativeFromJson<String>(json['status']) {
  
  
  
  
  
  
  
    receiverAccountId = Optional.optional(nativeFromJson, nativeToJson);
    receiverAccountId.value = json['receiverAccountId'] == null ? null : nativeFromJson<String>(json['receiverAccountId']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordNewTransactionVariables otherTyped = other as RecordNewTransactionVariables;
    return senderAccountId == otherTyped.senderAccountId && 
    amount == otherTyped.amount && 
    currency == otherTyped.currency && 
    transactionType == otherTyped.transactionType && 
    status == otherTyped.status && 
    receiverAccountId == otherTyped.receiverAccountId;
    
  }
  @override
  int get hashCode => Object.hashAll([senderAccountId.hashCode, amount.hashCode, currency.hashCode, transactionType.hashCode, status.hashCode, receiverAccountId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['senderAccountId'] = nativeToJson<String>(senderAccountId);
    json['amount'] = nativeToJson<double>(amount);
    json['currency'] = nativeToJson<String>(currency);
    json['transactionType'] = nativeToJson<String>(transactionType);
    json['status'] = nativeToJson<String>(status);
    if(receiverAccountId.state == OptionalState.set) {
      json['receiverAccountId'] = receiverAccountId.toJson();
    }
    return json;
  }

  RecordNewTransactionVariables({
    required this.senderAccountId,
    required this.amount,
    required this.currency,
    required this.transactionType,
    required this.status,
    required this.receiverAccountId,
  });
}

