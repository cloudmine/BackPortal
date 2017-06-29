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
            case .intervention = type // TODO: Implement assessment case
        else {
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Intervention Type", comment: ""),
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.view?.tintColor = UIColor.portalBlue
        
        let exercise = UIAlertAction(title: NSLocalizedString("Exercise", comment: ""), style: .default) { _ in
            self.delegate?.activitiesHeader(self, didSelectAddFor: .exercise)
        }
        
        let medication = UIAlertAction(title: NSLocalizedString("Medication", comment: ""), style: .default) { _ in
            self.delegate?.activitiesHeader(self, didSelectAddFor: .medication)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(exercise)
        alert.addAction(medication)
        alert.addAction(cancel)
                
        delegate?.activitiesHeader(self, wantsToShowPopover: alert, from: addButton)
    }
}
