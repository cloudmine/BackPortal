import UIKit

enum ActivitySubtype {
    case exercise
    case medication
}

enum ActivitiesHeaderType: Int {
    case intervention = 0
    case assessment = 1
}

protocol ActivitiesHeaderDelegate: class {
    func activitiesHeader(_ activitiesHeader: ActivitiesHeader, wantsToShowPopover viewController: UIViewController, from view: UIView)
    func activitiesHeader(_ activitiesHeader: ActivitiesHeader, didSelectAddFor subtype: ActivitySubtype)
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
            addButton?.isHidden = false
        }
    }
}


// MARK: Target-Action

extension ActivitiesHeader {
    
    @IBAction func didPress(addButton: UIButton) {
        guard
            let type = type,
            case .intervention = type, // TODO: Implement assessment case
            let selectVC = UIStoryboard(name: "InterventionType", bundle: Bundle.main).instantiateInitialViewController() as? InterventionTypeViewController
        else {
            return
        }
        
        selectVC.selectionCallback = { subtype in
            self.delegate?.activitiesHeader(self, didSelectAddFor: subtype)
        }
        
        delegate?.activitiesHeader(self, wantsToShowPopover: selectVC, from: addButton)
    }
}
