//
//  CNIntroViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 01.02.2021.
//

import UIKit

class CNIntroViewController: UIViewController {
    @IBOutlet weak var viewBg: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bgGradient = CAGradientLayer()
        bgGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        bgGradient.colors = [(UIColor.init(named: "MainGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "MainGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        viewBg.layer.insertSublayer(bgGradient, at: 0)
    }

}
