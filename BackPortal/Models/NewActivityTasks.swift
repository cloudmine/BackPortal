import ResearchKit
import CareKit

struct NewActitiviesTasks {
    
    // MARK: Public
    
    static func task(for subtype: ActivitySubtype) -> ORKOrderedTask {
        switch subtype {
        case .exercise:
            return AddExerciseInterventionTask
        case .medication:
            return AddMedicationInterventionTask
        }
    }
    
    static func carePlanActivity(from result: ORKTaskResult) -> OCKCarePlanActivity? {
        if AddExerciseInterventionTaskIdentifier == result.identifier {
            return exerciseCarePlanActivity(from: result)
        } else if AddMedicationInterventionTaskIdentifier == result.identifier {
            return medicationCarePlanActivity(from: result)
        } else {
            return nil
        }
    }
}

// MARK: ResearchKit Medication Task Factory

fileprivate extension NewActitiviesTasks {
    
    static let AddMedicationInterventionTaskIdentifier = "PortalAddMedicationInterventionActivity"
    
    static let MedicationActivityGroupIdentifier = "Medications"
    
    static var AddMedicationInterventionTask: ORKOrderedTask {
        let steps = [MedicationNameQuestion, MedicationDosageQuestion,
                     MedicationDaysQuestion, MedicationRepetitionsQuestion,
                     MedicationStartDateQuestion, MedicationInstructionsQuestion]
        
        return ORKOrderedTask(identifier: AddMedicationInterventionTaskIdentifier,
                              steps: steps)
    }
    
    static let MedicationNameQuestionIdentifier = "PortalAddMedicationName"
    
    static var MedicationNameQuestion: ORKQuestionStep {
        let answer = ORKTextAnswerFormat(maximumLength: 50)
        
        let question = ORKQuestionStep(identifier: MedicationNameQuestionIdentifier,
                                       title: NSLocalizedString("Medication Name", comment: ""),
                                       text: NSLocalizedString("Enter the name of medication the patient will take", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    static let MedicationDosageQuestionIdentifier = "PortalAddMedicationDosage"
    
    static var MedicationDosageQuestion: ORKQuestionStep {
        let answer = ORKNumericAnswerFormat(style: .integer,
                                            unit: NSLocalizedString("mg", comment: ""),
                                            minimum: NSNumber(value: 1),
                                            maximum: NSNumber(value: 10000))
        
        let question = ORKQuestionStep(identifier: MedicationDosageQuestionIdentifier,
                                       title: NSLocalizedString("Dosage", comment: ""),
                                       text: NSLocalizedString("Enter the prescribed dosage in mg", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    static let MedicationDaysQuesitonIdentifier = "PortalAddMedicationDays"
    
    static var MedicationDaysQuestion: ORKQuestionStep {
        return daysOfWeekQuestion(identifier: MedicationDaysQuesitonIdentifier,
                                  title: NSLocalizedString("Days of Week", comment: ""),
                                  text: NSLocalizedString("Select the days of the week the patient should take this medication", comment: ""))
    }
    
    static let MedicationRepetitionsQuestionIdentifier = "PortalAddMedicationRepetitions"
    
    static var MedicationRepetitionsQuestion: ORKQuestionStep {
        let answer = ORKNumericAnswerFormat(style: .integer,
                                            unit: nil,
                                            minimum: NSNumber(value: 1),
                                            maximum: NSNumber(value: 5))
        
        let question = ORKQuestionStep(identifier: MedicationRepetitionsQuestionIdentifier,
                                       title: NSLocalizedString("Daily Doses", comment: ""),
                                       text: NSLocalizedString("How many times, per day, should the patient take the prescibed dosage of this medication?", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    static let MedicationStartDateQuestionIdentifier = "PortalAddMedicationStartDate"
    
    static var MedicationStartDateQuestion: ORKQuestionStep {
        let answer = ORKDateAnswerFormat(style: .date,
                                         defaultDate: Date(),
                                         minimumDate: nil,
                                         maximumDate: nil,
                                         calendar: Calendar.current)
        
        let question = ORKQuestionStep(identifier: MedicationStartDateQuestionIdentifier,
                                       title: NSLocalizedString("Start Date", comment: ""),
                                       text: NSLocalizedString("Select the date the patient should begin taking this medication.", comment: ""),
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
    
    static let MedicationInstructionsQuestionIdentifier = "PortalAddMedicationInstructions"
    
    static var MedicationInstructionsQuestion: ORKQuestionStep {
        let answer = ORKTextAnswerFormat(maximumLength: 300)
        
        let question = ORKQuestionStep(identifier: MedicationInstructionsQuestionIdentifier,
                                       title: NSLocalizedString("Instructions", comment: ""),
                                       text: NSLocalizedString("Enter the instructions for the patient to follow when taking this medication", comment: ""),
                                       answer: answer)
        question.isOptional = true
        
        return question
    }
}

// MARK: ResearcKit Exercise Task Factory

fileprivate extension NewActitiviesTasks {
    
    static let AddExerciseInterventionTaskIdentifier = "PortalAddExerciseInterventionActivity"
    
    static let ExerciseActivityGroupIdentifier = "Exercises"
    
    static var AddExerciseInterventionTask: ORKOrderedTask {
        let steps = [ExerciseNameQuestion, ExerciseTimeQuestion,
                     ExerciseDaysQuestion, ExerciseRepetitionsQuestion,
                     ExerciseStartDateQuestion, ExerciseInstructionsQuestion]
        
        return ORKOrderedTask(identifier: AddExerciseInterventionTaskIdentifier,
                              steps: steps)
    }
    
    static let ExerciseNameQuestionIdentifier = "PortalAddExerciseName"
    
    static var ExerciseNameQuestion: ORKQuestionStep {
        let answer = ORKTextAnswerFormat(maximumLength: 50)
        
        let question = ORKQuestionStep(identifier: ExerciseNameQuestionIdentifier,
                                           title: NSLocalizedString("Exercise Name", comment: ""),
                                           text: NSLocalizedString("Enter the title for this exercise activity", comment: ""),
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
        return daysOfWeekQuestion(identifier: ExerciseDaysQuesitonIdentifier,
                                  title: NSLocalizedString("Days of Week", comment: ""),
                                  text: NSLocalizedString("Select the days of the week the patient should complete this exercise", comment: ""))
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
    
    static let ExerciseStartDateQuestionIdentifier = "PortalAddExerciseStartDate"
    
    static var ExerciseStartDateQuestion: ORKQuestionStep {
        let answer = ORKDateAnswerFormat(style: .date,
                                         defaultDate: Date(),
                                         minimumDate: nil,
                                         maximumDate: nil,
                                         calendar: Calendar.current)
        
        let question = ORKQuestionStep(identifier: ExerciseStartDateQuestionIdentifier,
                                       title: NSLocalizedString("Start Date", comment: ""),
                                       text: NSLocalizedString("Select the date the patient should begin this exercise task.", comment: ""),
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

// MARK: Question Builders

fileprivate extension NewActitiviesTasks {
    
    static func daysOfWeekQuestion(identifier: String, title: String, text: String?) -> ORKQuestionStep {
        let choices = [ ORKTextChoice(text: NSLocalizedString("Sunday", comment: ""), value: "Su" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Monday", comment: ""), value: "Mo" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Tuesday", comment: ""), value: "Tu" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Wednesday", comment: ""), value: "We" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Thursday", comment: ""), value: "Th" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Friday", comment: ""), value: "Fr" as NSString),
                        ORKTextChoice(text: NSLocalizedString("Saturday", comment: ""), value: "Sa" as NSString), ]
        
        let answer = ORKTextChoiceAnswerFormat(style: .multipleChoice,
                                               textChoices: choices)
        
        let question = ORKQuestionStep(identifier: identifier,
                                       title: title,
                                       text: text,
                                       answer: answer)
        question.isOptional = false
        
        return question
    }
}

// MARK: OCKCarePlanActivity Extraction

fileprivate extension NewActitiviesTasks {
    
    static func exerciseCarePlanActivity(from result: ORKTaskResult) -> OCKCarePlanActivity? {
        guard
            AddExerciseInterventionTaskIdentifier == result.identifier,
            let title = text(from: result, for: ExerciseNameQuestionIdentifier),
            let repetitions = repetitions(from: result, for: ExerciseRepetitionsQuestionIdentifier),
            let startDate = startDate(from: result, for: ExerciseStartDateQuestionIdentifier),
            let schedule = schedule(from: result, start: startDate, repetitions: repetitions, for: ExerciseDaysQuesitonIdentifier)
        else {
            return nil
        }
        
        let safeTitle = sanitize(title: title)
        let identifier = "BCM\(safeTitle)InterventionActivity"
        let instructions = self.text(from: result, for: ExerciseInstructionsQuestionIdentifier)
        let unitDescription = self.unitDescription(from: result, for: ExerciseTimeQuestionIdentifier)
        
        return OCKCarePlanActivity(identifier: identifier,
                                   groupIdentifier: ExerciseActivityGroupIdentifier,
                                   type: .intervention,
                                   title: title,
                                   text: unitDescription,
                                   tintColor: UIColor.orange,
                                   instructions: instructions,
                                   imageURL: nil,
                                   schedule: schedule,
                                   resultResettable: true,
                                   userInfo: nil)
    }
    
    static func medicationCarePlanActivity(from result: ORKTaskResult) -> OCKCarePlanActivity? {
        guard
            AddMedicationInterventionTaskIdentifier == result.identifier,
            let title = text(from: result, for: MedicationNameQuestionIdentifier),
            let repetitions = repetitions(from: result, for: MedicationRepetitionsQuestionIdentifier),
            let startDate = startDate(from: result, for: MedicationStartDateQuestionIdentifier),
            let schedule = schedule(from: result, start: startDate, repetitions: repetitions, for: MedicationDaysQuesitonIdentifier)
        else {
            return nil
        }
        
        
        let safeTitle = sanitize(title: title)
        let identifier = "BCM\(safeTitle)InterventionActivity"
        let instructions = self.text(from: result, for: MedicationInstructionsQuestionIdentifier)
        let unitDescription = self.unitDescription(from: result, for: MedicationDosageQuestionIdentifier)
        
        return OCKCarePlanActivity(identifier: identifier,
                                   groupIdentifier: MedicationActivityGroupIdentifier,
                                   type: .intervention,
                                   title: title,
                                   text: unitDescription,
                                   tintColor: UIColor.magenta,
                                   instructions: instructions,
                                   imageURL: nil,
                                   schedule: schedule,
                                   resultResettable: true,
                                   userInfo: nil)
    }
    
    static func sanitize(title: String) -> String { // NOTE: This would likely still break on various special characters
        return title
                .replacingOccurrences(of: " ", with: "-")
                .replacingOccurrences(of: "\t", with: "-")
                .replacingOccurrences(of: "\n", with: "-")
    }
    
    static func text(from taskResult: ORKTaskResult, for identifier: String) -> String? {
        return
            extract(from: taskResult, identifier: identifier, extractor: { (textResult: ORKTextQuestionResult) in
                return textResult.textAnswer
            })
    }
    
    static func repetitions(from taskResult: ORKTaskResult, for identifier: String) -> Int? {
        return
            extract(from: taskResult, identifier: identifier, extractor: { (numResult: ORKNumericQuestionResult) in
                return numResult.numericAnswer?.intValue
            })
    }
    
    static func unitDescription(from taskResult: ORKTaskResult, for identifier: String) -> String? {
        return
            extract(from: taskResult, identifier: identifier, extractor: { (numResult: ORKNumericQuestionResult) in
                guard
                    let value = numResult.numericAnswer as? Int,
                    let units = numResult.unit
                else {
                    return nil
                }
                
                return "\(value) \(units)"
            })
    }
    
    static func startDate(from taskResult: ORKTaskResult, for identifier: String) -> Date? {
        return
            extract(from: taskResult, identifier: identifier, extractor: { (dateResult: ORKDateQuestionResult) in
                return dateResult.dateAnswer
            })
    }
    
    static func schedule(from taskResult: ORKTaskResult, start: Date, repetitions: Int, for identifier: String) -> OCKCareSchedule? {
        guard
            let dayList =
            extract(from: taskResult,
                    identifier: identifier,
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
        
        let startComponents = NSDateComponents(date: start, calendar: Calendar.current) as DateComponents
        
        return OCKCareSchedule.weeklySchedule(withStartDate: startComponents,
                                              occurrencesOnEachDay: repSchedule)
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
