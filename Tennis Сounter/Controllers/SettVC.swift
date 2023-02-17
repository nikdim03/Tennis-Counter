//
//  SettVC.swift
//  Tennis Сounter
//
//  Created by Dmitriy on 2/15/23.
//

import UIKit
import WebKit

class SettVC: UIViewController, WKNavigationDelegate {
    
    let defaults = UserDefaults.standard
    var vibrationButton = UIButton()
    var rotationButton = UIButton()
    var vibrationImg = UIImageView()
    var rotationImg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.00, green: 0.06, blue: 0.25, alpha: 1.00)
        let label = UILabel()
        label.font = UIFont(name: "HEEBO", size: 24)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Settings"
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.06103286384 * view.frame.height).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: -70, bottom: 10, trailing: 10)
        configuration.imagePadding = 6
        configuration.image = UIImage(named: "bell")
        var title = AttributedString.init("Vibration")
        title.font = UIFont(name: "HEEBO", size: 12)
        configuration.attributedTitle = title
        configuration.cornerStyle = .large
        configuration.baseForegroundColor = UIColor(red: 0.00, green: 0.06, blue: 0.25, alpha: 1.00)
        configuration.baseBackgroundColor = .white
        var button = UIButton(configuration: configuration)
        button.frame = CGRect(x: 0.04325699745 * view.frame.width, y: 0.12910798122 * view.frame.height, width: 174, height: 45)
        button.addTarget(self, action: #selector(handleVibration), for: .touchUpInside)
        vibrationButton = button
        if defaults.bool(forKey: "hapticFeedbackOn") {
            vibrationButton.isSelected = true
        }
        view.addSubview(vibrationButton)
        
        configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: -45, bottom: 10, trailing: 10)
        configuration.imagePadding = 6
        configuration.image = UIImage(named: "privacy")
        title = AttributedString.init("Privacy Policy")
        title.font = UIFont(name: "HEEBO", size: 12)
        configuration.attributedTitle = title
        configuration.cornerStyle = .large
        configuration.baseForegroundColor = UIColor(red: 0.00, green: 0.06, blue: 0.25, alpha: 1.00)
        configuration.baseBackgroundColor = .white
        button = UIButton(configuration: configuration)
        button.frame = CGRect(x: 0.04325699745 * view.frame.width, y: 0.20070422535 * view.frame.height, width: 174, height: 45)
        button.addTarget(self, action: #selector(handlePrivacy), for: .touchUpInside)
        view.addSubview(button)
        
        configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: -25, bottom: 10, trailing: 10)
        configuration.imagePadding = 6
        configuration.image = UIImage(named: "rewind")
        title = AttributedString.init("Rotate top section")
        title.font = UIFont(name: "HEEBO", size: 12)
        configuration.attributedTitle = title
        configuration.cornerStyle = .large
        configuration.baseForegroundColor = UIColor(red: 0.00, green: 0.06, blue: 0.25, alpha: 1.00)
        configuration.baseBackgroundColor = .white
        button = UIButton(configuration: configuration)
        button.frame = CGRect(x: 0.50636132315 * view.frame.width, y: 0.12910798122 * view.frame.height, width: 174, height: 45)
        button.addTarget(self, action: #selector(handleRotate), for: .touchUpInside)
        rotationButton = button
        if defaults.bool(forKey: "rotateOn") {
            vibrationButton.isSelected = true
        }
        view.addSubview(rotationButton)
        
        configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: -45, bottom: 10, trailing: 10)
        configuration.imagePadding = 6
        configuration.image = UIImage(named: "terms")
        title = AttributedString.init("Terms of Use")
        title.font = UIFont(name: "HEEBO", size: 12)
        configuration.attributedTitle = title
        configuration.cornerStyle = .large
        configuration.baseForegroundColor = UIColor(red: 0.00, green: 0.06, blue: 0.25, alpha: 1.00)
        configuration.baseBackgroundColor = .white
        button = UIButton(configuration: configuration)
        button.frame = CGRect(x: 0.50636132315 * view.frame.width, y: 0.20070422535 * view.frame.height, width: 174, height: 45)
        button.addTarget(self, action: #selector(handleTerms), for: .touchUpInside)
        view.addSubview(button)
        
        if defaults.bool(forKey: "hapticFeedbackOn") {
            vibrationImg = UIImageView(image: UIImage(named: "on"))
        } else {
            vibrationImg = UIImageView(image: UIImage(named: "off"))
        }
        vibrationImg.frame = CGRect(x: 0.40610687022 * view.frame.width, y: 0.14788732394 * view.frame.height, width: 16, height: 14)
        vibrationImg.contentMode = .scaleAspectFill
        view.addSubview(vibrationImg)
        
        if defaults.bool(forKey: "rotateOn") {
            rotationImg = UIImageView(image: UIImage(named: "on"))
        } else {
            rotationImg = UIImageView(image: UIImage(named: "off"))
        }
        rotationImg.frame = CGRect(x: 0.86921119592 * view.frame.width, y: 0.14788732394 * view.frame.height, width: 16, height: 14)
        rotationImg.contentMode = .scaleAspectFill
        view.addSubview(rotationImg)
        
        button = UIButton(type: .system)
        button.frame = CGRect(x: 0.8854961832 * view.frame.width, y: 0.06690140845 * view.frame.height, width: 23, height: 24)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleVibration() {
        if vibrationButton.isSelected {
            defaults.set(false, forKey: "hapticFeedbackOn")
            vibrationImg.image = UIImage(named: "off")
            vibrationButton.isSelected = false
        } else {
            defaults.set(true, forKey: "hapticFeedbackOn")
            vibrationImg.image = UIImage(named: "on")
            vibrationButton.isSelected = true
        }
    }
    
    @objc func handleRotate() {
        if rotationButton.isSelected {
            defaults.set(false, forKey: "rotateOn")
            rotationImg.image = UIImage(named: "off")
            rotationButton.isSelected = false
        } else {
            defaults.set(true, forKey: "rotateOn")
            rotationImg.image = UIImage(named: "on")
            rotationButton.isSelected = true
        }
    }
    
    @objc func handlePrivacy() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        let url = URL(string: "https://playandwinwithus.online/privacy.html")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        let webViewController = UIViewController()
        webViewController.view = webView
        present(webViewController, animated: true, completion: nil)
    }
    
    @objc func handleTerms() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        let url = URL(string: "https://playandwinwithus.online/terms.html")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        let webViewController = UIViewController()
        webViewController.view = webView
        present(webViewController, animated: true, completion: nil)
    }
}
