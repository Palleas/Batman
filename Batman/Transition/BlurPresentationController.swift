import UIKit

final class BlurPresentationController: UIPresentationController {

    private let blur: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }();
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else {
            print("No container view")
            return
        }
        
        containerView.addSubview(blur)
        
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: containerView.topAnchor),
            blur.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            blur.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            blur.rightAnchor.constraint(equalTo: containerView.rightAnchor),
        ])
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.blur.effect = UIBlurEffect(style: .dark)
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.blur.effect = nil
        }, completion: nil)
    }
}
