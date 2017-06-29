import UIKit
import CMHealth
import CareKit
import ResearchKit

fileprivate let InterventionActivityReuseIdentifier = "InterventionCell"
fileprivate let AssessmentActivityReuseIdentifier = "AssessmentCell"

class ActiviesViewController: UICollectionViewController {
    
    // MARK: Private properties
    
    fileprivate var interventionEvents: [[OCKCarePlanEvent]] = []
    fileprivate var assessmentEvents: [[OCKCarePlanEvent]] = []
    fileprivate var lastRenderedBounds: CGRect? = nil
    fileprivate var lastSelectedAssessment: OCKCarePlanEvent? = nil
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.gray
        collectionView?.addSubview(refresh)
        refresh.addTarget(self, action: #selector(didActivate(refreshControl:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadData()
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

// MARK: Public

extension ActiviesViewController {
    
    func reloadData() {
        guard
            let patient = selectedPatient,
            let date = selectedDate
        else {
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
}

// MARK: Target-Action

fileprivate extension ActiviesViewController {
    
    @objc func didActivate(refreshControl: UIRefreshControl) {
        guard
            refreshControl.isRefreshing,
            let store = selectedPatient?.store as? CMHCarePlanStore
        else {
            refreshControl.endRefreshing()
            return
        }
        
        store.runFetch { [weak self, weak refreshControl] (success, errors) in
            defer {
                onMain {
                    refreshControl?.endRefreshing()
                }
            }
            
            guard success else {
                print("[PORTAL] Error(s) fetching patient store: \(errors)")
                return
            }
            
            self?.reloadData()
        }
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
        return UIEdgeInsets(top: 0.0, left: PortalCellContainerEdgeSpacing, bottom: 24.0, right: PortalCellContainerEdgeSpacing)
    }
}

// MARK: UICollectionViewDataSource

extension ActiviesViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return interventionEvents.count
        case 1:
            return assessmentEvents.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard UICollectionElementKindSectionHeader == kind else {
            fatalError("Footers not implemented in collection view")
        }
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ActivitiesSectionHeader", for: indexPath)
        
        guard
            let header = reusableView as? ActivitiesHeader,
            let type = ActivitiesHeaderType(rawValue: indexPath.section)
        else {
            return reusableView
        }
        
        header.configure(as: type, delegate: self)
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return interventionCell(from: collectionView, at: indexPath)
        case 1:
            return assessmentCell(from: collectionView, at: indexPath)
        default:
            fatalError()
        }
    }
}

// MARK: UICollectionViewDelegate

extension ActiviesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            1 == indexPath.section,
            indexPath.row < assessmentEvents.count,
            let taskVC = taskViewController(for: assessmentEvents[indexPath.row].first)
        else {
            return
        }
        
        lastSelectedAssessment = assessmentEvents[indexPath.row].first
        present(taskVC, animated: true, completion: nil)
    }
}

// MARK: ORKTaskViewControllerDelegate

extension ActiviesViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        guard case .completed = reason else {
            return
        }
        
        if let newActivity = NewActitiviesTasks.carePlanActivity(from: taskViewController.result) {
            insert(activity: newActivity)
        } else {
            updateAssessment(event: lastSelectedAssessment, withResult: taskViewController.result)
        }
    }
}

// MARK: ActivitiesHeaderDelegate

extension ActiviesViewController: ActivitiesHeaderDelegate {
    
    func activitiesHeader(_ activitiesHeader: ActivitiesHeader, wantsToShowPopover viewController: UIViewController, from view: UIView) {
        let midBounds = CGRect(x: view.bounds.midX - 1, y: view.bounds.midY - 1, width: 3, height: 3)
        viewController.popoverPresentationController?.sourceView = view
        viewController.popoverPresentationController?.sourceRect = midBounds
        
        present(viewController, animated: true, completion: nil)
    }
    
    func activitiesHeader(_ activitiesHeader: ActivitiesHeader, didSelectAddFor subtype: ActivitySubtype) {
        if nil != presentedViewController {
            dismiss(animated: false, completion: nil)
        }
        
        let task = NewActitiviesTasks.task(for: subtype)
        let taskVC = ORKTaskViewController(task: task, taskRun: nil)
        taskVC.modalPresentationStyle = .formSheet
        taskVC.delegate = self
        
        present(taskVC, animated: true, completion: nil)
    }
}

// MARK: Store Actions

