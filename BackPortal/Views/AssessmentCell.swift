import UIKit
import CareKit

typealias AssessmentEventTapCallback = (OCKCarePlanEvent) -> Void

class AssessmentCell: UICollectionViewCell {
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    @IBOutlet fileprivate var subLabel: UILabel?
    
    func configure(with eventList: [OCKCarePlanEvent], tapBack: AssessmentEventTapCallback?) {
        guard let activity = eventList.first?.activity else {
            return
        }
        
        onMain {
            self.layer.cornerRadius = ActivityCellCornerRadius
            
            self.nameLabel?.text = activity.title
            self.subLabel?.text = activity.text
        }
    }
}
