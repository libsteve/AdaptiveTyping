AdaptiveTyping
==============

`KeyboardSafeAreaController` is a container view controller that will automatically
adjust its safe area insets in response to the iOS Keyboard appearing, disappearing,
and resizing.

To use it, simply instantiate `KeyboardSafeAreaController` with a view controller
whose safe-area you want protected from the keyboard, and present that instance
as you would any other view controller. Voila! your view controller's safe-area
will resize whenever the keyboard appears, disappears, or changes in size.

```swift
import AdaptiveTyping
import PlaygroundSupport
import UIKit

PlaygroundPage.current.liveView = KeyboardSafeAreaController(rootViewController: ViewController())

class ViewController: UIViewController {
    var field: UITextField!

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        field = UITextField()
        field.translatesAutoresizingMaksIntoConstraints = false
        view.addSubview(field)

        field.text = "Apples are your friends"
        field.textAlignment = .center

        [ field.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
          field.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
          field.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor) ]
            .forEach { $0.isActive = true }

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapAway))
        view.addGestureRecognizer(tap)
    }

    @objc func didTapAway() {
        field.resignFirstResponder()
    }
}
```
