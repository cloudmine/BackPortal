import UIKit
import CMHealth

class PatientListViewController: UITableViewController {
    
    // MARK: Private Properties
    
    fileprivate var patients: [OCKPatient] = [] {
        didSet {
            renderUI()
        }
    }
    
    // MARK: Public Properties
    
    var selectedPatient: OCKPatient? {
        guard let row = tableView?.indexPathForSelectedRow?.row, row < patients.count else {
            return nil
        }
        
        return patients[row]
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPatients()
    }
    
    private func renderUI() {
        onMain {
            self.tableView?.reloadData()
            self.refreshControl?.endRefreshing()
            self.performSegue(withIdentifier: "NoSelectionDetail", sender: nil)
        }
    }
}

// MARK: Target-Action

extension PatientListViewController {
    
    @IBAction func didPull(refreshControl: UIRefreshControl) {
        fetchPatients()
    }
}

// MARK: UITableViewDataSource

extension PatientListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as? PatientCell,
            indexPath.row < patients.count
        else {
            assert(false, "Expected to find a PatientCell and valid indexPath")
            return UITableViewCell()
        }
        
        cell.configure(with: patients[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate

extension PatientListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("[PORTAL] Selected Patient \(indexPath.row)")
    }
}

// MARK: Private Helpers

private extension PatientListViewController {
    
    func fetchPatients() {
        onMain {
            self.refreshControl?.beginRefreshing()
        }
        
        CMHCarePlanStore.fetchAllPatients { (success, patients, errors) in
            guard success else {
                print("[PORTAL] Failed to fetch patients: \(errors)")
                return
            }
            
            self.patients = patients
        }
    }
}
