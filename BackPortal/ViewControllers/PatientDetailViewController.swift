import UIKit

class PatientDetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var dateButton: UIBarButtonItem?
    
    // MARK: Private Properties
    
    fileprivate static var formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM d, yyyy"
        return df
    }()
    
    // MARK: Public Properties
    
    fileprivate(set) var lastSelectedDate: Date = Date()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello Patient Detail")
        
        navigationItem.leftBarButtonItem = parent?.splitViewController?.displayModeButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let patientName = patientSplitViewController?.patientListViewController?.selectedPatient?.name {
            navigationItem.title = patientName
        } else {
            navigationItem.title = "Patient"
        }
    }
}

// MARK: Taret-Action

extension PatientDetailViewController {
    
    @IBAction func didPress(dateButton: UIBarButtonItem) {
        let datePickVC = UIViewController()
        datePickVC.modalPresentationStyle = .popover
        datePickVC.preferredContentSize = CGSize(width: 320, height: 225)
        datePickVC.popoverPresentationController?.barButtonItem = dateButton
        datePickVC.popoverPresentationController?.delegate = self
        
        let datePickerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 225))
        
        let datePicker = UIDatePicker(frame: datePickerView.frame)
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(selectedDate(from:)), for: .valueChanged)
        
        datePickerView.addSubview(datePicker)
        datePickVC.view = datePickerView
        
        present(datePickVC, animated: true, completion: nil)
    }
    
    func selectedDate(from datePicker: UIDatePicker) {
        lastSelectedDate = datePicker.date
    }
}

// MARK: UIPopoverPresentationControllerDelegate

extension PatientDetailViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        activitiesViewController?.reloadData()
        
        onMain {
            self.dateButton?.title = PatientDetailViewController.formatter.string(from: self.lastSelectedDate)
        }
    }
}

// MARK: Private Helpers

private extension PatientDetailViewController {
    
    var activitiesViewController: ActiviesViewController? {
        return childViewControllers
                .flatMap({ $0 as? ActiviesViewController })
                .first
    }
}
