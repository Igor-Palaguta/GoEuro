import ReactiveSwift

protocol DataProvider {
   func travelOptions(for type: TransportType) -> SignalProducer<[ManagedTravelOption], ApiError>
}
