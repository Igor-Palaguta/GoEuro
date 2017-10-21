import Foundation
import RealmSwift

final class NeverDieCache: CacheProvider {
   func travelOptions(for type: TransportType) -> [ManagedTravelOption]? {
      let realm = try! Realm()
      guard let session = realm.objects(ManagedSession.self).first else {
         return nil
      }
      let list = session.options(for: type)
      if list.isEmpty {
         return nil
      }
      return Array(list)
   }

   func set(_ options: [ManagedTravelOption], for type: TransportType) {
      let realm = try! Realm()
      if let session = realm.objects(ManagedSession.self).first {
         let list = session.options(for: type)
         try! realm.write {
            list.removeAll()
            list.append(objectsIn: options)
         }
      } else {
         let session = ManagedSession()
         session.options(for: type).append(objectsIn: options)
         try! realm.write {
            realm.add(session)
         }
      }
   }
}
