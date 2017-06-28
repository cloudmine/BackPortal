import ResearchKit
import CareKit

// MARK: Public

struct AssessmentTasks {
    
    static func taskFor(identifier activityId: String) -> ORKTask? {
        switch activityId {
        case WeightIdentifier:
            return AssessmentTasks.WeightTask
        case PainIdentifier:
            return AssessmentTasks.PainTask
        case MoodIdentifier:
            return AssessmentTasks.MoodTask
        default:
            return nil
        }
    }
 
    static func eventResult(from taskResult: ORKTaskResult) -> OCKCarePlanEventResult? {
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
}

// MARK: Task Factories

fileprivate extension AssessmentTasks {

    static var PainIdentifier = "BCMPainTrack"
    
    static var PainTask: ORKOrderedTask {
        let painScale = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 1, defaultValue: 5, step: 1)
        let painQuestion = ORKQuestionStep(identifier: PainIdentifier,
                                           title: "How did the patient rate their pain today?",
                                           text: "Where 1 is no pain and 10 is the worst pain imaginable",
                                           answer: painScale)
        painQuestion.isOptional = false
        
        return ORKOrderedTask(identifier: PainIdentifier, steps: [painQuestion])
    }
    
    static var MoodIdentifier = "BCMMoodTrack"
    
    static var MoodTask: ORKOrderedTask {
        let moodScale = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 1, defaultValue: 5, step: 1)
        let moodQuestion = ORKQuestionStep(identifier: MoodIdentifier,
                                           title: NSLocalizedString("How is the patient's mood today?", comment: ""),
                                           text: NSLocalizedString("Where 1 is very poor and 10 very good", comment: ""),
                                           answer: moodScale)
        moodQuestion.isOptional = false
        
        return ORKOrderedTask(identifier: MoodIdentifier, steps: [moodQuestion])
    }
    
    static var WeightIdentifier = "BCMWeightTrack"
    
    static var WeightTask: ORKOrderedTask {
        let weightAnswer = ORKNumericAnswerFormat(style: .decimal,
                                                  unit: NSLocalizedString("lbs", comment: ""),
                                                  minimum: NSNumber(value: 50),
                                                  maximum: NSNumber(value: 500))
        let weightQuestion = ORKQuestionStep(identifier: WeightIdentifier,
                                             title: NSLocalizedString("Weight", comment: ""),
                                             answer: weightAnswer)
        weightQuestion.isOptional = false
        
        return ORKOrderedTask(identifier: WeightIdentifier, steps: [weightQuestion])
    }
}

// MARK: ResearchKit result to CareKit result

fileprivate extension AssessmentTasks {
    
    static func weightResult(from stepResult: ORKStepResult) -> OCKCarePlanEventResult? {
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
    
    static func scaleResult(from stepResult: ORKStepResult) -> OCKCarePlanEventResult? {
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
}
