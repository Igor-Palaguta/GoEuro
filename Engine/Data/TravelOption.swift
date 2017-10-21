import Foundation

public enum LogoSize: Int {
   case thumbnail = 63
}

public protocol TravelOption {
   var price: String { get }
   var departure: Date { get }
   var arrival: Date { get }
   var numberOfStops: Int { get }

   func logoUrl(for size: LogoSize) -> URL?
}
