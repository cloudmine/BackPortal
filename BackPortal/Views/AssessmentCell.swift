import UIKit
import CareKit

typealias AssessmentEventTapCallback = (OCKCarePlanEvent) -> Void

class AssessmentCell: UICollectionViewCell {
    
    func configure(with eventList: [OCKCarePlanEvent], tapBack: AssessmentEventTapCallback?) {
        
        onMain {
            self.layer.cornerRadius = ActivityCellCornerRadius
        }
    }
}
