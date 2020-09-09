//
//  MovieInfoView.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 28.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit


final class MovieInfoView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Ruda-Bold", size: 18)
        label.textColor = .title
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private lazy var janrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var noteLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont(name: "Ruda-Regular", size: 12)
        label.textColor = .note
//        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Ruda-Regular", size: 16)
        label.text = "3D"
        label.textColor = .note
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imdbLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Ruda-Regular", size: 12)
        label.text = "IMDB"
        label.textColor = .black
        return label
    }()
    
    private lazy var slideDownIcon: UIImageView = {
        UIImageView(image: UIImage(imageLiteralResourceName: "slideDownIcon"))
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
//        noteLabel.sizeToFit()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(janrLabel)
        addSubview(noteLabel)
        addSubview(typeLabel)
        addSubview(imdbLabel)
        addSubview(slideDownIcon)
     
        setupShadow()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowPath = UIBezierPath(ovalIn: bounds).cgPath
        layer.shadowOpacity = 0.9
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50).priority(1000)
            $0.left.equalToSuperview().offset(12)
            $0.width.equalTo(250)
            $0.height.equalTo(44)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-12)
        }
        
        imdbLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(3)
            $0.right.equalToSuperview().offset(-12)
        }
        
        janrLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(12)
            $0.width.equalTo(250)
        }
        
        noteLabel.snp.makeConstraints {
            $0.top.equalTo(janrLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        slideDownIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
        
    }
    
    func render(_ movie: Movie) {
        titleLabel.text = movie.title
        janrLabel.text = movie.janrs.joined(separator: ", ")
        noteLabel.text = movie.note
    }
    
}


extension MovieInfoView {
    
    func animateDown() {
//        noteLabel.snp.updateConstraints {
//
//        }
    }
    
    func animateUp() {
//        noteLabel.snp.updateConstraints {
//
//        }
    }
}
