//
//  CNMenuViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 06.02.2021.
//

import UIKit
import StoreKit

class CNMenuViewController: UIViewController {
    @IBOutlet var btnsMenu: [UIButton]!
    @IBOutlet var labelVersion: UILabel!
    var selectedIndex:Int = 0 {
        didSet {
            updateSelectedItem()
        }
    }
    var naviagtionController:UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        labelVersion.text = "Версія \(appVersion)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSelectedItem()
    }
    
    func updateSelectedItem() {
        if btnsMenu != nil {
            for btn in btnsMenu {
                if btn.tag == selectedIndex {
                    btn.titleLabel?.font = Constants.fontBold(27)
                    btn.setTitleColor(UIColor.init(named: "MainTextColor") ?? .white, for: .normal)
                } else {
                    btn.titleLabel?.font = Constants.fontRegular(27)
                    btn.setTitleColor(UIColor.init(named: "SecondaryTextColor") ?? .white, for: .normal)
                }
            }
        }
    }
    
    @IBAction func onList(_ sender: Any) {
        selectedIndex = 1
        if let vc = UIStoryboard.load(controller:.main) as? CNMainViewController {
            naviagtionController?.viewControllers = [vc]
        }
        onClose(nil)
    }
    
    @IBAction func onSelectedList(_ sender: Any) {
        selectedIndex = 2
        if let vc = UIStoryboard.load(controller:.favorites) as? CNFavoritesViewController {
            naviagtionController?.viewControllers = [vc]
        }
        onClose(nil)
    }
    
    @IBAction func onSettings(_ sender: Any) {
        selectedIndex = 3
        if let vc = UIStoryboard.load(controller:.settings) as? CNSettingsViewController {
            naviagtionController?.viewControllers = [vc]
        }
        onClose(nil)
    }
    
    @IBAction func onTerms(_ sender: Any) {
        selectedIndex = 4
        onClose(nil)
    }
    
    @IBAction func onPolicy(_ sender: Any) {
        selectedIndex = 5
        if let url = URL(string: "http://babysname.tilda.ws/app-privacy-policy") {
            UIApplication.shared.open(url)
        }
        onClose(nil)
    }
    
    @IBAction func onReview(_ sender: Any) {
        selectedIndex = 6
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func onClose(_ sender: Any?) {
        dismiss(animated: true, completion:nil)
    }

}
