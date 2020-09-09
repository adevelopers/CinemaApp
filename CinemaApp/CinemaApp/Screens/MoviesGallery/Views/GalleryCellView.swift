//
//  GalleryCellView.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 02.06.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit


enum CellState {
    case up
    case dn
}

extension CellState {
    var opposite: CellState {
        switch self {
        case .up:
            return .dn
        case .dn:
            return .up
        }
    }
}

final class GalleryCellView: UIView {
    
    var upDnState: CellState = .up
    
    lazy var screenView: UIImageView = {
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
    
    func animateDown() {
        screenView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(20)
        }
        
        movieContentView.snp.updateConstraints {
            $0.top.equalTo(screenView.snp.bottom).offset(32)
        }
    }
    
    func animateUp() {
        screenView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(90)
        }
        
        movieContentView.snp.updateConstraints {
            $0.top.equalTo(screenView.snp.bottom).offset(-32)
        }
    }
    
}
