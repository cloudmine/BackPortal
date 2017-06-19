import UIKit

extension UIViewController {
    
    var patientSplitViewController: PatientSplitViewController? {
        guard let myParent = parent else {
            return nil
        }
        
        if let split = myParent as? PatientSplitViewController {
            return split
        } else {
            return myParent.patientSplitViewController
        }
    }
}
