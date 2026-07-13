part of 'generated.dart';

class GetUserAccountsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetUserAccountsVariablesBuilder(this._dataConnect, );
  Deserializer<GetUserAccountsData> dataDeserializer = (dynamic json)  => GetUserAccountsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetUserAccountsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetUserAccountsData, void> ref() {
    
    return _dataConnect.query("GetUserAccounts", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetUserAccountsAccounts {
  final String id;
  final String accountName;
  final String accountNumber;
  final String accountType;
  final double balance;
  final GetUserAccountsAccountsOperator operator;
  GetUserAccountsAccounts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  accountName = nativeFromJson<String>(json['accountName']),
  accountNumber = nativeFromJson<String>(json['accountNumber']),
  accountType = nativeFromJson<String>(json['accountType']),
  balance = nativeFromJson<double>(json['balance']),
  operator = GetUserAccountsAccountsOperator.fromJson(json['operator']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserAccountsAccounts otherTyped = other as GetUserAccountsAccounts;
    return id == otherTyped.id && 
    accountName == otherTyped.accountName && 
    accountNumber == otherTyped.accountNumber && 
    accountType == otherTyped.accountType && 
    balance == otherTyped.balance && 
    operator == otherTyped.operator;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, accountName.hashCode, accountNumber.hashCode, accountType.hashCode, balance.hashCode, operator.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['accountName'] = nativeToJson<String>(accountName);
    json['accountNumber'] = nativeToJson<String>(accountNumber);
    json['accountType'] = nativeToJson<String>(accountType);
    json['balance'] = nativeToJson<double>(balance);
    json['operator'] = operator.toJson();
    return json;
  }

  GetUserAccountsAccounts({
    required this.id,
    required this.accountName,
    required this.accountNumber,
    required this.accountType,
    required this.balance,
    required this.operator,
  });
}

@immutable
class GetUserAccountsAccountsOperator {
  final String name;
  final String code;
  GetUserAccountsAccountsOperator.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']),
  code = nativeFromJson<String>(json['code']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserAccountsAccountsOperator otherTyped = other as GetUserAccountsAccountsOperator;
    return name == otherTyped.name && 
    code == otherTyped.code;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, code.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['code'] = nativeToJson<String>(code);
    return json;
  }

  GetUserAccountsAccountsOperator({
    required this.name,
    required this.code,
  });
}

@immutable
class GetUserAccountsData {
  final List<GetUserAccountsAccounts> accounts;
  GetUserAccountsData.fromJson(dynamic json):
  
  accounts = (json['accounts'] as List<dynamic>)
        .map((e) => GetUserAccountsAccounts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserAccountsData otherTyped = other as GetUserAccountsData;
    return accounts == otherTyped.accounts;
    
  }
  @override
  int get hashCode => accounts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['accounts'] = accounts.map((e) => e.toJson()).toList();
    return json;
  }

  GetUserAccountsData({
    required this.accounts,
  });
}

