import UIKit
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
        print("[PORTAL] Hello Activies Collection")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[PORTAL] Activies Collection Appeared")
        
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
        viewController.modalPresentationStyle = .popover
        viewController.popoverPresentationController?.sourceView = view
        viewController.preferredContentSize = CGSize(width: 320, height: 250)
        
        present(viewController, animated: true, completion: nil)
    }
    
    func activitiesHeader(_ activitiesHeader: ActivitiesHeader, didSelectAddFor type: ActivitiesHeaderType) {
        let taskVC = ORKTaskViewController(task: NewActitiviesTasks.AddInterventionTask, taskRun: nil)
        taskVC.modalPresentationStyle = .formSheet
        taskVC.delegate = self
        
        present(taskVC, animated: true, completion: nil)
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
            let eventResult = eventResult(from: taskResult)
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
    
    func eventResult(from taskResult: ORKTaskResult) -> OCKCarePlanEventResult? {
        guard let stepResult = taskResult.firstResult as? ORKStepResult else {
            return nil
        }
        
        switch taskResult.identifier {
        case AssessmentTasks.WeightIdentifier:
            return weightResult(from: stepResult)
        case AssessmentTasks.MoodIdentifier:
            return scaleResult(from: stepResult)
        case AssessmentTasks.PainIdentifier:
            return scaleResult(from: stepResult)
        default:
            return nil
        }
    }
    
    func weightResult(from stepResult: ORKStepResult) -> OCKCarePlanEventResult? {
        guard
            let weightResult = stepResult.firstResult as? ORKNumericQuestionResult,
            let weightAnswer = weightResult.numericAnswer,
            let weightUnit = weightResult.unit
        else {
            return nil
        }
        
        return OCKCarePlanEventResult(valueString: weightAnswer.stringValue,
                                      unitString: weightUnit,
                                      userInfo: nil)
    }
    
    func scaleResult(from stepResult: ORKStepResult) -> OCKCarePlanEventResult? {
        guard
            let scaleResult = stepResult.firstResult as? ORKScaleQuestionResult,
            let scaleAnswer = scaleResult.scaleAnswer
        else {
            return nil
        }
        
        return OCKCarePlanEventResult(valueString: scaleAnswer.stringValue,
                                      unitString: NSLocalizedString("out of 10", comment: ""),
                                      userInfo: nil)
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
        
        guard
            let assessmentCell = cell as? AssessmentCell,
            indexPath.row < assessmentEvents.count
        else {
            return cell
        }
        
        assessmentCell.configure(with: assessmentEvents[indexPath.row], tapBack: nil)
        
        return assessmentCell
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
