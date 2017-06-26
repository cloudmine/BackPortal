import ResearchKit

struct NewActitiviesTasks {
    
    static var AddInterventionTask: ORKOrderedTask {
        let textAnswer = ORKTextAnswerFormat(maximumLength: 50)
        
        let textQuestion = ORKQuestionStep(identifier: "PortalAddExercieIntervention",
                                           title: NSLocalizedString("Exercise Name", comment: ""),
                                           text: NSLocalizedString("Enter the title for this exercie activity", comment: ""),
                                           answer: textAnswer)
        textQuestion.isOptional = false
        
        return ORKOrderedTask(identifier: "PortalAddInterventionActivity", steps: [textQuestion])
    }
}
