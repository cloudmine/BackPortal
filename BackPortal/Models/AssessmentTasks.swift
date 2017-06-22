import ResearchKit

struct AssessmentTasks {
    
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
}
