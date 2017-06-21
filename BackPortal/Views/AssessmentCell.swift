import UIKit
import CareKit

typealias AssessmentEventTapCallback = (OCKCarePlanEvent) -> Void

class AssessmentCell: UICollectionViewCell {
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    @IBOutlet fileprivate var subLabel: UILabel?
    @IBOutlet fileprivate var valueLabel: UILabel?
    @IBOutlet fileprivate var unitLabel: UILabel?
    
    func configure(with eventList: [OCKCarePlanEvent], tapBack: AssessmentEventTapCallback?) {
        guard let event = eventList.first else {
            return
        }
        
        onMain {
            self.layer.cornerRadius = ActivityCellCornerRadius
            
            self.nameLabel?.text = event.activity.title
            self.subLabel?.text = event.activity.text
            self.valueLabel?.textColor = event.activity.tintColor
            self.valueLabel?.text = event.result?.valueString
            self.unitLabel?.text = event.result?.unitString
        }
    }
}
