import UIKit

class SSAugmentedNavigationItem : UINavigationItem {
    var accessoryView: UIView? = nil
    
    init(accessoryView: UIView) {
        self.accessoryView = accessoryView
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class SSAugmentedNavigationBar : UINavigationBar {
    
    var accessoryView: UIView? = nil {
        willSet {
            if let accessoryView = accessoryView {
                accessoryView.removeFromSuperview()
            }
        }
        didSet {
            if let accessoryView = accessoryView {
                accessoryView.layoutIfNeeded()
                extraSpace = accessoryView.frame.height
                addSubview(accessoryView)
                accessoryView.setTranslatesAutoresizingMaskIntoConstraints(false)
                addConstraint(NSLayoutConstraint(
                    item: accessoryView,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Bottom,
                    multiplier: 1,
                    constant: extraSpace
                    ))
                addConstraint(NSLayoutConstraint(
                    item: accessoryView,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: self,
                    attribute: .Left,
                    multiplier: 1,
                    constant: 10
                ))
            }
        }
    }

    var extraSpace: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override var items: [AnyObject]! {
        didSet {
            println("setItems \(items)")
            if let lastItem = items.last as UINavigationItem? {
                if lastItem.isKindOfClass(SSAugmentedNavigationItem) {
                    let newAccessoryView = (lastItem as SSAugmentedNavigationItem).accessoryView
                    accessoryView = newAccessoryView
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let statusBarHasHeight = UIApplication.sharedApplication().statusBarFrame.size.height != 0
        let landscape = UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
        var newFrame = frame
        newFrame.size = sizeThatFits(CGSizeZero)
        frame = newFrame
        
        layer.transform = CATransform3DMakeTranslation(0, -extraSpace + (extraSpace != 0 && landscape ? 5 : 0), 0)
        for subview in self.subviews as [UIView] {
            if (NSStringFromClass(subview.dynamicType) == "_UINavigationBarBackground") {
                var bgFrame = subview.frame
                bgFrame.origin.y = -frame.origin.y
                bgFrame.size.height = frame.size.height + (statusBarHasHeight ? 20 : 0)
                subview.frame = bgFrame
                
                var bgBounds = subview.bounds
                bgBounds.size.height = bgFrame.height
                subview.bounds = bgBounds
                break
            }
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height += extraSpace
        return size
    }
    
}