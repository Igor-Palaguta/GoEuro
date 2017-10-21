import UIKit
import Engine
import ReactiveSwift
import ReactiveCocoa
import Reusable

final class SearchOptionViewController: UIViewController {

   @IBOutlet private weak var typeControl: UISegmentedControl!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet private weak var loadingView: UIActivityIndicatorView!
   @IBOutlet private weak var errorLabel: UILabel!

   private let viewModel = SearchOptionViewModel(api: Api())

   override func viewDidLoad() {
      super.viewDidLoad()

      viewModel.type <~
         typeControl
            .reactive
            .selectedSegmentIndexes
            .map { TransportType(rawValue: $0)! }

      errorLabel.reactive.isHidden <~ viewModel.state.producer.map { state in
         guard case .failed = state else {
            return true
         }
         return false
      }

      loadingView.reactive.isAnimating <~ viewModel.isLoading

      tableView.reactive.isHidden <~ viewModel.state.producer.map { state in
         guard case .options = state else {
            return true
         }
         return false
      }

      tableView.reactive.reloadData <~
         viewModel.options.producer.map { _ in () }
   }
}

extension SearchOptionViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.options.value.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell: TravelOptionCell = tableView.dequeueReusableCell(for: indexPath)
      cell.viewModel = viewModel.optionViewModel(at: indexPath.row)
      return cell
   }
}
