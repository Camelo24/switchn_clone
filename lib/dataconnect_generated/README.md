# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ListAllOperators
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listAllOperators().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListAllOperatorsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listAllOperators();
ListAllOperatorsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listAllOperators().ref();
ref.execute();

ref.subscribe(...);
```


### GetUserAccounts
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getUserAccounts().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserAccountsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getUserAccounts();
GetUserAccountsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getUserAccounts().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateBillPaymentService
#### Required Arguments
```dart
String serviceName = ...;
String providerName = ...;
String serviceType = ...;
ExampleConnector.instance.createBillPaymentService(
  serviceName: serviceName,
  providerName: providerName,
  serviceType: serviceType,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateBillPaymentService, we created `CreateBillPaymentServiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateBillPaymentServiceVariablesBuilder {
  ...
   CreateBillPaymentServiceVariablesBuilder instructions(String? t) {
   _instructions.value = t;
   return this;
  }
  CreateBillPaymentServiceVariablesBuilder logoUrl(String? t) {
   _logoUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createBillPaymentService(
  serviceName: serviceName,
  providerName: providerName,
  serviceType: serviceType,
)
.instructions(instructions)
.logoUrl(logoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateBillPaymentServiceData, CreateBillPaymentServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createBillPaymentService(
  serviceName: serviceName,
  providerName: providerName,
  serviceType: serviceType,
);
CreateBillPaymentServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String serviceName = ...;
String providerName = ...;
String serviceType = ...;

final ref = ExampleConnector.instance.createBillPaymentService(
  serviceName: serviceName,
  providerName: providerName,
  serviceType: serviceType,
).ref();
ref.execute();
```


### RecordNewTransaction
#### Required Arguments
```dart
String senderAccountId = ...;
double amount = ...;
String currency = ...;
String transactionType = ...;
String status = ...;
ExampleConnector.instance.recordNewTransaction(
  senderAccountId: senderAccountId,
  amount: amount,
  currency: currency,
  transactionType: transactionType,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For RecordNewTransaction, we created `RecordNewTransactionBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class RecordNewTransactionVariablesBuilder {
  ...
   RecordNewTransactionVariablesBuilder receiverAccountId(String? t) {
   _receiverAccountId.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.recordNewTransaction(
  senderAccountId: senderAccountId,
  amount: amount,
  currency: currency,
  transactionType: transactionType,
  status: status,
)
.receiverAccountId(receiverAccountId)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<RecordNewTransactionData, RecordNewTransactionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.recordNewTransaction(
  senderAccountId: senderAccountId,
  amount: amount,
  currency: currency,
  transactionType: transactionType,
  status: status,
);
RecordNewTransactionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String senderAccountId = ...;
double amount = ...;
String currency = ...;
String transactionType = ...;
String status = ...;

final ref = ExampleConnector.instance.recordNewTransaction(
  senderAccountId: senderAccountId,
  amount: amount,
  currency: currency,
  transactionType: transactionType,
  status: status,
).ref();
ref.execute();
```

