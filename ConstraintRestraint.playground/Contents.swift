
import UIKit
import XCPlayground

extension NSLayoutAttribute {
    var name: String {
        switch(self.rawValue) { // see https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutConstraint_Class/index.html#//apple_ref/c/tdef/NSLayoutAttribute
        case 0:
            return "Not an Attribute"
        case 1:
            return "Left"
        case 2:
            return "Right"
        case 3:
            return "Top"
        case 4:
            return "Bottom"
        case 5:
            return "Leading"
        case 6:
            return "Trailing"
        case 7:
            return "Width"
        case 8:
            return "Height"
        case 9:
            return "Center X"
        case 10:
            return "Center Y"
        case 11:
            return "Baseline"
        case 12:
            return "Last Baseline"
        case 13:
            return "First Baseline"
        case 14:
            return "Left Margin"
        case 15:
            return "Right Margin"
        case 16:
            return "Top Margin"
        case 17:
            return "Bottom Margin"
        case 18:
            return "Leading Margin"
        case 19:
            return "Trailing Margin"
        case 20:
            return "Center X Within Margins"
        case 21:
            return "Center Y Within Margins"
        default:
            return "Unknown"
        }
    }
}

extension NSLayoutConstraint {
    static func constraintsWithVisualFormatsAndOptions(visualFormatsAndOptions: [String: NSLayoutFormatOptions], metrics: [String: CGFloat]?, views: [String: UIView]) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        for (format, options) in visualFormatsAndOptions {
            constraints.appendContentsOf(
                NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views)
            )
        }

        return constraints
    }

    var summary: String {
        return ("\(self.firstItem.accessibilityIdentifier): \(self.firstAttribute.name) to \(self.secondItem?.accessibilityIdentifier): \(self.secondAttribute.name)")
    }
}

class CustomView: UIView {

    override init(frame: CGRect) {

        super.init(frame: frame)

        backgroundColor = .whiteColor()

        addSubview(containerView)
        containerView.addSubview(blueView)
        containerView.addSubview(redView)

        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {

        addConstraints(layoutConstraints)
        super.updateConstraints()
    }

    var layoutConstraints: [NSLayoutConstraint] {

        let formats: [String: NSLayoutFormatOptions] = [
            "H:|[redView(50)][blueView(50)]|": [.AlignAllTop, .AlignAllBottom],
            "V:|[redView(50)]|": [],
            ]

        let views = [
            "containerView": containerView,
            "redView": redView,
            "blueView": blueView,
        ]

        var constraints = NSLayoutConstraint.constraintsWithVisualFormatsAndOptions(formats, metrics: nil, views: views)

        for constraint in constraints {
            print(constraint.summary)
        }

        constraints.appendContentsOf([
            containerView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor),
            containerView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor),
            ])

        return constraints
    }

    lazy var containerView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "containerView"
        return view
    }()

    lazy var blueView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blueColor()
        view.accessibilityIdentifier = "blueView"

        return view
    }()

    lazy var redView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .redColor()
        view.accessibilityIdentifier = "redView"

        return view
    }()
}

let viewController = UIViewController()
viewController.view = CustomView(frame: UIScreen.mainScreen().bounds)

XCPlaygroundPage.currentPage.liveView = viewController
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

