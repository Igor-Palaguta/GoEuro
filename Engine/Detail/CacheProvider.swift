protocol CacheProvider {
   func travelOptions(for type: TransportType) -> [ManagedTravelOption]?
   func set(_ options: [ManagedTravelOption], for type: TransportType)
}
