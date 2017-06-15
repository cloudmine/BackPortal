import UIKit
import CMHealth

class AccountViewController: UIViewController {
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButtons()
        
        CMHUser.current().addObserver(self, forKeyPath: "userData", options: NSKeyValueObservingOptions.initial.union(.new), context: nil)
    }
    
    deinit {
        CMHUser.current().removeObserver(self, forKeyPath: "userData")
    }
    
    func refreshUI() {
        onMain {
            self.emailLabel.text = CMHUser.current().userData?.email
        }
    }
}

// MARK: KVO

extension AccountViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard
            let user = object as? CMHUser,
            user == CMHUser.current(),
            keyPath == "userData"
            else {
                return;
        }
        
        refreshUI()
    }
}

// MARK: Target-Action

extension AccountViewController {
    
    @IBAction func pressedLogoutButton(_ sender: UIButton) {
        CMHUser.current().logout { error in
            guard nil == error else {
                errorAlert(in: self, baseMessage: NSLocalizedString("Error Logging Out", comment: ""), error: error)
                return
            }
            
            self.dismiss(animated: false, completion: nil)
        }
    }
}

// MARK: Helpers

private extension AccountViewController {
    
    func styleButtons() {
        logoutButton.layer.borderWidth = 1.0
        logoutButton.layer.borderColor = logoutButton.tintColor?.cgColor
        logoutButton.layer.cornerRadius = 4.0
    }
}
