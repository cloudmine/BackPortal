import UIKit

class PatientSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello Patient Split")

    }
}

extension PatientSplitViewController {
    
    var patientListViewController: PatientListViewController? {
        return childViewControllers
                .flatMap({ $0 as? PatientMasterNavController })
                .first?
                .viewControllers
                .flatMap({ $0 as? PatientListViewController })
                .first
    }
}
