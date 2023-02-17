//
//  MainVC.swift
//  Tennis Сounter
//
//  Created by Dmitriy on 2/15/23.
//

import UIKit
import RealmSwift

protocol MainVCDelegate: AnyObject {
    func changeButton()
}

class MainVC: UIViewController, MainVCDelegate {
    
    let defaults = UserDefaults.standard
    var hapticFeedbackOn = false
    var rotateOn = false
    let generator = UINotificationFeedbackGenerator()
    var topView = UIView()
    var bottomView = UIView()
    var topLabel = UILabel()
    var topPlayerLabel = UILabel()
    var bottomLabel = UILabel()
    var bottomPlayerLabel = UILabel()
    
    var fiveSetButton = UIButton()
    var threeSetButton = UIButton()
    var gameScore1 = UILabel()
    var gameScore2 = UILabel()
    var setScore1 = UILabel()
    var setScore2 = UILabel()
    var gameLabel = UILabel()
    var nextSetButton = UIButton()
    let realm = try! Realm()
    
    var changed = true
    var isFirstTime = true
    
    var player1SetScore = 0
    var player2SetScore = 0
    var player1GameScore = 0
    var player2GameScore = 0
    var player1Points = 0
    var player2Points = 0
    var totalSets = 0
    var curGame = 1
    var curSet = 0
    var player1Advantage = false
    var player2Advantage = false
    var gameInProgress = false
    var setInProgress = false
    
    var scores = [0: 0, 1: 15, 2: 30, 3: 40]
    
