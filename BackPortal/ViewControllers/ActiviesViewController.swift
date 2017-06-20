import UIKit
import CareKit.NSDateComponents_CarePlan

fileprivate let InterventionActivityReuseIdentifier = "InterventionCell"

class ActiviesViewController: UICollectionViewController {
    
    // MARK: Private properties
    
    fileprivate var interventionEvents: [[OCKCarePlanEvent]] = []
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello Activies Collection")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[PORTAL] Activies Collection Appeared")
        
        guard let patient = patientSplitViewController?.patientListViewController?.selectedPatient else {
            return
        }
        
        update(for: patient, on: Date())
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ActiviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200.0, height: 100.0)
    }
}

// MARK: UICollectionViewDataSource

extension ActiviesViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interventionEvents.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterventionActivityReuseIdentifier, for: indexPath)
        
        guard
            let interventionCell = cell as? InterventionCell,
            indexPath.row < interventionEvents.count
        else {
            return cell
        }
        
        interventionCell.configure(with: interventionEvents[indexPath.row])
        
        return interventionCell
    }
}

// MARK: Private Helpers

fileprivate extension ActiviesViewController {
    
    func update(for patient: OCKPatient, on date: Date) {
        
        let todayComponents = NSDateComponents(date: Date(), calendar: Calendar.current) as DateComponents
        
        patient.store.events(onDate: todayComponents, type: .intervention) { (events, error) in
            guard nil == error else {
                print("[PORTAL] Error getting events: \(error!)")
                return
            }
            
            self.interventionEvents = events
            onMain {
                self.collectionView?.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDelegate

//extension ActiviesViewController {
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
//}
