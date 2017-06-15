import UIKit
import CMHealth

class ApplicationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello World")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CMHUser.current().isLoggedIn {
            // Show main interface
            print("[PORTAL] TODO: Show main interface")
        } else {
            showAuthScreen()
        }
    }
}

// MARK: Private

private extension ApplicationViewController {
    
    func showAuthScreen() {
        onMain {
            guard let authVC = UIStoryboard(name: "Authentication", bundle: Bundle.main).instantiateInitialViewController() as? AuthViewController else {
                return
            }
            
            self.present(authVC, animated: true, completion: nil)
        }
    }
}
