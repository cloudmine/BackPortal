import ResearchKit
import CareKit

struct NewActitiviesTasks {
    
    static var AddInterventionTask: ORKOrderedTask {
        let steps = [ExerciseNameQuestion, ExerciseTimeQuestion,
                     ExerciseDaysQuestion, ExerciseRepetitionsQuestion,
                     ExerciseInstructionsQuestion]
        
        return ORKOrderedTask(identifier: "PortalAddInterventionActivity",
                              steps: steps)
    }
    
    static func carePlanActivity(from result:ORKTaskResult?) -> OCKCarePlanActivity? {
        guard
            let result = result,
            "PortalAddInterventionActivity" == result.identifier,
            let title = title(from: result)
        else {
            return nil
        }
        
        let todayComponents = NSDateComponents(date: Date(), calendar: Calendar.current) as DateComponents
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: todayComponents,
                                                      occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        let identifier = "BCM\(title)InterventionActivity"
        
        return OCKCarePlanActivity(identifier: identifier,
                                   groupIdentifier: nil,
                                   type: .intervention,
                                   title: title,
                                   text: nil,
                                   tintColor: nil,
                                   instructions: nil,
                                   imageURL: nil,
                                   schedule: schedule,
                                   resultResettable: true,
                                   userInfo: nil)
    }
    
    private static func title(from taskResult: ORKTaskResult) -> String? {
        guard let results = taskResult.results else {
            return nil
        }
        
        return results
                .flatMap({ $0 as? ORKStepResult })
                .flatMap({ (stepResult) -> ORKTextQuestionResult? in
                    guard
                        let textResult = stepResult.firstResult as? ORKTextQuestionResult,
                        textResult.identifier == "PortalAddExerciseName"
                    else {
                            return nil
                    }
                    
                    return textResult
                })
                .first?
                .textAnswer
    }
    
    private static var ExerciseNameQuestion: ORKQuestionStep {
        let answer = ORKTextAnswerFormat(maximumLength: 50)
        
        let question = ORKQuestionStep(identifier: "PortalAddExerciseName",
                                           title: NSLocalizedString("Exercise Name", comment: ""),
                                           text: NSLocalizedString("Enter the title for this exercie activity", comment: ""),
                                           answer: answer)
        question.isOptional = false
        
        return question
    }
    
    private static var ExerciseTimeQuestion: ORKQuestionStep {
        let answer = ORKNumericAnswerFormat(style: .integer,
                                            unit: NSLocalizedString("minutes", comment: ""),
                                            minimum: NSNumber(value: 1),
                                            maximum: NSNumber(value: 120))
        
        let question = ORKQuestionStep(identifier: "PortalAddExerciseTime",
                                       title: NSLocalizedString("Duration", comment: ""),
                                       text: NSLocalizedString("Enter the prescribed exercise duration in minutes", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    private static var ExerciseDaysQuestion: ORKQuestionStep {
        let choices = [ORKTextChoice(text: NSLocalizedString("Monday", comment: ""), value: "M" as NSString),
                       ORKTextChoice(text: NSLocalizedString("Tuesday", comment: ""), value: "T" as NSString),
                       ORKTextChoice(text: NSLocalizedString("Wednesday", comment: ""), value: "W" as NSString),
                       ORKTextChoice(text: NSLocalizedString("Thursday", comment: ""), value: "R" as NSString),
                       ORKTextChoice(text: NSLocalizedString("Friday", comment: ""), value: "F" as NSString),
                       ORKTextChoice(text: NSLocalizedString("Saturday", comment: ""), value: "S" as NSString),
                       ORKTextChoice(text: NSLocalizedString("Sunday", comment: ""), value: "N" as NSString),]
                       
                       
        let answer = ORKTextChoiceAnswerFormat(style: .multipleChoice,
                                               textChoices: choices)
        
        let question = ORKQuestionStep(identifier: "PortalAddExerciseDays",
                                       title: NSLocalizedString("Days of Week", comment: ""),
                                       text: NSLocalizedString("Select the days of the week the patient should complete this exercise", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    private static var ExerciseRepetitionsQuestion: ORKQuestionStep {
        let answer = ORKNumericAnswerFormat(style: .integer,
                                            unit: nil,
                                            minimum: NSNumber(value: 1),
                                            maximum: NSNumber(value: 5))
        
        let question = ORKQuestionStep(identifier: "PortalAddExerciseRepetitions",
                                       title: NSLocalizedString("Daily Repetitions", comment: ""),
                                       text: NSLocalizedString("How many times, per day, should the patient complete this exercise", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    private static var ExerciseInstructionsQuestion: ORKQuestionStep {
        let answer = ORKTextAnswerFormat(maximumLength: 300)
        
        let question = ORKQuestionStep(identifier: "PortalAddExerciseInstructions",
                                       title: NSLocalizedString("Instructions", comment: ""),
                                       text: NSLocalizedString("Enter the instructions for the patient to follow for this exercise", comment: ""),
                                       answer: answer)
        question.isOptional = true
        
        return question
    }
}
