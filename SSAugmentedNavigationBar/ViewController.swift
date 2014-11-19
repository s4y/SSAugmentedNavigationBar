import UIKit

class ViewController: UIViewController {
    
    lazy override var navigationItem = SSAugmentedNavigationItem(
        accessoryView: UISegmentedControl(items: ["Foo", "Bar", "Baz"])
    )
    
    @IBAction func addSpace() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            (self.navigationController.navigationBar as SSAugmentedNavigationBar).extraSpace += 10
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
}

