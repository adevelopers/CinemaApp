//
//  CinemaHallView.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 01.06.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit


final class CinemaHallView: UIView {
    
    let size: Int = 36
    
    private lazy var buttons: [SeatButton] = {
        var list = [SeatButton]()
        
        for c in 0...5 {
            for r in 0...6 {
                let btn = makeButton()
//                btn.setTitle("\(c*6+r)", for: .normal)
                list.append(btn)
            }
        }
        
        print("count ", list.count)
        return list
    }()
    
    private func setCorners(_ direction: Bool) {
        if direction {
            buttons[0].layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            buttons[0].layer.cornerRadius = 12
            
            buttons[6].layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            buttons[41-6].layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            buttons[41].layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            buttons[0].layer.maskedCorners = [.layerMinXMinYCorner]
            buttons[0].layer.cornerRadius = 12
            
            buttons[6].layer.maskedCorners = [.layerMaxXMinYCorner]
            buttons[6].layer.cornerRadius = 12
            
            buttons[41-6].layer.maskedCorners = [.layerMinXMaxYCorner]
            buttons[41-6].layer.cornerRadius = 12
            
            buttons[41].layer.maskedCorners = [.layerMaxXMaxYCorner]
            buttons[41].layer.cornerRadius = 12
        }
    }
    
    private func makeButton() -> SeatButton {
        let button = SeatButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        button.backgroundColor = .white
        return button
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AVATAR"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .title
        return label
    }()
    
    private var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Джейк Салли - бывший морской пехотинец, прикованный к инвалидному креслу. Несмотря на немощное тело, Джейк в душе по-прежнему остается воином. Он получает задание совершить путешествие в несколько световых лет к базе землян на планете Пандора, где корпорации добывают редкий минерал, имеющий огромное значение для выхода Земли из энергетического кризиса."
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let initX = 8
        var x: Int = initX
        var y = 0
        for button in buttons {
            button.frame.origin = CGPoint(x: x, y: y)
            x += size
            if (x > (size*6 + initX) ) {
                x = initX
                y += size
            }
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        clipsToBounds = true
        
        
        buttons.forEach {
            addSubview($0)
        }
        
        addSubview(titleLabel)
        addSubview(noteLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.right.equalToSuperview().inset(32)
            $0.height.equalTo(22)
        }
        
        noteLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-42)
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        setCorners(false)
        disableSeats(isDisable: true)
    }
    
    private func disableSeats(isDisable: Bool) {
        buttons.forEach {
            $0.isEnabled = !isDisable
        }
    }

    func animate(direction: Bool) {
        UIView.animate(withDuration: 1, animations: {
            
            self.setSold(direction)
            
            let size = self.size
            if direction {
                self.titleLabel.alpha = 0
                self.noteLabel.alpha = 0
                self.buttons.forEach {
                    $0.layer.cornerRadius = 12
                    $0.frame.size = CGSize(width: size - 3, height: size - 3)
                }
                
            } else {
                self.titleLabel.alpha = 1
                self.noteLabel.alpha = 1
                self.buttons.forEach {
                    $0.layer.cornerRadius = 0
                    $0.frame.size = CGSize(width: size , height: size)
                }
            }
            
            self.setCorners(direction)
        })
        disableSeats(isDisable: !direction)
    }
    
    private func setSold(_ direction: Bool) {
        if direction {
            buttons[9].seatState = .sold
            buttons[15].seatState = .sold
            buttons[16].seatState = .sold
            buttons[17].seatState = .sold
            buttons[29].seatState = .sold
        } else {
            buttons.forEach {
                $0.seatState = .free
            }
        }
    }
}

