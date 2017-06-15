import UIKit
import CMHealth

class PatientCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    @IBOutlet fileprivate var emailLabel: UILabel?
    
    // MARK: Public
    
    func configure(with patient: OCKPatient) {
        nameLabel?.text = patient.name
        emailLabel?.text = patient.detailInfo
    }
}
