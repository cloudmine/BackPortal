import UIKit

enum ActivitiesHeaderType: Int {
    case intervention = 0
    case assessment = 1
}

class ActivitiesHeader: UICollectionReusableView {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var titleLabel: UILabel?
    @IBOutlet fileprivate var addButton: UIButton?
    
    // MARK: Public
    
    func configure(as type: ActivitiesHeaderType) {
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
        print("[PORTAL] Add Interventions")
    }
}
