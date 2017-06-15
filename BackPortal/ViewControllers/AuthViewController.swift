import UIKit
import CMHealth
import SwiftValidator

class AuthViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    
    // MARK: Properties
    
    fileprivate let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Auth View Did Load")
        
        validator.registerField(emailTextField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordTextField, errorLabel: passwordErrorLabel, rules: [RequiredRule()])
    }
}

// MARK: Target-Action

extension AuthViewController {
    
    @IBAction func didPress(loginButton sender: UIButton) {
        validator.validate(self)
    }
}

// MARK: Validation Delegate

extension AuthViewController: ValidationDelegate {
    
    func validationSuccessful() {
        clearErrorLabels()
        login()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        clearErrorLabels()
        
        errors.forEach { (field, error) in
            error.errorLabel?.text = error.errorMessage
        }
    }
}

// MARK: Helpers

private extension AuthViewController {
    
    func clearErrorLabels() {
        [emailErrorLabel, passwordErrorLabel].forEach { label in
            label?.text = nil
        }
    }
    
    func login() {
        guard
            let email = emailTextField?.text,
            let password = passwordTextField?.text
            else {
                return
        }
        
        CMHUser.current().login(withEmail: email, password: password) { error in
            guard nil == error else {
                errorAlert(in: self, baseMessage: "Error Logging In", error: error)
                return
            }
            
            print ("[PORTAL] Login successful!")
            self.dismiss(animated: false, completion: nil)
        }
    }
}
