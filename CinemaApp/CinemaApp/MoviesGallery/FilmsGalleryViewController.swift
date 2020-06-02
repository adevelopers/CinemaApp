//
//  ViewController.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 27.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit


class FilmsGalleryViewController: UIViewController {
    
    private weak var movies: Variable<[Movie]>!
    private var cells: Variable<[GalleryCellView]> = .init([])
    
    private var currentCellView: GalleryCellView?
    let duratioin: TimeInterval = 0.3
    
    private lazy var paginator: UIPageControl = {
        let paginator = UIPageControl()
        paginator.pageIndicatorTintColor = .note
        paginator.currentPageIndicatorTintColor = .title
        return paginator
    }()
    
    init(movies: Variable<[Movie]>) {
        self.movies = movies
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
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .bg
        
        view.addSubview(paginator)
        
        cells.accept(movies.value.map { _ in GalleryCellView() })
        
        cells.value
            .reversed().enumerated()
            .forEach { item in
                let cellView = item.element
                cellView.tag = item.offset + 1
                view.addSubview(cellView)
                
                cellView.snp.makeConstraints {
                    $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                    $0.centerX.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-160)
                }
                cellView.backgroundColor = .red
                
        }
        
        
        paginator.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
        }
        
        paginator.currentPage = 1
        paginator.numberOfPages = movies.value.count
        
        cells.subscribe { items in
            print("Кол-во: ", items.count)
        }
        
        zip(movies.value, cells.value)
            .forEach {
            $0.1.render($0.0)
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panLeft))
        pan.minimumNumberOfTouches = 1
        view.addGestureRecognizer(pan)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    @objc
    private func didTap() {
        print("did tap")
        navigationController?.pushViewController(CinemaHallViewController(), animated: true)
    }
    
    private var semaphore = 0
    private var propertyAnimator: UIViewPropertyAnimator = {
        UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: nil)
    }()
    
    func setupAnimator() {
        propertyAnimator.addAnimations(slideAnimating)
        propertyAnimator.addCompletion(didSlideEndAnimation)
    }
    
    private func dumpAnimatorState() {
        switch propertyAnimator.state  {
        case .active:
            print("State active")
        case .inactive:
            print("State inactive")
        case .stopped:
            print("State stopped")
        @unknown default:
            fatalError()
        }
        print("fraction: ", propertyAnimator.fractionComplete)
    }
    
    
    private var runningAnimators: [UIViewPropertyAnimator] = []
    private var animationProgress: CGFloat = 0
    private let distance: CGFloat = 400
    
    @objc
    private func panLeft(_ pan: UIPanGestureRecognizer) {
        print("count: \(runningAnimators.count)")
        
        switch pan.state {
        case .began:
            
            currentCellView = cells.value.first
            makeDownAnimatorIfNeeded(cellState: currentCellView!.upDnState.opposite)
            runningAnimators.forEach { animator in
                animator.pauseAnimation()
                animationProgress = animator.fractionComplete
            }
        case .changed:
            guard !runningAnimators.isEmpty else { return }
            let translation = pan.translation(in: currentCellView)
            var fraction = -translation.y / distance
            
            if (currentCellView?.upDnState == .up) { fraction *= -1 }
            if (runningAnimators[0].isReversed) { fraction *= -1 }
            
            runningAnimators.forEach { animator in
                animator.fractionComplete = fraction + animationProgress
            }
        case .ended:
            let yVelocity = pan.velocity(in: pan.view).y
            let shouldClose = yVelocity > 0
            
            
            runningAnimators.forEach { animator in
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            }
            
            if runningAnimators.isEmpty == false {
                
                switch currentCellView?.upDnState {
                case .up:
                    if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                    if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                case .dn:
                    if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                    if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                case .none:
                    ()
                }
            }
            
            runningAnimators.removeAll()
        default:
            ()
        }
        
        
    }
    
    private func makeDownAnimatorIfNeeded(cellState: CellState)  {
        
        guard runningAnimators.isEmpty else {
            return
        }
        
        let downAnimator = UIViewPropertyAnimator(duration: duratioin, curve: .easeOut, animations: nil)
        
        downAnimator.addAnimations {
            self.currentCellView?.backgroundColor = .red
            switch self.currentCellView?.upDnState {
            case .dn:
                self.currentCellView?.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-160)
                }
            case .up:
                self.currentCellView?.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(100)
                }
            default:
                ()
            }
            
            self.view.layoutIfNeeded()
        }
        
        downAnimator.addCompletion({ _ in
            self.currentCellView!.upDnState = (self.currentCellView!.upDnState == .up) ? .dn : .up
            self.runningAnimators.removeAll()
        })
        
        downAnimator.startAnimation()
        runningAnimators.append(downAnimator)
    }
    

    
    private func slideAnimating() {
        print("slide animating")
        guard let cellView = cells.value.first else {
            return
        }
        print("animating tag: ", cellView.tag)
        
        cellView.frame.origin.x -= self.view.bounds.width
        
    }
    
    private func didSlideEndAnimation(_ animatingPosition: UIViewAnimatingPosition) {
//        if !self.cells.value.isEmpty {
//
//        }
        
        switch animatingPosition {
        case .current:
            break
        case .start:
            break
        case .end:
            let cell =  self.cells.value.removeFirst()
            print("a position ->", animatingPosition)
            print("cell tag: ", cell.tag)
            self.view.sendSubviewToBack(cell)
            self.cells.value.append(cell)
            cell.center.x = self.view.center.x
            self.semaphore = 0
            propertyAnimator.stopAnimation(false)
            print("isRunning", propertyAnimator.isRunning)
        @unknown default:
            fatalError()
        }
        print("End animatiion")
    }
    
}
