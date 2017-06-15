import UIKit

func alert(in viewController: UIViewController, message: String?, title: String?) {
    
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
    controller.addAction(okAction)
    
    viewController.present(controller, animated: true, completion: nil)
}

func errorAlert(in viewController: UIViewController, baseMessage: String, error: Error?) {
    if let errorMessage = error?.localizedDescription {
        alert(in: viewController, message: errorMessage, title: baseMessage)
    } else {
        alert(in: viewController, message: baseMessage, title: nil)
    }
}
