import UIKit

/// A Container View Controller which automatically adjust its `safeAreaInsets` in response the
/// iOS Keyboard appearing, disapearing, and changing size.
///
/// Any child view controllers of a `KeyboardSafeAreaController` whose layouts are derrived
/// from their parent's view's safe area or layout margins will respond to and animate with the
/// iOS Keyboard on screen.
@objc(ATKeyboardSafeAreaController)
public class KeyboardSafeAreaController: UIViewController {
    private var _viewDidLoad: Bool = false
    private var _temporaryRootViewController: UIViewController?

    /// The view controller to nest within a `KeyboardSafeAreaController` to easily
    /// resize and refocus content in response to iOS Keyboard events.
    @objc public var rootViewController: UIViewController? {
        get { return childViewControllers.first }
        set {
            guard _viewDidLoad else { return _temporaryRootViewController = newValue }
            if let child = childViewControllers.first {
                child.willMove(toParentViewController: nil)
                child.view.removeFromSuperview()
                child.removeFromParentViewController()
                child.didMove(toParentViewController: nil)
            }
            if let child = newValue {
                addChildViewController(child)
                view.addSubview(child.view)
                child.view.frame = view.bounds
                child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                child.view.translatesAutoresizingMaskIntoConstraints = true
                child.didMove(toParentViewController: self)
            }
        }
    }

    /// Initialize and return a `KeyboardSafeAreaController`.
    /// - parameter rootViewController: The view controller to nest withint the new
    ///                                 `KeyboardSafeAreaController` instance.
    @objc public convenience init(rootViewController: UIViewController) {
        self.init()
        _temporaryRootViewController = rootViewController
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        _viewDidLoad = true
        additionalSafeAreaInsets = .zero
        do {
            let global = NotificationCenter.default
            global.addObserver(self, selector: #selector(self.observe(keyboard:)),
                               name: Notification.Name.UIKeyboardWillShow, object: nil)
            global.addObserver(self, selector: #selector(self.observe(keyboard:)),
                               name: Notification.Name.UIKeyboardWillHide, object: nil)
            global.addObserver(self, selector: #selector(self.observe(keyboard:)),
                               name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        }
        _temporaryRootViewController = _temporaryRootViewController.flatMap { root in
            self.rootViewController = root
            return nil
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension KeyboardSafeAreaController {
    /// Adjust any additional safe area insets to account for a displayed keyboard.
    @objc func observe(keyboard notification: NSNotification) {
        guard let info = notification.userInfo,
              let screen = view.window?.screen,
              let frame = (info[UIKeyboardFrameEndUserInfoKey] as? CGRect)
                .map({ view.convert($0, from: screen.coordinateSpace) }),
              let curve = (info[UIKeyboardAnimationCurveUserInfoKey] as? Int)
                .flatMap(UIViewAnimationCurve.init(rawValue:)),
              let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }

        // Calculate the frame of the inherited safe area—without any of our additional insets.
        let safeAreaFrame = view.bounds.inset(by: view.safeAreaInsets - additionalSafeAreaInsets)
        let overlap = safeAreaFrame.intersection(frame)

        UIView.animate(withDuration: duration) {
            UIView.setAnimationCurve(curve)
            defer { self.view.layoutIfNeeded() }
            do {
                var insets: UIEdgeInsets = .zero
                insets.bottom = overlap.isEmpty ? 0 : overlap.height
                self.additionalSafeAreaInsets = insets
            }
        }
    }
}

// MARK: Private Extensions

extension CGRect {
    func inset(by insets: UIEdgeInsets) -> CGRect {
        var rect = self
        rect.origin.x += insets.left
        rect.origin.y += insets.top
        rect.size.width -= insets.left + insets.right
        rect.size.height -= insets.top + insets.bottom
        return rect
    }
}

extension UIEdgeInsets {
    static func + (left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: left.top + right.top,
                            left: left.left + right.left,
                            bottom: left.bottom + right.bottom,
                            right: left.right + right.right)
    }

    static func - (left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: left.top - right.top,
                            left: left.left - right.left,
                            bottom: left.bottom - right.bottom,
                            right: left.right - right.right)
    }
}
