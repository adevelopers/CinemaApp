//
//  Animator2ViewController.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 30.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit

class CurtainView: UIView {
    var state: CurtainState = .closed
}

enum CurtainState {
    case open
    case closed
}

extension CurtainState {
    var opposite: CurtainState {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

final class Animator2ViewController: UIViewController {
    
    private lazy var curtainView: CurtainView = {
        let view = CurtainView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
        
        let vPan = UIPanGestureRecognizer(target: self, action: #selector(didSlide))
        view.addGestureRecognizer(vPan)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("View", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    
    private var animator: UIViewPropertyAnimator!
    private var isAnimatorEmpty: Bool = true
    
    private let distance: CGFloat = 400
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        layout()
        
    }
    
    private func createAnimatorIfNeeded(to state: CurtainState) {
        guard isAnimatorEmpty else {
            return
        }
        
        animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: nil)
        
        animator.addAnimations {
            switch state {
            case .open:
                self.curtainView.layer.cornerRadius = 32
                self.topConstraint.constant = -self.distance
            case .closed:
                self.curtainView.layer.cornerRadius = 0
                self.topConstraint.constant = -40
            }
            
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            switch position {
            case .start:
                self.curtainView.state = state.opposite
            case .end:
                self.curtainView.state = state
            default:
                ()
            }
            
            switch self.curtainView.state {
            case .open:
                self.topConstraint.constant = -self.distance
            case .closed:
                self.topConstraint.constant = -40
            }
            
            self.isAnimatorEmpty = true
        }
        
        isAnimatorEmpty = false
    }
    
    var topConstraint = NSLayoutConstraint()
    
    private func layout() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        curtainView.translatesAutoresizingMaskIntoConstraints = false
        curtainView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        curtainView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        curtainView.heightAnchor.constraint(equalToConstant: distance + 100).isActive = true
        
        topConstraint = curtainView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        topConstraint.isActive = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(button)
        view.addSubview(curtainView)
    }
    
    @objc
    private func didTap() {
        if curtainView.state == .closed {
            createAnimatorIfNeeded(to: curtainView.state.opposite)
            animator.pauseAnimation()
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 1.3)
        }
    }
    
    
    private var animationProgress: CGFloat = 0
    
    @objc
    private func didSlide(pan: UIPanGestureRecognizer) {
        
        switch pan.state {
        case .began:
            createAnimatorIfNeeded(to: curtainView.state.opposite)
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        case .changed:
            let translation = pan.translation(in: curtainView)
            var fraction = -translation.y / distance
            
            if (curtainView.state == .open) { fraction *= -1 }
            if (animator.isReversed) { fraction *= -1 }
            
            animator.fractionComplete = fraction + animationProgress
        case .ended:
            let shouldClose = pan.velocity(in: curtainView).y > 0
             CATransform3D()
            
//            if yVelocity == 0 {
//                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//                break
//            }
            
            switch curtainView.state {
            case .open:
                if !shouldClose && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if shouldClose && animator.isReversed { animator.isReversed = !animator.isReversed }
            case .closed:
                if shouldClose && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if !shouldClose && animator.isReversed { animator.isReversed = !animator.isReversed }
            }
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            isAnimatorEmpty = true
        default:
            ()
        }
    }

}
