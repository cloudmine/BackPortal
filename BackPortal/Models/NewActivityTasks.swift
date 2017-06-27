import ResearchKit
import CareKit

struct NewActitiviesTasks {
    
    // MARK: Public
    
    static var AddInterventionTask: ORKOrderedTask {
        let steps = [ExerciseNameQuestion, ExerciseTimeQuestion,
                     ExerciseDaysQuestion, ExerciseRepetitionsQuestion,
                     ExerciseInstructionsQuestion]
        
        return ORKOrderedTask(identifier: "PortalAddInterventionActivity",
                              steps: steps)
    }
    
    static func carePlanActivity(from result:ORKTaskResult) -> OCKCarePlanActivity? {
        guard
            "PortalAddInterventionActivity" == result.identifier,
            let title = title(from: result),
            let repetitions = repetitions(from: result),
            let schedule = schedule(from: result, repetitions: repetitions)
        else {
            return nil
        }
        
        // NOTE: This would likely still break on various special characters
        let strippedTitle = title
                            .replacingOccurrences(of: " ", with: "-")
                            .replacingOccurrences(of: "\t", with: "-")
                            .replacingOccurrences(of: "\n", with: "-")

        let identifier = "BCM\(strippedTitle)InterventionActivity"
        let instructions = self.instructions(from: result)
        let description = self.description(from: result)
        
        return OCKCarePlanActivity(identifier: identifier,
                                   groupIdentifier: ExerciseActivityGroupIdentifier,
                                   type: .intervention,
                                   title: title,
                                   text: description,
                                   tintColor: UIColor.orange,
                                   instructions: instructions,
                                   imageURL: nil,
                                   schedule: schedule,
                                   resultResettable: true,
                                   userInfo: nil)
    }
    
}

// MARK: ResearcKit Step Factories

