import Foundation
import RealmSwift

final class NeverDieCache: CacheProvider {
   func travelOptions(for type: TransportType) -> [ManagedTravelOption]? {
      let realm = try! Realm()
      guard let list = realm.object(ofType: ManagedOptionsList.self, forPrimaryKey: type.rawValue) else {
         return nil
      }
      return Array(list.options)
   }

   func set(_ options: [ManagedTravelOption], for type: TransportType) {
      let realm = try! Realm()
      let list = ManagedOptionsList()
      list.id = type.rawValue
      list.options.append(objectsIn: options)

      try! realm.write {
         realm.add(list, update: true)
      }
   }
}
