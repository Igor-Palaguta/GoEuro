import Foundation
import RealmSwift

class ManagedSession: RealmSwift.Object {
   let busOptions = List<ManagedTravelOption>()
   let trainOptions = List<ManagedTravelOption>()
   let planeOptions = List<ManagedTravelOption>()

   func options(for type: TransportType) -> List<ManagedTravelOption> {
      switch type {
      case .bus:
         return self.busOptions
      case .train:
         return self.trainOptions
      case .plane:
         return self.planeOptions
      }
   }
}


