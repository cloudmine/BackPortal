import UIKit

enum ActivitiesHeaderType: Int {
    case intervention = 0
    case assessment = 1
}

protocol ActivitiesHeaderDelegate: class {
    func activitiesHeader(_ activitiesHeader: ActivitiesHeader, didSelectAddFor type: ActivitiesHeaderType)
}


class ActivitiesHeader: UICollectionReusableView {
    
    // MARK: Private Properties
    
    fileprivate var type: ActivitiesHeaderType? = nil
    fileprivate weak var delegate: ActivitiesHeaderDelegate? = nil
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var titleLabel: UILabel?
    @IBOutlet fileprivate var addButton: UIButton?
    
    // MARK: Public
    
    func configure(as type: ActivitiesHeaderType, delegate: ActivitiesHeaderDelegate) {
        self.type = type
        self.delegate = delegate
        
        if case .intervention = type {
            titleLabel?.text = NSLocalizedString("Interventions", comment: "")
            addButton?.isHidden = false
        } else if case .assessment = type {
            titleLabel?.text = NSLocalizedString("Assessments", comment: "")
            addButton?.isHidden = true
        }
    }
}


// MARK: Target-Action

extension ActivitiesHeader {
    
    @IBAction func didPress(addButton: UIButton) {
        guard let type = type else {
            return
        }
        
        delegate?.activitiesHeader(self, didSelectAddFor: type)
    }
}
