import UIKit

class NoSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello No Selection")
        
        splitViewController?.preferredDisplayMode = .allVisible
    }
}
