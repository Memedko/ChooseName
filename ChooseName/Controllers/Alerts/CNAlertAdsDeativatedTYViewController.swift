//
//  CNAlertAdsDeativatedTYViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 19.04.2021.
//

import UIKit
import Lottie

class CNAlertAdsDeativatedTYViewController: UIViewController {
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewConteiner: UIView!
    @IBOutlet weak var viewAnimationConteiner: UIView!
    @IBOutlet weak var constraintConteinerBottom: NSLayoutConstraint!
    @IBOutlet weak var labelAds: UILabel!
    var bgGradient = CAGradientLayer()
    var isAdsTY = true

    override func viewDidLoad() {
        super.viewDidLoad()
//        let gestureClick = UITapGestureRecognizer(target: self, action:  #selector(hidePopup))
//        viewBlur.addGestureRecognizer(gestureClick)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelAds.isHidden = !isAdsTY
        resetPopup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bgGradient.colors = [(UIColor.init(named: "MainGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "MainGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        bgGradient.frame = CGRect(x: 0, y: 0, width: viewBg.frame.size.width, height: viewBg.frame.size.height)
        viewBg.layer.insertSublayer(bgGradient, at: 0)
        startAnimation()
        showPopup()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        hidePopup()
    }
    
    func resetPopup() {
        viewBlur.alpha = 0
        viewConteiner.alpha = 0
        constraintConteinerBottom.constant = -700
    }
    
    func showPopup() {
        UIView.animate(withDuration: 0.1, animations: {
            self.viewBlur.alpha = 1
        }) { (finish) in
            self.constraintConteinerBottom.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.viewConteiner.alpha = 1
            }
        }
    }
    
    @objc func hidePopup() {
        self.constraintConteinerBottom.constant = -700
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.viewConteiner.alpha = 0
        }) { (finish) in
            UIView.animate(withDuration: 0.1, animations: {
                self.viewBlur.alpha = 0
            }) { (finish) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func startAnimation() {
        let animationView = AnimationView.init(name: "childSmiles")
        animationView.animationSpeed = 0.6
        animationView.frame = viewAnimationConteiner.bounds
        animationView.contentMode = .scaleAspectFit
        viewAnimationConteiner.addSubview(animationView)
        animationView.play()
    }
}