    var matchEntity = MatchEntity()
    var prevMatchEntity = MatchEntity()
    var setEntity = SetEntity()
    var gameEntity = GameEntity()
    
    
    @available(iOS, deprecated: 15.0, message: "To silence the warnings")
    override func viewDidLoad() {
        super.viewDidLoad()
        hapticFeedbackOn = defaults.bool(forKey: "hapticFeedbackOn")
        totalSets = defaults.integer(forKey: "totalSets") == 0 ? 5 : defaults.integer(forKey: "totalSets")
        rotateOn = defaults.bool(forKey: "rotateOn")
        //1
        topView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.height * 0.40962441314)
        topView.backgroundColor = .clear
        if rotateOn {
            topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(player1Scored)))
        } else {
            topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(player2Scored)))
        }
        var gradientLayer = CAGradientLayer()
        gradientLayer.frame = topView.bounds
        gradientLayer.colors = [UIColor(red: 0, green: 0.45, blue: 0.55, alpha: 1).cgColor, UIColor(red: 0.004, green: 0.066, blue: 0.224, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        topView.layer.addSublayer(gradientLayer)
        view.addSubview(topView)
        view.sendSubviewToBack(topView)
        
        //2
        bottomView.frame = CGRect(x: 0, y: 0.35446009389 * view.frame.height, width: view.bounds.width, height: view.frame.height * 0.47652582159)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bottomView.bounds
        gradientLayer.colors = [UIColor(red: 0, green: 0.458, blue: 0.545, alpha: 1).cgColor, UIColor(red: 0.004, green: 0.066, blue: 0.224, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        if rotateOn {
            bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(player2Scored)))
        } else {
            bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(player1Scored)))
        }
        let rotationTransform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        gradientLayer.transform = rotationTransform
        
        bottomView.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(bottomView)
        
        //3
        var boxView = UIView()
        boxView.frame = CGRect(x: -1, y: 0.33920187793 * view.frame.height, width: view.bounds.width + 2, height: view.frame.height * 0.07042253521)
        boxView.backgroundColor = UIColor(red: 0, green: 0.063, blue: 0.255, alpha: 1)
        boxView.layer.borderWidth = 1
        boxView.layer.borderColor = UIColor.white.cgColor
        boxView.layer.masksToBounds = true
        view.addSubview(boxView)
        
        
        //4
        boxView = UIView()
        boxView.frame = CGRect(x: -1, y: 0.72535211267 * view.frame.height, width: view.bounds.width + 2, height: 0.31103286385 * view.frame.height)
        boxView.backgroundColor = UIColor(red: 0, green: 0.063, blue: 0.255, alpha: 1)
        boxView.layer.borderWidth = 1
        boxView.layer.borderColor = UIColor.white.cgColor
        boxView.layer.shadowColor = UIColor.black.cgColor
        boxView.layer.shadowOffset = CGSize(width: 0, height: -5)
        boxView.layer.shadowOpacity = 0.5
        boxView.layer.cornerRadius = 25
        boxView.layer.masksToBounds = true
        view.addSubview(boxView)
        
        //label1
        var label = UILabel()
        label.text = "00"
        label.font = UIFont(name: "PASTI", size: 150)
        label.textAlignment = .center
        label.textColor = UIColor.white
        if rotateOn {
            gameScore1 = label
            view.addSubview(gameScore1)
            gameScore1.translatesAutoresizingMaskIntoConstraints = false
            gameScore1.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.06455399061 * view.frame.height).isActive = true
            gameScore1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            gameScore2 = label
            view.addSubview(gameScore2)
            gameScore2.translatesAutoresizingMaskIntoConstraints = false
            gameScore2.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.06455399061 * view.frame.height).isActive = true
            gameScore2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        //label2
        label = UILabel()
        if rotateOn {
            label.text = "PLAYER 1"
        } else {
            label.text = "PLAYER 2"
        }
        label.font = UIFont(name: "PASTI", size: 24)
        label.textAlignment = .center
        label.textColor = UIColor.white
        topPlayerLabel = label
        view.addSubview(topPlayerLabel)
        topPlayerLabel.translatesAutoresizingMaskIntoConstraints = false
        topPlayerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topPlayerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.25821596244 * view.frame.height).isActive = true
        
        //label3
        label = UILabel()
        label.text = "GAME 1"
        label.font = UIFont(name: "PASTI", size: 22)
        label.textColor = UIColor.white
        label.textAlignment = .center
        gameLabel = label
        view.addSubview(gameLabel)
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.36384976525 * view.frame.height).isActive = true
        gameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //label4
        label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "PASTI", size: 41)
        label.textColor = UIColor(red: 0.12, green: 1.0, blue: 1.0, alpha: 1.0)
        setScore1 = label
        view.addSubview(setScore1)
        setScore1.translatesAutoresizingMaskIntoConstraints = false
        setScore1.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.35446009389 * view.frame.height).isActive = true
        setScore1.trailingAnchor.constraint(equalTo: gameLabel.leadingAnchor, constant: -30).isActive = true
        
        //label5
        label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "PASTI", size: 41)
        label.textColor = UIColor(red: 0.12, green: 1.0, blue: 1.0, alpha: 1.0)
        setScore2 = label
        view.addSubview(setScore2)
        setScore2.translatesAutoresizingMaskIntoConstraints = false
        setScore2.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.35446009389 * view.frame.height).isActive = true
        setScore2.trailingAnchor.constraint(equalTo: gameLabel.trailingAnchor, constant: 52).isActive = true
        
        //label6
        label = UILabel()
        if rotateOn {
            label.text = "PLAYER 2"
        } else {
            label.text = "PLAYER 1"
        }
        label.font = UIFont(name: "PASTI", size: 24)
        label.textAlignment = .center
        label.textColor = UIColor.white
        bottomPlayerLabel = label
        view.addSubview(bottomPlayerLabel)
        bottomPlayerLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomPlayerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomPlayerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.46596244131 * view.frame.height).isActive = true
        
        //label7
        label = UILabel()
        label.text = "00"
        label.font = UIFont(name: "PASTI", size: 150)
        label.textAlignment = .center
        label.textColor = UIColor.white
        if rotateOn {
            gameScore2 = label
            view.addSubview(gameScore2)
            gameScore2.translatesAutoresizingMaskIntoConstraints = false
            gameScore2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            gameScore2.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.52464788732 * view.frame.height).isActive = true
        } else {
            gameScore1 = label
            view.addSubview(gameScore1)
            gameScore1.translatesAutoresizingMaskIntoConstraints = false
            gameScore1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            gameScore1.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.52464788732 * view.frame.height).isActive = true
        }
        
        //button1
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0.8117048346 * view.frame.width, y: 0.36854460093 * view.frame.height, width: 70, height: 10)
        button.setTitle("NEXT SET", for: .normal)
        button.titleLabel?.font = UIFont(name: "PASTI", size: 12)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.setImage(UIImage(named: "next"), for: .normal)
        nextSetButton.contentVerticalAlignment = .top
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.imageEdgeInsets.bottom = 2
        button.imageEdgeInsets.left = 5
        nextSetButton = button
        view.addSubview(nextSetButton)
        
        //button2
        button = UIButton(type: .system)
        button.frame = CGRect(x: 0.05089058524 * view.frame.width, y: 0.76643192488 * view.frame.height, width: 23, height: 24)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(showSaved), for: .touchUpInside)
        view.addSubview(button)
        
        //button3
        button = UIButton(type: .system)
        button.tintColor = .white
        button.frame = CGRect(x: 0.79643765903 * view.frame.width, y: 0.76643192488 * view.frame.height, width: 24, height: 20)
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.addTarget(self, action: #selector(handleSett), for: .touchUpInside)
        view.addSubview(button)
        
        //button4
        button = UIButton(type: .system)
        button.tintColor = .white
        button.frame = CGRect(x: 0.89058524173 * view.frame.width, y: 0.76643192488 * view.frame.height, width: 24, height: 20)
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.addTarget(self, action: #selector(startOver), for: .touchUpInside)
        view.addSubview(button)
        
        
        //5
        let vieww = UIView(frame: CGRect(x: 0.33333333333 * view.frame.width, y: 0.90375586854 * view.frame.height, width: 128.33, height: 35))
        vieww.backgroundColor = UIColor(red: 0.11, green: 1, blue: 1, alpha: 1)
        vieww.layer.borderWidth = 1
        vieww.layer.borderColor = UIColor.white.cgColor
        vieww.layer.cornerRadius = 17
        vieww.clipsToBounds = true
        vieww.layer.masksToBounds = true
        view.addSubview(vieww)
        
        
        //button5
        fiveSetButton = UIButton(type: .custom)
        fiveSetButton.frame = CGRect(x: 0.33842239185 * self.view.frame.width, y: 0.90692488262 * self.view.frame.height, width: 60, height: 29)
        fiveSetButton.setTitle("5", for: .normal)
        fiveSetButton.titleLabel?.font = UIFont(name: "PASTI", size: 22)
        fiveSetButton.titleLabel?.textAlignment = .center
        fiveSetButton.setTitleColor(UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1), for: .normal)
        fiveSetButton.contentVerticalAlignment = .bottom
        fiveSetButton.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
        fiveSetButton.layer.cornerRadius = 14
        fiveSetButton.addTarget(self, action: #selector(fiveSetButtonTapped), for: .touchUpInside)
        self.view.addSubview(fiveSetButton)
        
        //button6
        threeSetButton = UIButton(type: .custom)
        threeSetButton.frame = CGRect(x: 0.50127226463 * self.view.frame.width, y: 0.90692488262 * self.view.frame.height, width: 60, height: 29)
        threeSetButton.setTitle("3", for: .normal)
        threeSetButton.contentVerticalAlignment = .bottom
        threeSetButton.titleLabel?.textAlignment = .center
        threeSetButton.titleLabel?.font = UIFont(name: "PASTI", size: 22)
        threeSetButton.setTitleColor(UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1), for: .normal)
        threeSetButton.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
        threeSetButton.layer.cornerRadius = 14
        threeSetButton.addTarget(self, action: #selector(threeSetButtonTapped), for: .touchUpInside)
        self.view.addSubview(threeSetButton)
        
        if totalSets == 3 {
            threeSetButtonTapped()
        } else {
            fiveSetButtonTapped()
        }
    }
    
    @objc func fiveSetButtonTapped() {
        defaults.set(5, forKey: "totalSets")
        totalSets = 5
        if fiveSetButton.isSelected && !threeSetButton.isSelected {
            changed = false
        } else {
            changed = true
        }
        fiveSetButton.isSelected = true
        threeSetButton.isSelected = false
        
        fiveSetButton.backgroundColor = UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1)
        fiveSetButton.layer.borderColor = UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1).cgColor
        fiveSetButton.setTitleColor(.white, for: .normal)
        threeSetButton.setTitleColor(UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1), for: .normal)
        threeSetButton.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
        
        if changed {
            curGame = 0
            player1Points = 0
            player1GameScore = 0
            player1SetScore = 0
            player2Points = 0
            player2GameScore = 0
            player2SetScore = 0
            gameLabel.text = "GAME 1"
            gameScore1.text = "00"
            gameScore2.text = "00"
            setScore1.text = "0"
            setScore2.text = "0"
            matchEntity = MatchEntity()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mma"
            matchEntity.time = dateFormatter.string(from: Date())
            setEntity = SetEntity()
            gameEntity = GameEntity()
            if !isFirstTime {
                if hapticFeedbackOn {
                    generator.notificationOccurred(.success)
                }
                for _ in 1...18 {
                    view.subviews[view.subviews.count - 1].removeFromSuperview()
                }
            }
            isFirstTime = false
            for i in 0..<5 {
                let view1 = UIView()
                view1.frame = CGRect(x: 0.03053435114 * view.frame.width + CGFloat(74 * i), y: 0.81220657277 * view.frame.height, width: 70, height: 60)
                view1.layer.borderWidth = 1
                view1.layer.borderColor = i <= curSet ? UIColor.white.cgColor : UIColor.white.withAlphaComponent(0.4).cgColor
                view1.layer.cornerRadius = 5
                view.addSubview(view1)
            }
            
            for i in 0..<5 {
                var label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.81924882629 * view.frame.height, width: 35, height: 13)
                label.text = "SETS \(i + 1)"
                label.font = UIFont(name: "PASTI", size: 12)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 27, height: 9)
                label.text = "PLAYER 1"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.12468193384 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 29, height: 9)
                label.text = "PLAYER 2"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.05597964376 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i == curSet ? "\(player1GameScore)" : "-"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.15521628498 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i == curSet ? "\(player2GameScore)" : "-"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
            }
        }
    }
    
    @objc func threeSetButtonTapped() {
        defaults.set(3, forKey: "totalSets")
        totalSets = 3
        if !fiveSetButton.isSelected && threeSetButton.isSelected {
            changed = false
        } else {
            changed = true
        }
        fiveSetButton.isSelected = false
        threeSetButton.isSelected = true
        
        threeSetButton.backgroundColor = UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1)
        threeSetButton.layer.borderColor = UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1).cgColor
        threeSetButton.setTitleColor(.white, for: .normal)
        fiveSetButton.setTitleColor(UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1), for: .normal)
        fiveSetButton.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
        
        if changed {
            curGame = 0
            player1Points = 0
            player1GameScore = 0
            player1SetScore = 0
            player2Points = 0
            player2GameScore = 0
            player2SetScore = 0
            gameLabel.text = "GAME 1"
            gameScore1.text = "00"
            gameScore2.text = "00"
            setScore1.text = "0"
            setScore2.text = "0"
            matchEntity = MatchEntity()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mma"
            matchEntity.time = dateFormatter.string(from: Date())
            setEntity = SetEntity()
            gameEntity = GameEntity()
            if !isFirstTime {
                if hapticFeedbackOn {
                    generator.notificationOccurred(.success)
                }
                for _ in 1...30 {
                    view.subviews[view.subviews.count - 1].removeFromSuperview()
                }
            }
            isFirstTime = false
            for i in 1..<4 {
                let view1 = UIView()
                view1.frame = CGRect(x: 0.03053435114 * view.frame.width + CGFloat(74 * i), y: 0.81220657277 * view.frame.height, width: 70, height: 60)
                view1.layer.borderWidth = 1
                view1.layer.borderColor = i <= curSet + 1 ? UIColor.white.cgColor : UIColor.white.withAlphaComponent(0.4).cgColor
                view1.layer.cornerRadius = 5
                view.addSubview(view1)
            }
            
            for i in 1..<4 {
                var label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.81924882629 * view.frame.height, width: 35, height: 13)
                label.text = "SETS \(i)"
                label.font = UIFont(name: "PASTI", size: 12)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                //label9
                label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 27, height: 9)
                label.text = "PLAYER 1"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                //label10
                label = UILabel()
                label.frame = CGRect(x: 0.12468193384 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 29, height: 9)
                label.text = "PLAYER 2"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                //label11
                label = UILabel()
                label.frame = CGRect(x: 0.05597964376 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i == 1 ? "0" : "-"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                //label12
                label = UILabel()
                label.frame = CGRect(x: 0.15521628498 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i == 1 ? "0" : "-"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
            }
        }
    }
    
    @objc func handleSett() {
        let settVC = SettVC()
        settVC.modalPresentationStyle = .fullScreen
        present(settVC, animated: true)
    }
    
    @objc func player1Scored(_ sender: Any) {
        if !gameInProgress {
            gameInProgress = true
        }
        player1Points += 1
        updateScore()
    }
    
    @objc func player2Scored(_ sender: Any) {
        if !gameInProgress {
            gameInProgress = true
        }
        player2Points += 1
        updateScore()
    }
    
    func updateScore() {
        if player1Points >= 4 && player1Points >= player2Points + 2 {
            // player 1 wins the game
            curGame += 1
            player1GameScore += 1
            
            gameEntity.player1GameScore = player1GameScore
            gameEntity.player2GameScore = player2GameScore
            gameEntity.gameInProgress = false
            setEntity.games.append(gameEntity)
            gameEntity = GameEntity()
            
            player1Points = 0
            player2Points = 0
            player1Advantage = false
            player2Advantage = false
            gameInProgress = false
            
            redraw()
        } else if player2Points >= 4 && player2Points >= player1Points + 2 {
            // player 2 wins the game
            curGame += 1
            player2GameScore += 1
            
            gameEntity.player1GameScore = player1GameScore
            gameEntity.player2GameScore = player2GameScore
            gameEntity.gameInProgress = false
            setEntity.games.append(gameEntity)
            gameEntity = GameEntity()
            
            player1Points = 0
            player2Points = 0
            player1Advantage = false
            player2Advantage = false
            gameInProgress = false
            
            redraw()
        } else if player1Points == 3 && player2Points == 3 {
            // deuce
            player1Advantage = true
            player2Advantage = true
        } else if player1Points == 4 && player2Points == 3 {
            // advantage player 1
            player1Advantage = true
            player2Advantage = false
        } else if player1Points == 3 && player2Points == 4 {
            // advantage player 2
            player1Advantage = false
            player2Advantage = true
        } else {
            player1Advantage = false
            player2Advantage = false
        }
        
        // update game score labels
        gameScore1.text = scores[player1Points] != nil && scores[player1Points] != 0 ? "\(scores[player1Points] ?? 0)" : "00"
        gameScore2.text = scores[player2Points] != nil && scores[player2Points] != 0 ? "\(scores[player2Points] ?? 0)" : "00"
        if player1Advantage {
            gameScore1.text = "AD"
        }
        if player2Advantage {
            gameScore2.text = "AD"
        }
        gameLabel.text = "GAME \(curGame)"
        
        if player1GameScore >= 6 && player1GameScore >= player2GameScore + 2 {
            // player 1 wins the set
            curSet += 1
            player1SetScore += 1
            
            setEntity.player1SetScore = player1SetScore
            setEntity.player2SetScore = player2SetScore
            matchEntity.sets.append(setEntity)
            setEntity = SetEntity()
            
            player1GameScore = 0
            player2GameScore = 0
            gameInProgress = false
            setInProgress = false
            
            redraw()
        } else if player2GameScore >= 6 && player2GameScore >= player1GameScore + 2 {
            // player 2 wins the set
            curSet += 1
            player2SetScore += 1
            
            setEntity.player1SetScore = player1SetScore
            setEntity.player2SetScore = player2SetScore
            matchEntity.sets.append(setEntity)
            setEntity = SetEntity()
            
            player1GameScore = 0
            player2GameScore = 0
            gameInProgress = false
            setInProgress = false
            
            redraw()
        } else if player1GameScore == 6 && player2GameScore == 6 {
            // tiebreak
            if !gameInProgress && !setInProgress {
                gameInProgress = true
                setInProgress = true
                player1GameScore = 6
                player2GameScore = 6
                player1Points = 0
                player2Points = 0
            } else if player1Points >= 7 && player1Points >= player2Points + 2 {
                // player 1 wins the tiebreak
                curSet += 1
                player1SetScore += 1
                
                setEntity.player1SetScore = player1SetScore
                setEntity.player2SetScore = player2SetScore
                matchEntity.sets.append(setEntity)
                setEntity = SetEntity()
                
                player1GameScore = 0
                player2GameScore = 0
                player1Points = 0
                player2Points = 0
                gameInProgress = false
                setInProgress = false
                
                redraw()
            } else if player2Points >= 7 && player2Points >= player1Points + 2 {
                // player 2 wins the tiebreak
                curSet += 1
                player2SetScore += 1
                
                setEntity.player1SetScore = player1SetScore
                setEntity.player2SetScore = player2SetScore
                matchEntity.sets.append(setEntity)
                setEntity = SetEntity()
                
                player1GameScore = 0
                player2GameScore = 0
                player1Points = 0
                player2Points = 0
                gameInProgress = false
                setInProgress = false
                
                redraw()
            }
        }
        
        // update set score labels
        setScore1.text = "\(player1GameScore)"
        setScore2.text = "\(player2GameScore)"
        
        if totalSets == curSet && player1SetScore > player2SetScore {
            // player 1 wins the match
            nextSetButton.setTitle("SAVE MATCH", for: .normal)
            let vc = ResultVC()
            vc.delegate = self
            vc.matchEntity = matchEntity
            vc.winner = 1
            vc.totalSets = totalSets
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mma"
            matchEntity.time += " - " + dateFormatter.string(from: Date())
            prevMatchEntity = matchEntity
            
            matchEntity = MatchEntity()
            dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mma"
            matchEntity.time = dateFormatter.string(from: Date())
        } else if totalSets == curSet && player2SetScore > player1SetScore {
            // player 2 wins the match
            nextSetButton.setTitle("SAVE MATCH", for: .normal)
            let vc = ResultVC()
            vc.delegate = self
            vc.matchEntity = matchEntity
            vc.winner = 2
            vc.totalSets = totalSets
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
            
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mma"
            matchEntity.time += " - " + dateFormatter.string(from: Date())
            prevMatchEntity = matchEntity
            
            matchEntity = MatchEntity()
            dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mma"
            matchEntity.time = dateFormatter.string(from: Date())
        }
    }
    
    func redraw() {
        if fiveSetButton.isSelected {
            for _ in 1...30 {
                view.subviews[view.subviews.count - 1].removeFromSuperview()
            }
            for i in 0..<5 {
                let view1 = UIView()
                view1.frame = CGRect(x: 0.03053435114 * view.frame.width + CGFloat(74 * i), y: 0.81220657277 * view.frame.height, width: 70, height: 60)
                view1.layer.borderWidth = 1
                view1.layer.borderColor = i <= curSet ? UIColor.white.cgColor : UIColor.white.withAlphaComponent(0.4).cgColor
                view1.layer.cornerRadius = 5
                view.addSubview(view1)
            }
            
            for i in 0..<5 {
                var label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.81924882629 * view.frame.height, width: 35, height: 13)
                label.text = "SETS \(i + 1)"
                label.font = UIFont(name: "PASTI", size: 12)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                
                //label9
                label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 27, height: 9)
                label.text = "PLAYER 1"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                
                //label10
                label = UILabel()
                label.frame = CGRect(x: 0.12468193384 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 29, height: 9)
                label.text = "PLAYER 2"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                //label11
                label = UILabel()
                label.frame = CGRect(x: 0.05597964376 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i == curSet ? "\(player1GameScore)" : i > matchEntity.sets.count ? "-" : "\(matchEntity.sets[i].games.last?.player1GameScore ?? 0)"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                
                view.addSubview(label)
                
                //label12
                label = UILabel()
                label.frame = CGRect(x: 0.15521628498 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i == curSet ? "\(player2GameScore)" : i > matchEntity.sets.count ? "-" : "\(matchEntity.sets[i].games.last?.player2GameScore ?? 0)"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = i <= curSet ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
            }
        } else {
            for _ in 1...18 {
                view.subviews[view.subviews.count - 1].removeFromSuperview()
            }
            
            for i in 1..<4 {
                let view1 = UIView()
                view1.frame = CGRect(x: 0.03053435114 * view.frame.width + CGFloat(74 * i), y: 0.81220657277 * view.frame.height, width: 70, height: 60)
                view1.layer.borderWidth = 1
                view1.layer.borderColor = i <= curSet + 1 ? UIColor.white.cgColor : UIColor.white.withAlphaComponent(0.4).cgColor
                view1.layer.cornerRadius = 5
                view.addSubview(view1)
            }
            
            for i in 1..<4 {
                var label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.81924882629 * view.frame.height, width: 35, height: 13)
                label.text = "SETS \(i)"
                label.font = UIFont(name: "PASTI", size: 12)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                
                label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 27, height: 9)
                label.text = "PLAYER 1"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.12468193384 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 29, height: 9)
                label.text = "PLAYER 2"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.05597964376 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i == curSet + 1 ? "\(player1GameScore)" : i - 1 > matchEntity.sets.count ? "-" : "\(matchEntity.sets[i - 1].games.last?.player1GameScore ?? 0)"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.15521628498 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i == curSet + 1 ? "\(player2GameScore)" : i - 1 > matchEntity.sets.count ? "-" : "\(matchEntity.sets[i - 1].games.last?.player2GameScore ?? 0)"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = i <= curSet + 1 ? UIColor.white : UIColor.white.withAlphaComponent(0.4)
                view.addSubview(label)
            }
        }
    }
    @objc func nextTapped() {
        if hapticFeedbackOn {
            generator.notificationOccurred(.success)
        }
        if nextSetButton.title(for: .normal) == "NEXT SET" {
            if (player1Points != player2Points) {
                if player1Points > player2Points {
                    // player 1 wins the game
                    player1GameScore += 1
                    
                    gameEntity.player1GameScore = player1GameScore
                    gameEntity.player2GameScore = player2GameScore
                    gameEntity.gameInProgress = false
                    setEntity.games.append(gameEntity)
                    gameEntity = GameEntity()
                } else if player2Points > player1Points {
                    // player 2 wins the game
                    player2GameScore += 1
                    
                    gameEntity.player1GameScore = player1GameScore
                    gameEntity.player2GameScore = player2GameScore
                    gameEntity.gameInProgress = false
                    setEntity.games.append(gameEntity)
                    gameEntity = GameEntity()
                } else if player1Points == player2Points {
                    // deuce
                    player1Advantage = true
                    player2Advantage = true
                } else if player1Points == 4 && player2Points == 3 {
                    // advantage player 1
                    player1Advantage = true
                    player2Advantage = false
                } else if player1Points == 3 && player2Points == 4 {
                    // advantage player 2
                    player1Advantage = false
                    player2Advantage = true
                } else {
                    player1Advantage = false
                    player2Advantage = false
                }
                
                gameLabel.text = "GAME \(curGame)"
                
                if player1GameScore > player2GameScore {
                    // player 1 wins the set
                    player1SetScore += 1
                    curSet += 1
                    gameInProgress = false
                    setInProgress = false
                    
                    setEntity.player1SetScore = player1SetScore
                    setEntity.player2SetScore = player2SetScore
                    matchEntity.sets.append(setEntity)
                    setEntity = SetEntity()
                } else if player2GameScore > player1GameScore {
                    // player 2 wins the set
                    player2SetScore += 1
                    curSet += 1
                    gameInProgress = false
                    setInProgress = false
                    
                    setEntity.player1SetScore = player1SetScore
                    setEntity.player2SetScore = player2SetScore
                    matchEntity.sets.append(setEntity)
                    setEntity = SetEntity()
                }
                
                // update set score labels
                setScore1.text = "0"
                setScore2.text = "0"
                
                if totalSets == curSet && player1SetScore > player2SetScore {
                    // player 1 wins the match
                    nextSetButton.setTitle("SAVE MATCH", for: .normal)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, h:mma"
                    matchEntity.time += " - " + dateFormatter.string(from: Date())
                    prevMatchEntity = matchEntity
                    
                    let vc = ResultVC()
                    vc.delegate = self
                    vc.winner = 1
                    vc.matchEntity = matchEntity
                    vc.totalSets = totalSets
                    vc.modalPresentationStyle = .overCurrentContext
                    present(vc, animated: true, completion: nil)
                } else if totalSets == curSet && player2SetScore > player1SetScore {
                    // player 2 wins the match
                    nextSetButton.setTitle("SAVE MATCH", for: .normal)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, h:mma"
                    matchEntity.time += " - " + dateFormatter.string(from: Date())
                    prevMatchEntity = matchEntity
                    
                    let vc = ResultVC()
                    vc.delegate = self
                    vc.matchEntity = matchEntity
                    vc.winner = 2
                    vc.totalSets = totalSets
                    vc.modalPresentationStyle = .overCurrentContext
                    present(vc, animated: true, completion: nil)
                }
                
                gameScore1.text = "00"
                gameScore2.text = "00"
                curGame += 1
                player1Points = 0
                player2Points = 0
                player1GameScore = 0
                player2GameScore = 0
                redraw()
                if totalSets == curSet && player1SetScore > player2SetScore || totalSets == curSet && player1SetScore > player2SetScore {
                    matchEntity = MatchEntity()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, h:mma"
                    matchEntity.time = dateFormatter.string(from: Date())
                }
            }
        } else {
            try! realm.write {
                realm.add(prevMatchEntity)
            }
            nextSetButton.setTitle("NEXT SET", for: .normal)
            startOver()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hapticFeedbackOn = defaults.bool(forKey: "hapticFeedbackOn")
        if rotateOn != defaults.bool(forKey: "rotateOn") {
            rotateOn = defaults.bool(forKey: "rotateOn")
            let text = gameScore1.text
            gameScore1.text = gameScore2.text
            gameScore2.text = text
            let label = gameScore1
            gameScore1 = gameScore2
            gameScore2 = label
        }
        if rotateOn {
            topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(player1Scored)))
            bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(player2Scored)))
            topPlayerLabel.text = "PLAYER 1"
            bottomPlayerLabel.text = "PLAYER 2"
        } else {
            topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(player2Scored)))
            bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(player1Scored)))
            bottomPlayerLabel.text = "PLAYER 1"
            topPlayerLabel.text = "PLAYER 2"
        }
    }
    
    @objc func showSaved() {
        let vc = SavedVC()
        vc.totalSets = totalSets
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @objc func startOver() {
        nextSetButton.setTitle("NEXT SET", for: .normal)
        curGame = 0
        curSet = 0
        player1Points = 0
        player1GameScore = 0
        player1SetScore = 0
        player2Points = 0
        player2GameScore = 0
        player2SetScore = 0
        gameLabel.text = "GAME 1"
        gameScore1.text = "00"
        gameScore2.text = "00"
        setScore1.text = "0"
        setScore2.text = "0"
        matchEntity = MatchEntity()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mma"
        matchEntity.time = dateFormatter.string(from: Date())
        setEntity = SetEntity()
        gameEntity = GameEntity()
        redraw()
    }
        
    func changeButton() {
        nextSetButton.setTitle("NEXT SET", for: .normal)
        startOver()
    }
}
