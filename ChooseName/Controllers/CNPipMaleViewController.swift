//
//  CNPipMaleViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 07.05.2023.
//

import UIKit

class CNPipMaleViewController: UIViewController {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewConteiner: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var constraintConteinerTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBaunceTop: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubitle: UILabel!
    @IBOutlet weak var textfieldLastName: UITextField!
    @IBOutlet weak var textfieldSecondName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPopup()
        if let lastName = UserDefaults.standard.value(forKey: Constants.savedMaleLastName) as? String {
            textfieldLastName.text = lastName
        }
        if let secondName = UserDefaults.standard.value(forKey: Constants.savedMaleFatherName) as? String {
            textfieldSecondName.text = secondName
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    func setupUI() {
        viewBlur.alpha = 0
        constraintConteinerTop.constant = -100
        constraintBaunceTop.constant = -70
        viewConteiner.alpha = 0
        
        labelTitle.text = "Pip.Title".localized()
        labelSubitle.text = "Pip.Subtile".localized()
        btnClose.setTitle("Pip.Close".localized(), for: .normal)
        btnSave.setTitle("Pip.Save".localized(), for: .normal)
        
        textfieldLastName.attributedPlaceholder = NSAttributedString(
            string: "Pip.LastName.Placeholder".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "NoteTextColor") ?? UIColor.white]
        )
        
        textfieldSecondName.attributedPlaceholder = NSAttributedString(
            string: "Pip.SecondName.Placeholder".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "NoteTextColor") ?? UIColor.white]
        )
        
        let bgGradient = CAGradientLayer()
        bgGradient.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height: viewBg.bounds.size.height)
        viewBg.layer.insertSublayer(bgGradient, at: 0)
        bgGradient.colors = [(UIColor.init(named: "BoyGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "BoyGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        viewBg.layer.insertSublayer(bgGradient, at: 0)
        
        textfieldLastName.becomeFirstResponder()
    }
    
    func showPopup() {
        UIView.animate(withDuration: 0.1, animations: {
            self.viewBlur.alpha = 1
        }) { (finish) in
            self.constraintConteinerTop.constant = 0
            self.constraintBaunceTop.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.viewConteiner.alpha = 1
            }
        }
    }
    
    func hidePopup() {
        self.constraintConteinerTop.constant = -100
        self.constraintBaunceTop.constant = -70
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
    
    @IBAction func onClose(_ sender: Any?) {
        hidePopup()
    }
    
    @IBAction func onSave(_ sender: Any?) {
        UserDefaults.standard.setValue(textfieldLastName.text, forKey: Constants.savedMaleLastName)
        UserDefaults.standard.setValue(textfieldSecondName.text, forKey: Constants.savedMaleFatherName)
        NotificationCenter.default.post(name: Notification.Name(Constants.notificationUpdateUserData), object: nil)
        hidePopup()
    }

}

extension CNPipMaleViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= Constants.nameLimit
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textfieldSecondName.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
}
