//
//  ResultVC.swift
//  Tennis Сounter
//
//  Created by Dmitriy on 2/15/23.
//

import UIKit
import RealmSwift

class ResultVC: UIViewController {
    
    weak var delegate: MainVCDelegate?
    
    var winner = 0
    var totalSets = 0
    var myMatch = MatchEntity()
    
    var newView = UIView()
    
    var fiveSetsButton = UIButton()
    var threeSetsButton = UIButton()
    var saveButton = UIButton()
    var changed = true
    var isFirstTime = true
    let realm = try! Realm()
    
    @available(iOS, deprecated: 15.0, message: "To silence the warnings")
    override func viewDidLoad() {
        super.viewDidLoad()
        newView = PassthroughView(frame: CGRect(x: -1, y: 0.44600938967 * view.frame.height, width: view.frame.width + 2, height: 600))
        newView.backgroundColor = UIColor(red: 0.00, green: 0.06, blue: 0.25, alpha: 1.00)
        newView.layer.cornerRadius = 20
        newView.layer.borderWidth = 1
        newView.layer.borderColor = UIColor.white.cgColor
        newView.layer.masksToBounds = true
        
        view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        // view is now a transparent view, so now I add newView to it and can size it however, I like
        view.addSubview(newView)
        
        let trophy = UIImageView(image: UIImage(named: "trophy"))
        trophy.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trophy)
        trophy.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
        trophy.topAnchor.constraint(equalTo: newView.topAnchor).isActive = true
        
        var bubble = UIView()
        bubble.frame = CGRect(x: 89, y: 550, width: 214, height: 65)
        bubble.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
        bubble.layer.cornerRadius = 5
        bubble.layer.masksToBounds = true
        view.addSubview(bubble)
        
        bubble = UIView()
        bubble.frame = CGRect(x: 108, y: 610, width: 176, height: 57)
        bubble.backgroundColor = UIColor.white
        bubble.layer.cornerRadius = 5
        bubble.layer.masksToBounds = true
        view.addSubview(bubble)
        
        var label = UILabel(frame: CGRect(x: 0.28498727735 * view.frame.width, y: 0.66197183098 * view.frame.height, width: 168, height: 47))
        label.font = UIFont(name: "PASTI", size: 47)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "PLAYER \(winner)"
        view.addSubview(label)
        
