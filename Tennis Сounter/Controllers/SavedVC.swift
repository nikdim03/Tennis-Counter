//
//  SavedVC.swift
//  Tennis Сounter
//
//  Created by Dmitriy on 2/16/23.
//

import UIKit
import RealmSwift

class SavedVC: UIViewController {
    
    var totalSets = 0
    var matches: Results<MatchEntity>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matches = realm.objects(MatchEntity.self)
        view.backgroundColor = UIColor(red: 0.00, green: 0.06, blue: 0.25, alpha: 1.00)
        let label = UILabel()
        label.font = UIFont(name: "HEEBO", size: 24)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Saved Matches"
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.06103286384 * view.frame.height).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.8854961832 * view.frame.width, y: 0.06690140845 * view.frame.height, width: 23, height: 24)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        view.addSubview(button)
        drawShit()
    }
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    func drawShit() {
        let scrollView = UIScrollView()
        scrollView.contentSize = view.frame.size
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.1 * view.frame.height).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        for (j, myMatch) in matches.enumerated() {
            let label = UILabel()
            label.frame = CGRect(x: 0.03816793893 * view.frame.width, y: 0.075 * view.frame.height + CGFloat(j * 100), width: 1000, height: 13)
            label.text = myMatch.time
            label.font = UIFont(name: "PASTI", size: 12)
            label.textAlignment = .left
            label.textColor = UIColor.white
            scrollView.addSubview(label)
            if myMatch.sets.count == 5 {
                for i in 0..<5 {
                    let view1 = UIView()
                    view1.frame = CGRect(x: 0.03053435114 * view.frame.width + CGFloat(74 * i), y: 0.1 * view.frame.height + CGFloat(j * 100), width: 70, height: 60)
                    view1.layer.borderWidth = 1
                    view1.layer.borderColor = UIColor.white.cgColor
                    view1.layer.cornerRadius = 5
                    scrollView.addSubview(view1)
                }
                
                for i in 0..<5 {
                    var label = UILabel()
                    label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.11 * view.frame.height + CGFloat(j * 100), width: 35, height: 13)
                    label.text = "SETS \(i + 1)"
                    label.font = UIFont(name: "PASTI", size: 12)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                    
                    label = UILabel()
                    label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.132 * view.frame.height + CGFloat(j * 100), width: 27, height: 9)
                    label.text = "PLAYER 1"
                    label.font = UIFont(name: "PASTI", size: 8)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                    
                    label = UILabel()
                    label.frame = CGRect(x: 0.12468193384 * view.frame.width + CGFloat(i * 74), y: 0.131 * view.frame.height + CGFloat(j * 100), width: 29, height: 9)
                    label.text = "PLAYER 2"
                    label.font = UIFont(name: "PASTI", size: 8)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                    
                    label = UILabel()
                    label.frame = CGRect(x: 0.05597964376 * view.frame.width + CGFloat(i * 74), y: 0.1455 * view.frame.height + CGFloat(j * 100), width: 10, height: 20)
                    label.text = i > myMatch.sets.count ? "-" : "\(myMatch.sets[i].games.last?.player1GameScore ?? 0)"
                    label.font = UIFont(name: "PASTI", size: 18)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                    
                    label = UILabel()
                    label.frame = CGRect(x: 0.15521628498 * view.frame.width + CGFloat(i * 74), y: 0.1455 * view.frame.height + CGFloat(j * 100), width: 10, height: 20)
                    label.text = i > myMatch.sets.count ? "-" : "\(myMatch.sets[i].games.last?.player2GameScore ?? 0)"
                    label.font = UIFont(name: "PASTI", size: 18)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                }
            } else {
                for i in 1..<4 {
                    let view1 = UIView()
                    view1.frame = CGRect(x: 0.03053435114 * view.frame.width + CGFloat(74 * i), y: 0.1 * view.frame.height + CGFloat(j * 100), width: 70, height: 60)
                    view1.layer.borderWidth = 1
                    view1.layer.borderColor = UIColor.white.cgColor
                    view1.layer.cornerRadius = 5
                    scrollView.addSubview(view1)
                }
                
                for i in 1..<4 {
                    var label = UILabel()
                    label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.11 * view.frame.height + CGFloat(j * 100), width: 35, height: 13)
                    label.text = "SETS \(i)"
                    label.font = UIFont(name: "PASTI", size: 12)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                    
                    label = UILabel()
                    label.frame = CGRect(x: 0.03816793893 * view.frame.width + CGFloat(i * 74), y: 0.132 * view.frame.height + CGFloat(j * 100), width: 27, height: 9)
                    label.text = "PLAYER 1"
                    label.font = UIFont(name: "PASTI", size: 8)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                    
                    label = UILabel()
                    label.frame = CGRect(x: 0.12468193384 * view.frame.width + CGFloat(i * 74), y: 0.131 * view.frame.height + CGFloat(j * 100), width: 29, height: 9)
                    label.text = "PLAYER 2"
                    label.font = UIFont(name: "PASTI", size: 8)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                    
                    label = UILabel()
                    label.frame = CGRect(x: 0.05597964376 * view.frame.width + CGFloat(i * 74), y: 0.1455 * view.frame.height + CGFloat(j * 100), width: 10, height: 20)
                    label.text = i - 1 > myMatch.sets.count ? "-" : "\(myMatch.sets[i - 1].games.last?.player1GameScore ?? 0)"
                    label.font = UIFont(name: "PASTI", size: 18)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                    
                    label = UILabel()
                    label.frame = CGRect(x: 0.15521628498 * view.frame.width + CGFloat(i * 74), y: 0.1455 * view.frame.height + CGFloat(j * 100), width: 10, height: 20)
                    label.text = i - 1 > myMatch.sets.count ? "-" : "\(myMatch.sets[i - 1].games.last?.player2GameScore ?? 0)"
                    label.font = UIFont(name: "PASTI", size: 18)
                    label.textAlignment = .left
                    label.textColor = UIColor.white
                    scrollView.addSubview(label)
                }
            }
        }
    }
}
