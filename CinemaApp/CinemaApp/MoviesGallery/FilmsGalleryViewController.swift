//
//  ViewController.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 27.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit


final class GalleryCellView: UIView {
    
    private lazy var screenView: UIImageView = {
        let imageView = UIImageView() // 270x160
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var movieContentView: MovieInfoView = {
        let view = MovieInfoView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        
        addSubview(movieContentView)
        addSubview(screenView)
        
    }
    private func setupConstraints() {
        
        screenView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(270)
            $0.height.equalTo(160)
        }
        
        movieContentView.snp.makeConstraints {
            $0.top.equalTo(screenView.snp.bottom).offset(-32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(270)
            $0.bottom.equalToSuperview()
        }
    }
    
    func render(_ movie: Movie) {
        if let imageName = movie.screenshots.first {
            screenView.image = UIImage(imageLiteralResourceName: imageName)
        }
        
        movieContentView.render(movie)
    }
}

class FilmsGalleryViewController: UIViewController {
    
    private weak var movies: Variable<[Movie]>!
    
    private lazy var cellView: GalleryCellView = {
        let view = GalleryCellView()
        
        return view
    }()
    
    private var cells: Variable<[GalleryCellView]> = .init([])
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .bg
        
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
                    $0.bottom.equalToSuperview().offset(-200)
                }
        }
        
        view.addSubview(paginator)
        
        
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
        
        setupAnimator()
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
    
    @objc
    private func panLeft(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: view)
//        print("point -> ", point)
        
        if point.x < view.center.x - 100 {
            pan.state = .cancelled
            dumpAnimatorState()
            
            
            if semaphore == 0 {
                print("Start animation")
                semaphore += 1
                var currentPage = paginator.currentPage
                currentPage += 1
                
                paginator.currentPage = currentPage % paginator.numberOfPages
//                propertyAnimator.fractionComplete = 0
                propertyAnimator.startAnimation()
            }
            
        } else {
            

//            propertyAnimator.fractionComplete += 0.05
//            cellView.frame.origin.x = point.x
        }
        
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
