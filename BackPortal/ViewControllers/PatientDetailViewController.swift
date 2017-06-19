import UIKit

class PatientDetailViewController: UIViewController {

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello Patient Detail")
        
        navigationItem.leftBarButtonItem = parent?.splitViewController?.displayModeButtonItem
    }
}
