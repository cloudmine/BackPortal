import UIKit
import CMHealth

class PatientCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    @IBOutlet fileprivate var emailLabel: UILabel?
    @IBOutlet fileprivate var patientImage: UIImageView?
    
    // MARK: Private Properties
    
    private var configureCount: Int = 0
    
    // MARK: Public
    
    func configure(with patient: OCKPatient) {
        configureCount += 1
        let startCount = configureCount
        
        nameLabel?.text = patient.name
        emailLabel?.text = patient.detailInfo
        patientImage?.layer.cornerRadius = (patientImage?.bounds.width ?? 0.0) / 2.0
        
        PatientImageFetcher.shared.fetchImage(for: patient) { image in
            guard self.configureCount == startCount else {
                return
            }
        
            onMain {
                self.patientImage?.image = image
            }
        }
    }
}
