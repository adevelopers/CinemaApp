//
//  CinemaHallViewController.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 31.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//
import UIKit
import SnapKit


final class CinemaHallViewController: UIViewController {
    
    private lazy var screenView: UIImageView = {
        let imageView = UIImageView() // 270x160
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var hall: CinemaHallView = {
        CinemaHallView()
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button = CinameButton(title: "Check out".uppercased())
        button.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
        button.alpha = 0
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
        
        screenView.image = UIImage(imageLiteralResourceName: "avatar_2")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animatePerspective)))
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .bg
        view.addSubview(screenView)
        view.addSubview(hall)
        view.addSubview(checkoutButton)
        
        
        screenView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(270)
            $0.height.equalTo(160)
        }
        
        hall.snp.makeConstraints {
            $0.top.equalTo(screenView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(screenView.snp.width)
            $0.height.equalTo(300)
        }
        
        checkoutButton.snp.makeConstraints {
            $0.top.equalTo(hall.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(hall.snp.width)
            $0.height.equalTo(45)
        }
    }
    
    var animationDirection: Bool = true
    
    @objc
    private func animatePerspective() {
        hall.animate(direction: animationDirection)
        
        if animationDirection {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            let angle = 60 * CGFloat.pi / 180
            let t1 = CATransform3DMakeRotation(-angle, 1, 0, 0)
            transform = CATransform3DConcat(t1, transform)
            UIView.animate(withDuration: 1, animations: {
                self.screenView.layer.transform = transform
                self.checkoutButton.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.screenView.layer.transform = CATransform3DIdentity
                self.checkoutButton.alpha = 0
            })
        }
        
        animationDirection = !animationDirection
    }
    
    
    // MARK: Chekout
    @objc
    private func didTapCheckout() {
        print("Check out")
        navigationController?.popViewController(animated: true)
    }
    
}
