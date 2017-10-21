import Foundation
import RealmSwift

final class ManagedTravelOption: RealmSwift.Object, Decodable {
   @objc dynamic var id = 0
   @objc dynamic var numberOfStops = 0
   @objc dynamic var logoUrlFormat = ""
   @objc dynamic var price = ""
   @objc dynamic var departure = Date()
   @objc dynamic var arrival = Date()

   private enum CodingKeys: String, CodingKey {
      case id  = "id"
      case numberOfStops = "number_of_stops"
      case logoUrlFormat = "provider_logo"
      case price = "price_in_euros"
      case departure = "departure_time"
      case arrival = "arrival_time"
   }

   required convenience init(from decoder: Decoder) throws {
      self.init()
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decode(Int.self, forKey: .id)
      numberOfStops = try container.decode(Int.self, forKey: .numberOfStops)
      logoUrlFormat = try container.decode(String.self, forKey: .logoUrlFormat)
      if let floatPrice = try? container.decode(Float.self, forKey: .price) {
         price = String(describing: floatPrice)
      } else {
         price = try container.decode(String.self, forKey: .price)
      }
      departure = try container.decode(Date.self, forKey: .departure)
      arrival = try container.decode(Date.self, forKey: .arrival)
   }
}

extension ManagedTravelOption: TravelOption {
   func logoUrl(for size: LogoSize) -> URL? {
      let urlString = self.logoUrlFormat.replacingOccurrences(of: "{size}", with: "\(size.rawValue)")
      return URL(string: urlString)
   }
}
