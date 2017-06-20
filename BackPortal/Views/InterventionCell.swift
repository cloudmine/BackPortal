import UIKit
import CareKit

class InterventionCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    @IBOutlet fileprivate var subLabel: UILabel?
    
    // MARK: Public
    
    func configure(with events: [OCKCarePlanEvent]) {
        guard let activity = events.first?.activity else {
            return
        }
        
        onMain {
            self.layer.cornerRadius = 6.0
            
            self.nameLabel?.text = activity.title
            self.subLabel?.text = activity.text
        }
    }
}
