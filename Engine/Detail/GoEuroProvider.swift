import Foundation
import ReactiveSwift
import struct Result.AnyError
import SwiftyJSON
import RealmSwift

final class GoEuroProvider: DataProvider {
   private let apiUrl: URL
   private let session: URLSession
   private let decoder: JSONDecoder

   init(apiUrl: URL = URL(string: "https://api.myjson.com/bins")!,
        session: URLSession = URLSession.shared) {
      self.apiUrl = apiUrl
      self.session = session

      let decoder = JSONDecoder()
      let timeFormatter = DateFormatter()
      timeFormatter.locale = Locale(identifier: "en_US_POSIX")
      timeFormatter.dateFormat = "HH:mm"
      decoder.dateDecodingStrategy = .formatted(timeFormatter)

      self.decoder = decoder
   }

   func travelOptions(for type: TransportType) -> SignalProducer<[ManagedTravelOption], ApiError> {
      let url = apiUrl.appendingPathComponent(type.apiCommand)
      let request = URLRequest(url: url)

      return URLSession.shared
         .reactive
         .data(with: request)
         .flatMap(.latest) { data, _ -> SignalProducer<[ThreadSafeReference<ManagedTravelOption>], AnyError> in
            do {
              let options = try self.decoder.decode([ManagedTravelOption].self, from: data)
               let realm = try Realm()
               try realm.write {
                  realm.add(options, update: true)
               }
               return SignalProducer(value: options.map { ThreadSafeReference(to: $0) })
            } catch {
               return SignalProducer(error: AnyError(error))
            }
         }
         .mapError { _ in ApiError.internalError }
         .observe(on: UIScheduler())
         .map { references -> [ManagedTravelOption] in
            let realm = try! Realm()
            return references.flatMap { realm.resolve($0) }
      }
   }
}

private extension TransportType {
   var apiCommand: String {
      switch self {
      case .bus:
         return "37yzm"
      case .train:
         return "3zmcy"
      case .plane:
         return "w60i"
      }
   }
}
