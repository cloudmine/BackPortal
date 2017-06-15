import Foundation

func onMain(_ closure: @escaping () -> Void) {
    if Thread.current == Thread.main {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}
