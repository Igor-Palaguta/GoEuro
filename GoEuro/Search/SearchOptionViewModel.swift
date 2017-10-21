import Foundation
import ReactiveSwift
import Engine
import struct Result.AnyError
import enum Result.NoError

final class SearchOptionViewModel {
   let type = MutableProperty<TransportType>(.bus)

   enum State {
      case loading
      case options([TravelOption])
      case failed
   }

   let state: Property<State>
   let options: Property<[TravelOption]>
   let isLoading: Property<Bool>

   init(api: Api) {
      self.state = self.type.flatMap(.latest) { type -> Property<State> in
         let loader: SignalProducer<State, NoError> = api.travelOptions(for: type)
            .map { .options($0) }
            .flatMapError { _ in SignalProducer<State, NoError>(value: .failed) }

         return Property(
            initial: .loading,
            then: loader
         )
      }

      self.options = self.state.map { state in
         switch state {
         case .loading, .failed:
            return []
         case .options(let options):
            return options
         }
      }

      self.isLoading = self.state.map { state in
         switch state {
         case .loading:
            return true
         default:
            return false
         }
      }
   }

   func optionViewModel(at index: Int) -> TravelOptionViewModel {
      return TravelOptionViewModel(self.options.value[index])
   }
}
