//
//  CNMainViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 16.12.2020.
//

import UIKit
import Koloda
import FirebaseAnalytics

class CNMainViewController: UIViewController {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var viewDislike: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgDislike: UIImageView!
    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnSearchClose: UIButton!
    @IBOutlet weak var fieldSearch: UITextField!
    @IBOutlet weak var btnListAgain: UIButton!
    @IBOutlet weak var constraintSearchWidth: NSLayoutConstraint!
    var names:[Name]?
    var bgGradient = CAGradientLayer()
    var selectedMale:Bool = UserDefaults.standard.bool(forKey:Constants.isMaleSelected)
    var shownCardsCount = UserDefaults.standard.integer(forKey: Constants.shownCardsCount)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.viewControllers = [self]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI() {
        labelEmpty.text = "Card.Empty".localized()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.appearanceAnimationDuration = 0.2
        kolodaView.countOfVisibleCards = 1
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: Notification.Name(Constants.notificationUpdateUserData), object: nil)
        
        bgGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        viewBg.layer.insertSublayer(bgGradient, at: 0)
        selectedMale ? setupBoyLayout() : setupGirlLayout()
        
        btnListAgain.layer.borderWidth = 1
        btnListAgain.layer.borderColor = (UIColor.init(named: "SecondaryTextColor") ?? UIColor.white).cgColor
        btnListAgain.layer.cornerRadius = 10
    }
    
    func setupBoyLayout() {
        btnMale.isSelected = true
        btnFemale.isSelected = false
        bgGradient.colors = [(UIColor.init(named: "BoyGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "BoyGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        viewDislike.backgroundColor = UIColor.init(named: "Boy1Color")
        btnDislike.backgroundColor = UIColor.init(named: "Boy1Color")
        viewLike.backgroundColor = UIColor.init(named: "Boy2Color")
        btnLike.backgroundColor = UIColor.init(named: "Boy2Color")
        selectedMale = true
        UserDefaults.standard.set(true, forKey: Constants.isMaleSelected)
        updateData()
    }
    
    func setupGirlLayout() {
        btnMale.isSelected = false
        btnFemale.isSelected = true
        bgGradient.colors = [(UIColor.init(named: "GirlGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "GirlGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        viewBg.layer.insertSublayer(bgGradient, at: 0)
        viewDislike.backgroundColor = UIColor.init(named: "Girl1Color")
        btnDislike.backgroundColor = UIColor.init(named: "Girl1Color")
        viewLike.backgroundColor = UIColor.init(named: "Girl2Color")
        btnLike.backgroundColor = UIColor.init(named: "Girl2Color")
        selectedMale = false
        UserDefaults.standard.set(false, forKey: Constants.isMaleSelected)
        updateData()
    }
    
    @objc func updateData() {
        spinner.isHidden = false
        spinner.startAnimating()
        labelEmpty.text = "Card.Empty".localized()
        labelEmpty.isHidden = true
        btnListAgain.isHidden = true
        hideCards(true)
        DataSource.instance.getNames(selectedMale) { (names, error) in
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            if error != nil {
                let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok".localized(), style: .default, handler: nil))
                self.present(alert, animated: true)
                self.labelEmpty.isHidden = false
                self.btnListAgain.isHidden = false
            } else {
                if names.count > 0 {
                    self.names = names
                    self.hideCards(false)
                    self.labelEmpty.isHidden = true
                    self.btnListAgain.isHidden = true
                    self.kolodaView.resetCurrentCardIndex()
                    self.kolodaView.reloadData()
                } else {
                    self.labelEmpty.isHidden = false
                    self.btnListAgain.isHidden = false
                }
            }
        }
    }
    
    func hideCards(_ isShown:Bool) {
        kolodaView.isHidden = isShown
        btnDislike.isHidden = isShown
        btnLike.isHidden = isShown
        viewDislike.isHidden = isShown
        viewLike.isHidden = isShown
        imgDislike.isHidden = isShown
        imgLike.isHidden = isShown
    }

    @IBAction func onDislike(_ sender: Any?) {
        kolodaView.swipe(.left)
    }
    
    @IBAction func onLike(_ sender: Any?) {
        kolodaView.swipe(.right)
    }
    
    @IBAction func onMale(_ sender: Any) {
        closeSearchUI()
        setupBoyLayout()
    }
    
    @IBAction func onFemale(_ sender: Any) {
        closeSearchUI()
        setupGirlLayout()
    }
    
    @IBAction func onSearch(_ sender: Any) {
        viewSearch.alpha = 0
        fieldSearch.alpha = 0
        btnSearchClose.alpha = 0
        viewSearch.isHidden = false
        btnSearch.isHidden = true
        btnFavorite.isHidden = true
        btnEdit.isHidden = true
        constraintSearchWidth.constant = UIScreen.main.bounds.size.width
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.viewSearch.alpha = 1
        } completion: { (finised) in
            UIView.animate(withDuration: 0.3) {
                self.fieldSearch.alpha = 1
                self.btnSearchClose.alpha = 1
                self.fieldSearch.becomeFirstResponder()
            }
        }

    }
    
    @IBAction func onCloseSearch(_ sender: Any?) {
        if self.fieldSearch.text?.count ?? 0 > 0 {
            self.fieldSearch.text = ""
            self.fieldSearch.becomeFirstResponder()
        } else {
            closeSearchUI()
        }
        updateData()
    }
    
    @IBAction func onListAgain(_ sender: Any) {
        DataSource.instance.updateUnlikedNamesBD(selectedMale)
        updateData()
    }
    
    func closeSearchUI() {
        self.fieldSearch.text = ""
        view.endEditing(true)
        self.fieldSearch.alpha = 0
        self.btnSearchClose.alpha = 0
        constraintSearchWidth.constant = 85
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { (finised) in
            self.btnSearch.isHidden = false
            self.btnFavorite.isHidden = false
            self.btnEdit.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.viewSearch.alpha = 0
            } completion: { (finised) in
                self.viewSearch.isHidden = true
            }
        }
    }
    
//    @IBAction func onMenu(_ sender: Any) {
//        if let vc = UIStoryboard.load(controller: .menu) as? CNMenuViewController {
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.selectedIndex = 1
//            vc.naviagtionController = self.navigationController
//            present(vc, animated: true, completion:nil)
//        }
//    }
    
    @IBAction func onFavorites(_ sender: Any) {
        if let vc = UIStoryboard.load(controller: .favorites) as? CNFavoritesViewController {
            present(vc, animated: true, completion:nil)
        }
    }
    
    @IBAction func onEdit(_ sender: Any) {
        if selectedMale {
            if let vc = UIStoryboard.load(controller: .pipMale) as? CNPipMaleViewController {
                vc.modalPresentationStyle = .custom
                present(vc, animated: false, completion:nil)
            }
        } else {
            if let vc = UIStoryboard.load(controller: .pipFemale) as? CNPipFemaleViewController {
                vc.modalPresentationStyle = .custom
                present(vc, animated: false, completion:nil)
            }
        }
    }
    
}

extension CNMainViewController:KolodaViewDelegate, KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return names?.count ?? 0
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if let cardView = Bundle.main.loadNibNamed("CNCard", owner: self, options: nil)?[0] as? CNCard, names?.count ?? 0 > index {
            cardView.isMale = selectedMale
            cardView.name = names?[index]
            cardView.delegate = self
            return cardView
        }
        hideCards(true)
        self.labelEmpty.isHidden = false
        if viewSearch.isHidden == true {
            self.btnListAgain.isHidden = false
        }
        let emptyCardView = Bundle.main.loadNibNamed("CNEmptyCard", owner: self, options: nil)?[0]
        return emptyCardView as! UIView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if let selectedNameID = self.names?[index].nameID {
            if direction == .right {
                DataSource.instance.likeName(selectedNameID, selectedMale)
            } else {
                DataSource.instance.dislikeName(selectedNameID, selectedMale)
            }
        }
//        shoqwAd()
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        hideCards(true)
        labelEmpty.isHidden = false
        if viewSearch.isHidden == true {
            btnListAgain.isHidden = false
        }
    }

}

extension CNMainViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= Constants.nameLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.count > 0 {
            view.endEditing(true)
            search(text)
        }
        return true
    }
    
    func search(_ text:String) {
        spinner.isHidden = false
        spinner.startAnimating()
        labelEmpty.isHidden = true
        btnListAgain.isHidden = true
        hideCards(true)
        DataSource.instance.getSearchResult(isMale:selectedMale, search: text) { (names, error) in
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            if error != nil {
                let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok".localized(), style: .default, handler: nil))
                self.present(alert, animated: true)
                self.labelEmpty.text = "Card.Search.Empty".localized()
                self.labelEmpty.isHidden = false
//                self.btnListAgain.isHidden = false
            } else {
                if names.count > 0 {
                    self.names = names
                    self.hideCards(false)
                    self.labelEmpty.isHidden = true
                    self.btnListAgain.isHidden = true
                    self.kolodaView.resetCurrentCardIndex()
                    self.kolodaView.reloadData()
                } else {
                    self.labelEmpty.text = "Card.Search.Empty".localized()
                    self.labelEmpty.isHidden = false
//                    self.btnListAgain.isHidden = false
                }
            }
        }
    }
    
}

extension CNMainViewController:CNCardDelegate, CNCardViewControllerDelegate {
    
    func onDetails() {
        if let vc = UIStoryboard.load(controller: .card) as? CNCardViewController {
            vc.modalPresentationStyle = .overCurrentContext
            vc.isMale = self.selectedMale
            vc.name = self.names?[self.kolodaView.currentCardIndex]
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    func likeName() {
        onLike(nil)
    }
    
    func dislikeName() {
        onDislike(nil)
    }
    
}
