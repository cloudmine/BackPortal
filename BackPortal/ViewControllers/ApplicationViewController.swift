import UIKit
import CMHealth

class ApplicationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello World")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CMHUser.current().isLoggedIn {
            showMainPanel()
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
    
    func showMainPanel() {
        onMain {
            guard let mainVC = UIStoryboard(name: "MainPanel", bundle: Bundle.main).instantiateInitialViewController() as? MainPanelViewController else {
                return
            }
            
            self.present(mainVC, animated: false, completion: nil)
        }
    }
}
