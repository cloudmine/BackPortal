import UIKit

class PatientDetailNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello Patient Detail Nav")
        
        navigationItem.leftItemsSupplementBackButton = true
    }
}
