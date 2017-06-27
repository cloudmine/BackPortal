import UIKit

class InterventionTypeViewController: UITableViewController {
    
    var selectionCallback: ((ActivitySubtype) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            selectionCallback?(.exercise)
        case 1:
            selectionCallback?(.medication)
        default:
            break
        }
    }
}
