AdaptiveTyping
==============

`KeyboardSafeAreaController` is a container view controller that will automatically
adjust its safe area insets in response to the iOS Keyboard appearing, disappearing,
and resizing.

```swift
import AdaptiveTyping
import PlaygroundSupport
import UIKit

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

PlaygroundPage.current.liveView = KeyboardSafeAreaController(rootViewController: ViewController())
```
