import UIKit

class PatientDetailViewController: UIViewController {

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello Patient Detail")
        
        navigationItem.leftBarButtonItem = parent?.splitViewController?.displayModeButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let patientName = patientSplitViewController?.patientListViewController?.selectedPatient?.name {
            navigationItem.title = patientName
        } else {
            navigationItem.title = "Patient"
        }
    }
}
