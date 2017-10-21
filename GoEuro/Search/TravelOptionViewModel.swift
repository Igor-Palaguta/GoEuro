import Foundation
import Engine

final class TravelOptionViewModel {
   private let option: TravelOption

   var time: String {
      return "\(timeFormatter.string(from: option.departure)) - \(timeFormatter.string(from: option.arrival))"
   }

   var price: String {
      return "\(option.price) €"
   }

   var numberOfStops: String {
      let format = NSLocalizedString("stops_count_format", comment: "")
      return String(format: format, locale: .current, arguments: [option.numberOfStops])
   }

   var logoUrl: URL? {
      return option.logoUrl(for: .thumbnail)
   }

   var duration: String? {
      let duration = option.arrival.timeIntervalSince(option.departure)

      return durationFormatter.string(from: duration)
   }

   init(_ option: TravelOption) {
      self.option = option
   }
}

private let timeFormatter: DateFormatter = {
   let formatter = DateFormatter()
   formatter.timeStyle = .short
   formatter.dateStyle = .none
   return formatter
}()

private let durationFormatter: DateComponentsFormatter = {
   let formatter = DateComponentsFormatter()
   formatter.unitsStyle = .abbreviated
   formatter.allowedUnits = [.hour, .minute]
   return formatter
}()
