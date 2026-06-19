//
//  CNInitialViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 01.02.2021.
//

import UIKit
import SkyFloatingLabelTextField

class CNInitialViewController: UIViewController {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewLastNameBoy: UIView!
    @IBOutlet weak var viewFatherNameBoy: UIView!
    @IBOutlet weak var viewLastNameGirl: UIView!
    @IBOutlet weak var viewFatherNameGirl: UIView!
    @IBOutlet var constraintKeyboardHeight: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bgGradient = CAGradientLayer()
        bgGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        bgGradient.colors = [(UIColor.init(named: "MainGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "MainGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        viewBg.layer.insertSublayer(bgGradient, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewLastNameBoy.textFieldCreate(self, "Last name".localized(), "Last name".localized(), .next, 1)
        viewFatherNameBoy.textFieldCreate(self, "Middle name".localized(), "Middle name".localized(), .done, 2)
        viewLastNameGirl.textFieldCreate(self, "Last name".localized(), "Last name".localized(), .next, 3)
        viewFatherNameGirl.textFieldCreate(self, "Middle name".localized(), "Middle name".localized(), .done, 4)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
     
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        if endFrameY >= UIScreen.main.bounds.size.height {
            constraintKeyboardHeight?.constant = 0.0
        } else {
            constraintKeyboardHeight?.constant = endFrame?.size.height ?? 0.0
        }

        UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: { self.view.layoutIfNeeded() }, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CNInitialViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= Constants.nameLimit
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            UserDefaults.standard.setValue(textField.text, forKey: Constants.savedMaleLastName)
            break
        case 2:
            UserDefaults.standard.setValue(textField.text, forKey: Constants.savedMaleFatherName)
            break
        case 3:
            UserDefaults.standard.setValue(textField.text, forKey: Constants.savedFemaleLastName)
            break
        case 4:
            UserDefaults.standard.setValue(textField.text, forKey: Constants.savedFemaleFatherName)
            break
        default:
            break
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            for subview in viewFatherNameBoy.subviews {
                if subview.tag == 2 {
                    subview.becomeFirstResponder()
                }
            }
        } else if textField.tag == 3 {
            for subview in viewFatherNameGirl.subviews {
                if subview.tag == 4 {
                    subview.becomeFirstResponder()
                }
            }
        } else {
            dismissKeyboard()
        }
        return true
    }
    
}