fileprivate extension ActiviesViewController {
    
    func insert(activity: OCKCarePlanActivity) {
        selectedPatient?.store.add(activity, completion: { [weak self] (success, error) in
            guard success else {
                print("[PORTAL] Error updating store: \(error!.localizedDescription)")
                return
            }
            
            self?.reloadData()
        })
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
            
            self?.reloadData()
        }
    }
    
    func updateAssessment(event: OCKCarePlanEvent?, withResult taskResult: ORKTaskResult?) {
        guard
            let taskResult = taskResult,
            let event = lastSelectedAssessment,
            let eventResult = AssessmentTasks.eventResult(from: taskResult)
            else {
                return
        }
        
        selectedPatient?.store.update(event, with: eventResult, state: .completed) { [weak self] (success, event, error) in
            guard nil == error else {
                print("[PORTAL] Error Updating Assessment Event: \(error!)")
                return
            }
            
            self?.reloadData()
        }
    }
    
    func setEndDate(for activity: OCKCarePlanActivity) {
        guard let selectedDate = selectedDate else {
            return
        }
        
        let endComponents = NSDateComponents(date: selectedDate, calendar: Calendar.current) as DateComponents
        
        selectedPatient?.store.setEndDate(endComponents, for: activity) { [weak self] (success, activity, error) in
            guard success else {
                print("[PORTAL] Error setting end date: \(error!)")
                return
            }
            
            self?.reloadData()
        }
    }
    
    func archive(activity: OCKCarePlanActivity) {
        selectedPatient?.store.remove(activity) { [weak self] (success, error) in
            guard success else {
                print("[PORTAL] Error removing activity: \(error!)")
                return
            }
            
            self?.reloadData()
        }
    }
}

// MARK: Private Helpers

fileprivate extension ActiviesViewController {
    
    var selectedPatient: OCKPatient? {
        return patientSplitViewController?.patientListViewController?.selectedPatient
    }
    
    var selectedDate: Date? {
        return (parent as? PatientDetailViewController)?.lastSelectedDate
    }
    
    func interventionCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterventionActivityReuseIdentifier, for: indexPath)
        
        guard
            let interventionCell = cell as? InterventionCell,
            indexPath.row < interventionEvents.count
        else {
                return cell
        }
        
        interventionCell.configure(with: interventionEvents[indexPath.row]) { [weak self] action in
            switch action {
            case .toggle(let event):
                self?.toggle(interventionEvent: event)
            case .modify(let activity):
                self?.showActions(for: activity, from: interventionCell)
            }
        }
        
        return interventionCell
    }
    
    func assessmentCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssessmentActivityReuseIdentifier, for: indexPath)
        
        guard
            let assessmentCell = cell as? AssessmentCell,
            indexPath.row < assessmentEvents.count
        else {
            return cell
        }
        
        assessmentCell.configure(with: assessmentEvents[indexPath.row]) { [weak self] action in
            guard case .modify(let activity) = action else {
                return
            }
            
            self?.showActions(for: activity, from: assessmentCell)
        }
        
        return assessmentCell
    }
    
    func showActions(for activity: OCKCarePlanActivity, from view: UIView) {
        guard nil == presentedViewController else {
            return
        }
        
        let sheet = UIAlertController(title: NSLocalizedString("Modify \(activity.title)", comment: ""),
                                      message: NSLocalizedString("Select an action to perform on this activity", comment: ""),
                                      preferredStyle: .actionSheet)
        
        let midBounds = CGRect(x: view.bounds.midX - 1, y: view.bounds.midY - 1, width: 3, height: 3)
        sheet.popoverPresentationController?.sourceView = view
        sheet.popoverPresentationController?.sourceRect = midBounds
        
        let end = UIAlertAction(title: NSLocalizedString("End On This Day", comment: ""), style: .default) { _ in
            self.showConfirmationAlert(message: NSLocalizedString("Are you sure you want to end \(activity.title)? This action cannot be undone!", comment: "")) {
                self.setEndDate(for: activity)
            }
        }
        
        let archive = UIAlertAction(title: NSLocalizedString("Archive", comment: ""), style: .destructive) { _ in
            self.showConfirmationAlert(message: NSLocalizedString("Are you sure you want to archive \(activity.title)? The data will be removed from all devices, but saved in the cloud. This action cannot be undone!", comment: "")) {
                self.archive(activity: activity)
            }
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        sheet.addAction(end)
        sheet.addAction(archive)
        sheet.addAction(cancel)
        
        present(sheet, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(message: String?, action: @escaping () -> Void) {
        let alert = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .destructive) { _ in
            action()
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func taskViewController(for assessmentEvent: OCKCarePlanEvent?) -> ORKTaskViewController? {
        guard
            let assessmentEvent = assessmentEvent,
            case .assessment = assessmentEvent.activity.type,
            let task = AssessmentTasks.taskFor(identifier: assessmentEvent.activity.identifier)
        else {
            return nil
        }
        
        let taskVC = ORKTaskViewController(task: task, taskRun: nil)
        taskVC.modalPresentationStyle = .formSheet
        taskVC.showsProgressInNavigationBar = false
        taskVC.delegate = self
        
        return taskVC
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
