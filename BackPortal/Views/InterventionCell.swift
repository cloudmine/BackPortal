import UIKit
import CareKit

class InterventionCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel?
    @IBOutlet fileprivate var subLabel: UILabel?
    @IBOutlet fileprivate var eventsStackView: UIStackView?
    
    // MARK: Public
    
    func configure(with events: [OCKCarePlanEvent]) {
        guard let activity = events.first?.activity else {
            return
        }
        
        onMain {
            self.resetStackView()
            
            self.layer.cornerRadius = 6.0
            
            self.nameLabel?.text = activity.title
            self.subLabel?.text = activity.text
            
            events.forEach { event in
                let view = UIView()
                
                let size = (self.eventsStackView?.bounds.height ?? 36.0)
                view.heightAnchor.constraint(equalToConstant: size).isActive = true
                view.widthAnchor.constraint(equalToConstant: size).isActive = true
                
                view.layer.borderWidth = 2.0
                view.layer.borderColor = activity.tintColor?.cgColor
                view.layer.cornerRadius = size / 2.0
                
                if case .completed = event.state {
                    view.backgroundColor = activity.tintColor
                }
                
                self.eventsStackView?.addArrangedSubview(view)
                print("[PORTAL] View Height: \(view.bounds.height)")
            }
            
            let spaceView = UIView()
            let size = (self.eventsStackView?.bounds.height ?? 36.0)
            spaceView.heightAnchor.constraint(equalToConstant: size).isActive = true
            spaceView.widthAnchor.constraint(greaterThanOrEqualToConstant: size).isActive = true
            spaceView.backgroundColor = UIColor.clear
            
            self.eventsStackView?.addArrangedSubview(spaceView)
        }
    }
    
    // MARK: Private
    
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
