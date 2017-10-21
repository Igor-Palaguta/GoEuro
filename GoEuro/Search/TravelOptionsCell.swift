import UIKit
import Reusable
import Kingfisher

final class TravelOptionCell: UITableViewCell, Reusable {
   @IBOutlet private weak var priceLabel: UILabel!
   @IBOutlet private weak var timeLabel: UILabel!
   @IBOutlet private weak var stopsLabel: UILabel!
   @IBOutlet private weak var durationLabel: UILabel!
   @IBOutlet private weak var logoView: UIImageView!

   var viewModel: TravelOptionViewModel! {
      didSet {
         logoView.kf.setImage(with: viewModel.logoUrl.map { ImageResource(downloadURL: $0) },
                              options: [.transition(.fade(0.3))])
         priceLabel.text = viewModel.price
         timeLabel.text = viewModel.time
         stopsLabel.text = viewModel.numberOfStops
         durationLabel.text = viewModel.duration
      }
   }
}
