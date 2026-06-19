//
//  CNSettingsViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 07.02.2021.
//

import UIKit

class CNSettingsViewController: CNInitialViewController {
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var labelClear: UILabel!
    @IBOutlet weak var viewClear: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let boyLastName = UserDefaults.standard.string(forKey: Constants.savedMaleLastName)
        for subview in viewLastNameBoy.subviews {
            if subview.tag == 1, let field = subview as? UITextField {
                field.text = boyLastName
            }
        }
        
        let girlLastName = UserDefaults.standard.string(forKey: Constants.savedFemaleLastName)
        for subview in viewLastNameGirl.subviews {
            if subview.tag == 3, let field = subview as? UITextField {
                field.text = girlLastName
            }
        }
        
        let boyFatherName = UserDefaults.standard.string(forKey: Constants.savedMaleFatherName)
        for subview in viewFatherNameBoy.subviews {
            if subview.tag == 2, let field = subview as? UITextField {
                field.text = boyFatherName
            }
        }
        
        let girlFatherName = UserDefaults.standard.string(forKey: Constants.savedFemaleFatherName)
        for subview in viewFatherNameGirl.subviews {
            if subview.tag == 4, let field = subview as? UITextField {
                field.text = girlFatherName
            }
        }
    }
    
    @IBAction func onMenu(_ sender: Any) {
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier:"CNMenuViewController") as? CNMenuViewController {
            vc.modalPresentationStyle = .overCurrentContext
            vc.selectedIndex = 3
            vc.naviagtionController = self.navigationController
            present(vc, animated: true, completion:nil)
        }
    }
    
    @IBAction func onClearCashe(_ sender: Any) {
        let alert = UIAlertController(title: "Settings.ConfirmTitle".localized(), message: "Settings.ConfirmText".localized(), preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { (selected) in
            UserDefaults.standard.removeObject(forKey: Constants.savedMaleLastName)
            UserDefaults.standard.removeObject(forKey: Constants.savedMaleFatherName)
            UserDefaults.standard.removeObject(forKey: Constants.savedFemaleLastName)
            UserDefaults.standard.removeObject(forKey: Constants.savedFemaleFatherName)
            for subview in self.viewLastNameBoy.subviews {
                if subview.tag == 1, let field = subview as? UITextField {
                    field.text = ""
                }
            }
            for subview in self.viewFatherNameBoy.subviews {
                if subview.tag == 2, let field = subview as? UITextField {
                    field.text = ""
                }
            }
            for subview in self.viewLastNameGirl.subviews {
                if subview.tag == 3, let field = subview as? UITextField {
                    field.text = ""
                }
            }
            for subview in self.viewFatherNameGirl.subviews {
                if subview.tag == 4, let field = subview as? UITextField {
                    field.text = ""
                }
            }
            DataSource.instance.clearAllDB()
            self.hideCleaerBtn()
        }))
        alert.addAction(UIAlertAction(title: "Ні", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func hideCleaerBtn() {
        btnClear.isHidden = true
        labelClear.isHidden = true
        viewClear.isHidden = true
    }
    
    func showCleaerBtn() {
        btnClear.isHidden = false
        labelClear.isHidden = false
        viewClear.isHidden = false
    }
    
    override func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        showCleaerBtn()
        return super.textFieldShouldEndEditing(textField)
    }
}
