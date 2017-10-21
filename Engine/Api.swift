import Foundation
import ReactiveSwift
import RealmSwift

public final class Api {
   private let dataProvider: DataProvider
   private let cacheProvider: CacheProvider?

   init(dataProvider: DataProvider, cacheProvider: CacheProvider?) {
      precondition(realmDidConfigure)
      self.dataProvider = dataProvider
      self.cacheProvider = cacheProvider
   }

   public convenience init() {
      self.init(dataProvider: GoEuroProvider(), cacheProvider: NeverDieCache())
   }

   private func managedTravelOptions(for type: TransportType) -> SignalProducer<[ManagedTravelOption], ApiError> {
      if let options = cacheProvider?.travelOptions(for: type) {
         return SignalProducer(value: options)
      }

      return dataProvider
         .travelOptions(for: type)
         .on(value: { options in
            self.cacheProvider?.set(options, for: type)
         })
   }

   public func travelOptions(for type: TransportType) -> SignalProducer<[TravelOption], ApiError> {
      return managedTravelOptions(for: type).map { $0 as [TravelOption] }
   }
}

private let realmDidConfigure: Bool = {
   Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
   return true
}()
