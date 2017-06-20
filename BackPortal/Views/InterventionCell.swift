import UIKit
import CareKit

class InterventionCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    
    // MARK: Public
    
    func configure(with events: [OCKCarePlanEvent]) {
        guard let activity = events.first?.activity else {
            return
        }
        
        onMain {
            self.nameLabel?.text = activity.title
        }
    }
}
