# Modular MVVM SwiftUI coding challenge

## Description
- language: Swift
- architecture: Modular MVVM + Combine
- UI: SwiftUI
- feature flags
- localization & internalization (currently suppotts 'en' and 'de')
- pull-to-refresh for transaction list
- concurrency & reactivity: async / await; Combine
- zero external dependencies

## User stories
- User Story 1. As a user of the App, I want to see a list of (mocked) transactions. Each item in the list displays `bookingDate`, `partnerDisplayName`, `transactionDetail.description`, `value.amount` and `value.currency`. *(PBTransactions.json)*
- User Story 2. As a user of the App, I want to have the list of transactions sorted by `bookingDate` from newest (top) to oldest (bottom).
- User Story 3. As a user of the App, I want to get feedback when loading of the transactions is ongoing or an Error occurs. *(Just delay the mocked server response for 1-2 seconds and randomly fail it)*
- User Story 4. As a user of the App, I want to see an error if the device is offline.
- User Story 5. As a user of the App, I want to filter the list of transactions by `category`.
- User Story 6. As a user of the App, I want to see the sum of filtered transactions somewhere on the Transaction-list view. *(Sum of `value.amount`)*
- User Story 7. As a user of the App, I want to select a transaction and navigate to its details. The details-view should just display `partnerDisplayName` and `transactionDetail.description`.
- User Story 8. As a user of the App, I like to see nice UI in general. However, for this coding challenge fancy UI is not required.

## Implementation details

The project modules are implemented as swift packages. For the sake of simplicity, these modules are included in the project as local modules. But in the future, each module should be implemented as a separate git repository. This will allow to share responsibility - a separate developer or team will be able to work on each module.

- **PaybackCommon** - all common dependencies. This includes the following components:
	- namespaces
	- constants
	- brand colors definition
	- banner view
	- localizable strings
	- services: network (generic and model-agnostic / endpoints), reachability and translation
	- unit-tests
- **PaybackTransaction** - represent 'Transaction' feature and includes following components:
	- codable models
	- transactions endpoint
	- service protocol, implementation and mock
	- view model (UI-agnostic): protocol and implementation
	- views: list and details
	- unit-tests
- **Tabbar** - represent tabbar UI component as a separate feature
- **PaybackFeed** - placeholder for the 'Feed' feature
- **PaybackOnlineShopping** - placeholder for the 'Online Shopping' feature
- **PaybackSettings** - placeholder for the 'Settings' feature

## Network service
The Network service supports two environments: prod and test. This is described in the PaybackCommon module: URLHost.swift. Actual values for the base url are specified in the Constants.swift file. In this way, the service supports:
	- Production Environment: "GET https://api.payback.com/transactions"
	- Test Environment: "GET https://api-test.payback.com/transactions"
