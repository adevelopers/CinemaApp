//
//  ViewController.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 27.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit


enum FilmsGalleryViewState {
    case scene1
    case scene2
}


class FilmsGalleryViewController: UIViewController {
    
    private weak var movies: Variable<[Movie]>!
    private var cells: Variable<[GalleryCellView]> = .init([])
    
    private var currentCellView: GalleryCellView?
    
    
    private lazy var topScreensLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 270, height: 160)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 53, bottom: 0, right: 0)
        return layout
    }()
    
    private lazy var topScreensSlider: UICollectionView = {
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: topScreensLayout)
        view.register(ScreenshotCell.self, forCellWithReuseIdentifier: ScreenshotCell.reusaId)
//        view.setCollectionViewLayout(topScreensLayout, animated: true)
        view.dataSource = self
        view.backgroundColor = .clear
        view.alpha = 0
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let duration: TimeInterval = 0.3
    
    private var viewState: FilmsGalleryViewState = .scene1 {
        didSet {
            viewStateDidSet()
        }
    }
    
    private func viewStateDidSet() {
        
        switch self.viewState {
        case .scene1:
            AnimatedChain(0.3) {
                self.topScreensSlider.alpha = 0
            }.then(duration: 1) {
                self.currentCellView?.screenView.isHidden = false
                self.paginator.alpha = 1
                self.topPaginator.alpha = 0
            }
            .fromFirst()
            .run()
        case .scene2:
            AnimatedChain(1) {
                self.topScreensSlider.alpha = 1
                self.paginator.alpha = 0
                self.topPaginator.alpha = 1
            }.then(duration: 0){
                self.currentCellView?.screenView.isHidden = true
            }
            .fromFirst()
            .run()
        }
        
        AnimatedChain(0.3, scene1)
            .then(duration: 0.5, scene2)
            .then(duration: 0.5, scene3)
            .then(duration: 0.5, scene4)
            .then(duration: 0.2, finalScene)
            .fromFirst()
            .run()
        
    }
    
    func scene1(){}
    func scene2(){}
    func scene3(){}
    func scene4(){}
    func finalScene(){}
    
    
    
    private lazy var paginator: PageNavigator = {
        let paginator = PageNavigator()
        return paginator
    }()
    
    private lazy var topPaginator: PageNavigator = {
        let paginator = PageNavigator()
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
        
        view.addSubview(topPaginator)
        view.addSubview(paginator)
        
        view.addSubview(topScreensSlider)
        
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
        
        topPaginator.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(197)
            $0.centerX.equalToSuperview()
        }
        
        paginator.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
        }
        
        topScreensSlider.snp.makeConstraints {
            $0.bottom.equalTo(topPaginator.snp.top).offset(3)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        paginator.currentPage = 1
        paginator.numberOfPages = movies.value.count
        
        topPaginator.currentPage = 1
        topPaginator.numberOfPages = 6
        
        cells.subscribe { items in
//            print("Кол-во: ", items.count)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        AnimationBlock(1) {
//            print("1")
//            self.cells.value[0].alpha = 0
//
//            }.add(duration: 1)  {
//                print("2")
//            self.topPaginator.alpha = 0
//        }.add(duration: 1) {
//            print("3")
//            self.paginator.alpha = 0
//        }.add(duration: 1) {
//            print("4")
//            self.cells.value[1].alpha = 0
//        }.add(duration: 2) {
//            self.cells.value[2].alpha = 0
//        }
//        .root()
//        .run()
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
    
    
    
    private func hideOtherCells() {
        cells.value.forEach {
            $0.isHidden = true
        }
        currentCellView?.isHidden = false
    }
    
    
    private var runningAnimators: [UIViewPropertyAnimator] = []
    private var animationProgress: CGFloat = 0
    private let distance: CGFloat = 400
    
    @objc
    private func panLeft(_ pan: UIPanGestureRecognizer) {
//        print("count: \(runningAnimators.count)")
        
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
        
        let downAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: nil)
        
        downAnimator.addAnimations {
            switch self.currentCellView?.upDnState {
            case .dn:
                self.viewState = .scene1
                self.currentCellView?.animateUp()
                self.currentCellView?.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-160)
                }
            case .up:
                self.viewState = .scene2
                self.hideOtherCells()
                self.currentCellView?.animateDown()
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
        
        guard let cellView = cells.value.first else {
            return
        }
        
        
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


extension FilmsGalleryViewController: UICollectionViewDataSource {
    
    private func getModel() -> Movie? {
//        guard let tag = currentCellView?.tag else { return nil }
//        let modelIndex = tag - 1
        return  movies.value.first
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movie = getModel() else { return 0 }
        return movie.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotCell.reusaId, for: indexPath) as? ScreenshotCell,
            let imageName = getModel()?.screenshots[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = UIImage(imageLiteralResourceName: imageName)
        return cell
    }
    
}