fileprivate extension NewActitiviesTasks {
    
    static let ExerciseActivityGroupIdentifier = "Exercises"
    
    static let ExercieNameQuestionIdentifier = "PortalAddExerciseName"
    
    static var ExerciseNameQuestion: ORKQuestionStep {
        let answer = ORKTextAnswerFormat(maximumLength: 50)
        
        let question = ORKQuestionStep(identifier: ExercieNameQuestionIdentifier,
                                           title: NSLocalizedString("Exercise Name", comment: ""),
                                           text: NSLocalizedString("Enter the title for this exercie activity", comment: ""),
                                           answer: answer)
        question.isOptional = false
        
        return question
    }
    
    static let ExerciseTimeQuestionIdentifier = "PortalAddExerciseTime"
    
    static var ExerciseTimeQuestion: ORKQuestionStep {
        let answer = ORKNumericAnswerFormat(style: .integer,
                                            unit: NSLocalizedString("minutes", comment: ""),
                                            minimum: NSNumber(value: 1),
                                            maximum: NSNumber(value: 120))
        
        let question = ORKQuestionStep(identifier: ExerciseTimeQuestionIdentifier,
                                       title: NSLocalizedString("Duration", comment: ""),
                                       text: NSLocalizedString("Enter the prescribed exercise duration in minutes", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    static let ExerciseDaysQuesitonIdentifier = "PortalAddExerciseDays"
    
    static var ExerciseDaysQuestion: ORKQuestionStep {
        let choices = [ ORKTextChoice(text: NSLocalizedString("Sunday", comment: ""), value: "Su" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Monday", comment: ""), value: "Mo" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Tuesday", comment: ""), value: "Tu" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Wednesday", comment: ""), value: "We" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Thursday", comment: ""), value: "Th" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Friday", comment: ""), value: "Fr" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Saturday", comment: ""), value: "Sa" as NSString), ]
        
        let answer = ORKTextChoiceAnswerFormat(style: .multipleChoice,
                                               textChoices: choices)
        
        let question = ORKQuestionStep(identifier: ExerciseDaysQuesitonIdentifier,
                                       title: NSLocalizedString("Days of Week", comment: ""),
                                       text: NSLocalizedString("Select the days of the week the patient should complete this exercise", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    static let ExerciseRepetitionsQuestionIdentifier = "PortalAddExerciseRepetitions"
    
    static var ExerciseRepetitionsQuestion: ORKQuestionStep {
        let answer = ORKNumericAnswerFormat(style: .integer,
                                            unit: nil,
                                            minimum: NSNumber(value: 1),
                                            maximum: NSNumber(value: 5))
        
        let question = ORKQuestionStep(identifier: ExerciseRepetitionsQuestionIdentifier,
                                       title: NSLocalizedString("Daily Repetitions", comment: ""),
                                       text: NSLocalizedString("How many times, per day, should the patient complete this exercise", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    static let ExerciseInstructionsQuestionIdentifier = "PortalAddExerciseInstructions"
    
    static var ExerciseInstructionsQuestion: ORKQuestionStep {
        let answer = ORKTextAnswerFormat(maximumLength: 300)
        
        let question = ORKQuestionStep(identifier: ExerciseInstructionsQuestionIdentifier,
                                       title: NSLocalizedString("Instructions", comment: ""),
                                       text: NSLocalizedString("Enter the instructions for the patient to follow for this exercise", comment: ""),
                                       answer: answer)
        question.isOptional = true
        
        return question
    }
}

// MARK: OCKCarePlanActivity Extraction

fileprivate extension NewActitiviesTasks {
    
    static func title(from taskResult: ORKTaskResult) -> String? {
        return
            extract(from: taskResult, identifier: ExercieNameQuestionIdentifier, extractor: { (textResult: ORKTextQuestionResult) in
                return textResult.textAnswer
            })
    }
    
    static func repetitions(from taskResult: ORKTaskResult) -> Int? {
        return
            extract(from: taskResult, identifier: ExerciseRepetitionsQuestionIdentifier, extractor: { (numResult: ORKNumericQuestionResult) in
                return numResult.numericAnswer?.intValue
            })
    }
    
    static func description(from taskResult: ORKTaskResult) -> String? {
        return
            extract(from: taskResult, identifier: ExerciseTimeQuestionIdentifier, extractor: { (numResult: ORKNumericQuestionResult) in
                guard
                    let value = numResult.numericAnswer as? Int,
                    let units = numResult.unit
                else {
                        return nil
                }
                
                return "\(value) \(units)"
            })
    }
    
    static func schedule(from taskResult: ORKTaskResult, repetitions: Int) -> OCKCareSchedule? {
        guard
            let dayList =
            extract(from: taskResult,
                    identifier: ExerciseDaysQuesitonIdentifier,
                    extractor: { (choiceResult: ORKChoiceQuestionResult) -> ([String]?) in
                        return choiceResult.choiceAnswers as? [String]
                    })
        else {
            return nil
        }
        
        let repSchedule = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                            .flatMap({ dayList.contains($0) ? 1 : 0 })
                            .map({ $0 * repetitions })
                            .map({ NSNumber(value: $0) })
        
        let todayComponents = NSDateComponents(date: Date(), calendar: Calendar.current) as DateComponents
        
        return OCKCareSchedule.weeklySchedule(withStartDate: todayComponents,
                                              occurrencesOnEachDay: repSchedule)
    }
    
    static func instructions(from taskResult: ORKTaskResult) -> String? {
        return
            extract(from: taskResult, identifier: ExerciseInstructionsQuestionIdentifier, extractor: { (textResult: ORKTextQuestionResult) in
                return textResult.textAnswer
            })
    }
    
    static func extract<T: ORKQuestionResult, U>(from taskResult: ORKTaskResult, identifier: String, extractor: (T) -> (U?)) -> U? {
        guard let results = taskResult.results else {
            return nil
        }
        
        guard let questionResult = results
                                    .flatMap({ $0 as? ORKStepResult })
                                    .flatMap({ (stepResult) -> T? in
                                                guard
                                                    let questionResult = stepResult.firstResult as? T,
                                                    questionResult.identifier == identifier
                                                else {
                                                        return nil
                                                }
                                                
                                                return questionResult
                                            })
                                    .first
        else {
            return nil
        }
        
        return extractor(questionResult)
    }
}
