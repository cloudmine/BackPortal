import UIKit
import CMHealth

class PatientListViewController: UITableViewController {
    
    fileprivate var patients: [OCKPatient] = [] {
        didSet {
            renderUI()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPatients()
    }
    
    private func renderUI() {
        onMain {
            self.tableView?.reloadData()
        }
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath)

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
        CMHCarePlanStore.fetchAllPatients { (success, patients, errors) in
            guard success else {
                print("[PORTAL] Failed to fetch patients: \(errors)")
                return
            }
            
            self.patients = patients
        }
    }
}
