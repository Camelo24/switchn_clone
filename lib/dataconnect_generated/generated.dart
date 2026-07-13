library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'list_all_operators.dart';

part 'get_user_accounts.dart';

part 'create_bill_payment_service.dart';

part 'record_new_transaction.dart';







class ExampleConnector {
  
  
  ListAllOperatorsVariablesBuilder listAllOperators () {
    return ListAllOperatorsVariablesBuilder(dataConnect, );
  }
  
  
  GetUserAccountsVariablesBuilder getUserAccounts () {
    return GetUserAccountsVariablesBuilder(dataConnect, );
  }
  
  
  CreateBillPaymentServiceVariablesBuilder createBillPaymentService ({required String serviceName, required String providerName, required String serviceType, }) {
    return CreateBillPaymentServiceVariablesBuilder(dataConnect, serviceName: serviceName,providerName: providerName,serviceType: serviceType,);
  }
  
  
  RecordNewTransactionVariablesBuilder recordNewTransaction ({required String senderAccountId, required double amount, required String currency, required String transactionType, required String status, }) {
    return RecordNewTransactionVariablesBuilder(dataConnect, senderAccountId: senderAccountId,amount: amount,currency: currency,transactionType: transactionType,status: status,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'switchnclone',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:0),
      storage: CacheStorage.persistent,
    );
    
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
