import Foundation
import RealmSwift

final class ManagedOptionsList: RealmSwift.Object {
   @objc dynamic var id = 0
   let options = List<ManagedTravelOption>()

   override static func primaryKey() -> String? {
      return "id"
   }
}
