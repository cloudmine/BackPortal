import UIKit
import CareKit.NSDateComponents_CarePlan

fileprivate let InterventionActivityReuseIdentifier = "InterventionCell"
fileprivate let AssessmentActivityReuseIdentifier = "AssessmentCell"

class ActiviesViewController: UICollectionViewController {
    
    // MARK: Private properties
    
    fileprivate var interventionEvents: [[OCKCarePlanEvent]] = []
    fileprivate var assessmentEvents: [[OCKCarePlanEvent]] = []
    fileprivate var lastRenderedBounds: CGRect?
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[PORTAL] Hello Activies Collection")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[PORTAL] Activies Collection Appeared")
        
        updateData(on: Date())
        lastRenderedBounds = collectionView?.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard collectionView?.bounds != lastRenderedBounds else {
            return
        }
        
        lastRenderedBounds = collectionView?.bounds
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

// MARK: UICollectionViewDelegateFlowLayout

fileprivate let PortalCellCellInternalSpacing = 8.0 as CGFloat
fileprivate let PortalCellVerticalRowSpacing = 8.0 as CGFloat
fileprivate let PortalCellContainerEdgeSpacing = 16.0 as CGFloat

extension ActiviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width / 2.0 - (PortalCellCellInternalSpacing/2 + PortalCellContainerEdgeSpacing)
        return CGSize(width: width, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return PortalCellVerticalRowSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PortalCellCellInternalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: PortalCellContainerEdgeSpacing, bottom: 0.0, right: PortalCellContainerEdgeSpacing)
    }
}

// MARK: UICollectionViewDataSource

extension ActiviesViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return interventionEvents.count
        case 1: return assessmentEvents.count
        default: return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: return interventionCell(from: collectionView, at: indexPath)
        case 1: return assessmentCell(from: collectionView, at: indexPath)
        default: fatalError()
        }
    }
}

// MARK: Private Helpers

fileprivate extension ActiviesViewController {
    
    var selectedPatient: OCKPatient? {
        return patientSplitViewController?.patientListViewController?.selectedPatient
    }
    
    func updateData(on date: Date) {
        guard let patient = selectedPatient else {
            return
        }
        
        let todayComponents = NSDateComponents(date: date, calendar: Calendar.current) as DateComponents
        
        patient.store.events(onDate: todayComponents, type: .intervention) { (interventions, interventionError) in
            guard nil == interventionError else {
                print("[PORTAL] Error getting interventions: \(interventionError!)")
                return
            }
            
            patient.store.events(onDate: todayComponents, type: .assessment) { (assessments, assessmentError) in
                guard nil == assessmentError else {
                    print("[PORTAL] Error getting assessments: \(assessmentError!)")
                    return
                }
                
                
                self.interventionEvents = interventions
                self.assessmentEvents = assessments
                
                onMain {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func toggle(interventionEvent event: OCKCarePlanEvent) {
        guard case .intervention = event.activity.type else {
            return
        }
        
        let newState = toggledState(for: event)
        
        selectedPatient?.store.update(event, with: nil, state: newState) { [weak self] (success, event, error) in
            guard success else {
                print("[PORTAL] Error updating even in local store! \(String(describing: error))")
                return
            }
            
            self?.updateData(on: Date())
        }
    }
    
    func interventionCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterventionActivityReuseIdentifier, for: indexPath)
        
        guard
            let interventionCell = cell as? InterventionCell,
            indexPath.row < interventionEvents.count
        else {
                return cell
        }
        
        interventionCell.configure(with: interventionEvents[indexPath.row]) { [weak self] event in
            print("[PORTAL] Callback for event with occurrence: \(event.occurrenceIndexOfDay)")
            
            self?.toggle(interventionEvent: event)
        }
        
        return interventionCell
    }
    
    func assessmentCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssessmentActivityReuseIdentifier, for: indexPath)
        return cell
    }
}

fileprivate func toggledState(for event: OCKCarePlanEvent) -> OCKCarePlanEventState {
    switch event.state {
    case .completed:
        return .notCompleted
    case .initial:
        return .completed
    case .notCompleted:
        return .completed
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