        label = UILabel(frame: CGRect(x: 0.40056 * view.frame.width, y: 0.72769953051 * view.frame.height, width: 80, height: 47))
        label.font = UIFont(name: "PASTI", size: 47)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "WIN"
        view.addSubview(label)
        
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0.05089058524 * view.frame.width, y: 0.47 * view.frame.height, width: 23, height: 24)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        view.addSubview(button)
        
        button = UIButton(type: .system)
        button.tintColor = .white
        button.frame = CGRect(x: 0.79643765903 * view.frame.width, y: 0.47 * view.frame.height, width: 24, height: 20)
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.addTarget(self, action: #selector(handleSett), for: .touchUpInside)
        view.addSubview(button)
        
        button = UIButton(type: .system)
        button.tintColor = .white
        button.frame = CGRect(x: 0.89058524173 * view.frame.width, y: 0.47 * view.frame.height, width: 24, height: 20)
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.addTarget(self, action: #selector(startOver), for: .touchUpInside)
        view.addSubview(button)
        
        let vieww = UIView(frame: CGRect(x: 0.33333333333 * view.frame.width, y: 0.90375586854 * view.frame.height, width: 128.33, height: 35))
        vieww.backgroundColor = UIColor(red: 0.11, green: 1, blue: 1, alpha: 1)
        vieww.layer.borderWidth = 1
        vieww.layer.borderColor = UIColor.white.cgColor
        vieww.layer.cornerRadius = 17
        vieww.clipsToBounds = true
        vieww.layer.masksToBounds = true
        view.addSubview(vieww)
        
        
        fiveSetsButton = UIButton(type: .custom)
        fiveSetsButton.frame = CGRect(x: 0.33842239185 * view.frame.width, y: 0.90692488262 * view.frame.height, width: 60, height: 29)
        fiveSetsButton.setTitle("5", for: .normal)
        fiveSetsButton.titleLabel?.font = UIFont(name: "PASTI", size: 22)
        fiveSetsButton.titleLabel?.textAlignment = .center
        fiveSetsButton.setTitleColor(UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1), for: .normal)
        fiveSetsButton.contentVerticalAlignment = .bottom
        fiveSetsButton.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
        fiveSetsButton.layer.cornerRadius = 14
        view.addSubview(fiveSetsButton)
        
        threeSetsButton = UIButton(type: .custom)
        threeSetsButton.frame = CGRect(x: 0.50127226463 * view.frame.width, y: 0.90692488262 * view.frame.height, width: 60, height: 29)
        threeSetsButton.setTitle("3", for: .normal)
        threeSetsButton.contentVerticalAlignment = .bottom
        threeSetsButton.titleLabel?.textAlignment = .center
        threeSetsButton.titleLabel?.font = UIFont(name: "PASTI", size: 22)
        threeSetsButton.setTitleColor(UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1), for: .normal)
        threeSetsButton.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
        threeSetsButton.layer.cornerRadius = 14
        view.addSubview(threeSetsButton)
        
        button = UIButton(type: .system)
        button.frame = CGRect(x: 0.8117048346 * view.frame.width, y: 0.36854460093 * view.frame.height, width: 70, height: 10)
        button.isHidden = true
        button.setTitle("SAVE MATCH", for: .normal)
        button.titleLabel?.font = UIFont(name: "PASTI", size: 12)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.setImage(UIImage(named: "next"), for: .normal)
        button.contentVerticalAlignment = .top
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        button.imageEdgeInsets.left = 5
        saveButton = button
        view.addSubview(saveButton)
        
        if totalSets == 5 {
            fiveSetsButton.backgroundColor = UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1)
            fiveSetsButton.layer.borderColor = UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1).cgColor
            fiveSetsButton.setTitleColor(.white, for: .normal)
            threeSetsButton.setTitleColor(UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1), for: .normal)
            threeSetsButton.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
            
            for i in 0..<5 {
                let view1 = UIView()
                view1.frame = CGRect(x: 0.03053435114 * view.frame.width + CGFloat(74 * i), y: 0.81220657277 * view.frame.height, width: 70, height: 60)
                view1.layer.borderWidth = 1
                view1.layer.borderColor = UIColor.white.cgColor
                view1.layer.cornerRadius = 5
                view.addSubview(view1)
            }
            
            for i in 0..<5 {
                var label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.81924882629 * view.frame.height, width: 35, height: 13)
                label.text = "SETS \(i + 1)"
                label.font = UIFont(name: "PASTI", size: 12)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 27, height: 9)
                label.text = "PLAYER 1"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.12468193384 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 29, height: 9)
                label.text = "PLAYER 2"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.05597964376 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i > myMatch.sets.count ? "-" : "\(myMatch.sets[i].games.last?.player1GameScore ?? 0)"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.15521628498 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i > myMatch.sets.count ? "-" : "\(myMatch.sets[i].games.last?.player2GameScore ?? 0)"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
            }
        } else {
            fiveSetsButton.isSelected = false
            threeSetsButton.isSelected = true
            
            threeSetsButton.backgroundColor = UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1)
            threeSetsButton.layer.borderColor = UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1).cgColor
            threeSetsButton.setTitleColor(.white, for: .normal)
            fiveSetsButton.setTitleColor(UIColor(red: 0/255, green: 16/255, blue: 57/255, alpha: 1), for: .normal)
            fiveSetsButton.backgroundColor = UIColor(red: 31/255, green: 255/255, blue: 255/255, alpha: 1)
            
            for i in 1..<4 {
                let view1 = UIView()
                view1.frame = CGRect(x: 0.03053435114 * view.frame.width + CGFloat(74 * i), y: 0.81220657277 * view.frame.height, width: 70, height: 60)
                view1.layer.borderWidth = 1
                view1.layer.borderColor = UIColor.white.cgColor
                view1.layer.cornerRadius = 5
                view.addSubview(view1)
            }
            
            for i in 1..<4 {
                var label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.81924882629 * view.frame.height, width: 35, height: 13)
                label.text = "SETS \(i)"
                label.font = UIFont(name: "PASTI", size: 12)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 27, height: 9)
                label.text = "PLAYER 1"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.12468193384 * view.frame.width + CGFloat(i * 74), y: 0.84037558685 * view.frame.height, width: 29, height: 9)
                label.text = "PLAYER 2"
                label.font = UIFont(name: "PASTI", size: 8)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.05597964376 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i - 1 > myMatch.sets.count ? "-" : "\(myMatch.sets[i - 1].games.last?.player1GameScore ?? 0)"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
                
                label = UILabel()
                label.frame = CGRect(x: 0.15521628498 * view.frame.width + CGFloat(i * 74), y: 0.85798122065 * view.frame.height, width: 10, height: 20)
                label.text = i - 1 > myMatch.sets.count ? "-" : "\(myMatch.sets[i - 1].games.last?.player2GameScore ?? 0)"
                label.font = UIFont(name: "PASTI", size: 18)
                label.textAlignment = .left
                label.textColor = UIColor.white
                view.addSubview(label)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        saveButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveButton.isHidden = true
    }
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSett() {
        let settVC = SettVC()
        settVC.modalPresentationStyle = .fullScreen
        present(settVC, animated: true)
    }
    
    @objc func startOver() {
        self.delegate?.changeButton()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTapped() {
        try! realm.write {
            realm.add(myMatch)
        }
        delegate?.changeButton()
        dismiss(animated: true, completion: nil)
    }
}

class PassthroughView: UIView {
    private let passthroughRect = CGRect(x: 0.8117048346 * 393, y: 0.36854460093 * 852, width: 70, height: 10)
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event), passthroughRect.contains(point) {
            return nil // allow passthrough
        } else {
            return super.hitTest(point, with: event)
        }
    }
}
