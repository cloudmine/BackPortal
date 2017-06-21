import UIKit
import CareKit

let ActivityCellCornerRadius = 6.0 as CGFloat

typealias InterventionEventTapCallback = (OCKCarePlanEvent) -> Void

class InterventionCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    @IBOutlet fileprivate var subLabel: UILabel?
    @IBOutlet fileprivate var eventsStackView: UIStackView?
    
    // MARK: Private Properties
    
    fileprivate var events: [OCKCarePlanEvent] = []
    fileprivate var tapCallback: InterventionEventTapCallback? = nil
    
    // MARK: Public
    
    func configure(with eventList: [OCKCarePlanEvent], tapBack: InterventionEventTapCallback?) {
        self.events = eventList
        self.tapCallback = tapBack
        
        guard let activity = events.first?.activity else {
            return
        }
        
        onMain {
            self.resetStackView()
            
            self.layer.cornerRadius = ActivityCellCornerRadius
            
            self.nameLabel?.text = activity.title
            self.subLabel?.text = activity.text
            
            self.events.forEach { event in
                let button = self.button(for: event, color: activity.tintColor)
                self.eventsStackView?.addArrangedSubview(button)
            }
            
            let spaceView = UIView()
            let size = (self.eventsStackView?.bounds.height ?? 36.0)
            spaceView.heightAnchor.constraint(equalToConstant: size).isActive = true
            spaceView.widthAnchor.constraint(greaterThanOrEqualToConstant: size).isActive = true
            spaceView.backgroundColor = UIColor.clear
            
            self.eventsStackView?.addArrangedSubview(spaceView)
        }
    }
}

// MARK: Private

fileprivate extension InterventionCell {
    
    func button(for event: OCKCarePlanEvent, color tintColor: UIColor?) -> UIButton {
        let button = UIButton()
        
        button.tag = Int(event.occurrenceIndexOfDay)
        button.addTarget(self, action: #selector(self.didPress(eventButton:)), for: .touchUpInside)
        
        let size = (self.eventsStackView?.bounds.height ?? 36.0)
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        
        button.layer.borderWidth = 2.0
        button.layer.borderColor = tintColor?.cgColor
        button.layer.cornerRadius = size / 2.0
        
        if case .completed = event.state {
            button.backgroundColor = tintColor
        }
        
        return button
    }
    
    @objc func didPress(eventButton: UIButton) {
        guard eventButton.tag < events.count else {
            return
        }
        
        tapCallback?(events[eventButton.tag])
    }
    
    func resetStackView() {
        guard let eventsStackView = eventsStackView else {
            return
        }
        
        while eventsStackView.arrangedSubviews.count > 0 {
            eventsStackView.arrangedSubviews[0].removeFromSuperview()
            //eventsStackView.removeArrangedSubview(eventsStackView.arrangedSubviews[0])
        }
    }
}
