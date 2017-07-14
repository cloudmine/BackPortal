import UIKit
import CareKit

enum AssessmentCellTapbackAction {
    case modify(OCKCarePlanActivity)
}

typealias AssessmentEventTapCallback = (AssessmentCellTapbackAction) -> Void

class AssessmentCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    @IBOutlet fileprivate var subLabel: UILabel?
    @IBOutlet fileprivate var valueLabel: UILabel?
    @IBOutlet fileprivate var unitLabel: UILabel?
    
    // MARK: Private Properties
    
    fileprivate var tapBack: AssessmentEventTapCallback? = nil
    fileprivate var event: OCKCarePlanEvent? = nil
    
    // MARK: Lifcycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(gesture:)))
        contentView.addGestureRecognizer(longPress)
    }
    
    // MARK: Public
    
    func configure(with eventList: [OCKCarePlanEvent], tapBack: AssessmentEventTapCallback?) {
        guard
            let event = eventList.first,
            case .assessment = event.activity.type
        else {
            return
        }
        
        self.event = event
        self.tapBack = tapBack
        
        onMain {
            self.layer.cornerRadius = ActivityCellCornerRadius
            self.layer.borderWidth = ActivityCellBorderWidth
            self.layer.borderColor = ActivityCellBorderColor.cgColor
            
            self.nameLabel?.text = event.activity.title
            self.subLabel?.text = event.activity.text
            self.valueLabel?.textColor = event.activity.tintColor
            self.valueLabel?.text = event.result?.valueString
            self.unitLabel?.text = event.result?.unitString
        }
    }
}

// MARK: Target-Action

fileprivate extension AssessmentCell {
    
    @objc func didLongPress(gesture: UILongPressGestureRecognizer) {
        guard let activity = event?.activity else {
            return
        }
        
        tapBack?(.modify(activity))
    }
}
