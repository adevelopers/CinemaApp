//
//  AnimatorViewController.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 30.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit


final class AnimatorViewController: UIViewController {
    
    private lazy var animator: UIViewPropertyAnimator = {
        UIViewPropertyAnimator(duration: 2, curve: .easeOut, animations: nil)
    }()
    
    private lazy var sq1: UIView = {
        let view = UIView()
        view.backgroundColor = .title
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(didChageSliderPosition), for: .valueChanged)
        return slider
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.title, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchDown)
        button.backgroundColor = UIColor.title.withAlphaComponent(0.1)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.isReversed = false
        animator.addAnimations {
            self.sq1.backgroundColor = .red
        }
        animator.addAnimations {
            self.sq1.transform = CGAffineTransform.init(translationX: 600, y: 0)
            
        }
        animator.addAnimations {
            self.sq1.layer.cornerRadius = 25
            self.sq1.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        }
        
        self.sq1.transform = .identity
        
        animator.addCompletion(endAnimation)
        
        animator.startAnimation()
        animator.pauseAnimation()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(sq1)
        view.addSubview(slider)
        view.addSubview(button)
        
        sq1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-100)
            $0.width.height.equalTo(50)
        }
        
        slider.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(40)
            $0.bottom.equalTo(button.snp.top).offset(-40)
        }
        
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-100)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }
        
    }
    
    
    @objc
    private func didTap() {
        print("didTap")
        animator.isReversed = true
        
    }
    
    private func endAnimation(_ position: UIViewAnimatingPosition) {
        
        switch position {
        case .start:
            self.sq1.backgroundColor = UIColor.black
        case .current:
            self.sq1.backgroundColor = UIColor.green
        case .end:
            print("End")
            self.sq1.backgroundColor = UIColor.blue
        @unknown default:
            fatalError()
        }
    }
    
    
    @objc
    private func didChageSliderPosition() {
        print(slider.value)
        animator.fractionComplete = CGFloat(slider.value)/100
    }
    
    
}
