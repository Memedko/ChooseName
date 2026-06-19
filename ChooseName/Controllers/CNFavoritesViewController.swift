//
//  CNFavoritesViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 23.02.2021.
//

import UIKit

class CNFavoritesViewController: UIViewController, CCNFavoriteTableViewCellDelegate {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var btnAddClose: UIButton!
    @IBOutlet weak var fieldAdd: UITextField!
    @IBOutlet weak var constraintAddWidth: NSLayoutConstraint!
    @IBOutlet weak var viewSearchBg: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewShare: UIView!
    
    var bgGradient = CAGradientLayer()
    var bgSearchGradient = CAGradientLayer()
    var selectedMale:Bool = UserDefaults.standard.bool(forKey:Constants.isMaleSelected)
    var names:[Name] = []
    var searchNames:[Name] = [] {
        didSet {
            if searchNames.count > 0 {
                showSearch()
            } else {
                hideSearch()
            }
        }
    }
    var selectedIndexPath:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        labelEmpty.text = "Favorites.Empty".localized()
        bgGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        viewBg.layer.insertSublayer(bgGradient, at: 0)
        bgSearchGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        viewSearchBg.layer.insertSublayer(bgSearchGradient, at: 0)
        selectedMale ? setupBoyLayout() : setupGirlLayout()
        hideSearch()
    }
    
    func setupBoyLayout() {
        btnMale.isSelected = true
        btnFemale.isSelected = false
        bgGradient.colors = [(UIColor.init(named: "BoyGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "BoyGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        bgSearchGradient.colors = [(UIColor.init(named: "BoyGradient2Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "BoyGradient1Color") ?? UIColor.black).cgColor]
        btnShare.backgroundColor = UIColor.init(named: "Boy2Color") ?? UIColor.blue
        viewShare.backgroundColor = UIColor.init(named: "Boy2Color") ?? UIColor.blue
        bgSearchGradient.locations = [0.0, 1.0]
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
        bgSearchGradient.colors = [(UIColor.init(named: "GirlGradient2Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "GirlGradient1Color") ?? UIColor.black).cgColor]
        btnShare.backgroundColor = UIColor.init(named: "Girl2Color") ?? UIColor.blue
        viewShare.backgroundColor = UIColor.init(named: "Girl2Color") ?? UIColor.blue
        bgSearchGradient.locations = [0.0, 1.0]
        viewSearchBg.layer.insertSublayer(bgSearchGradient, at: 0)
        selectedMale = false
        UserDefaults.standard.set(false, forKey: Constants.isMaleSelected)
        updateData()
    }
    
    @objc func updateData() {
        spinner.isHidden = false
        spinner.startAnimating()
        labelEmpty.isHidden = true
        btnShare.isHidden = true
        viewShare.isHidden = true
        
        DataSource.instance.getLikedNames(selectedMale) { (names) in
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            self.names = names
            if names.count > 0 {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.labelEmpty.isHidden = true
                self.btnShare.isHidden = false
                self.viewShare.isHidden = false
            } else {
                self.tableView.isHidden = true
                self.labelEmpty.isHidden = false
                self.btnShare.isHidden = true
                self.viewShare.isHidden = true
            }
        }
    }
    
    //MARK: Actions
    
    @IBAction func onMenu(_ sender: Any) {
//        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier:"CNMenuViewController") as? CNMenuViewController {
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.selectedIndex = 2
//            vc.naviagtionController = self.navigationController
//            present(vc, animated: true, completion:nil)
//        }
        self.dismiss(animated: true)
    }
    
    @IBAction func onMale(_ sender: Any) {
        setupBoyLayout()
    }
    
    @IBAction func onFemale(_ sender: Any) {
        setupGirlLayout()
    }
    
    @IBAction func onAdd(_ sender: Any) {
        viewAdd.alpha = 0
        fieldAdd.alpha = 0
        btnAddClose.alpha = 0
        viewAdd.isHidden = false
        btnAdd.isHidden = true
        btnMenu.isHidden = true
        constraintAddWidth.constant = UIScreen.main.bounds.size.width
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.viewAdd.alpha = 1
        } completion: { (finised) in
            UIView.animate(withDuration: 0.3) {
                self.fieldAdd.alpha = 1
                self.btnAddClose.alpha = 1
                self.fieldAdd.becomeFirstResponder()
            }
        }

    }
    
    @IBAction func onCloseAdd(_ sender: Any?) {
        updateData()
        fieldAdd.text = ""
        view.endEditing(true)
        fieldAdd.alpha = 0
        btnAddClose.alpha = 0
        constraintAddWidth.constant = 85
        searchNames = []
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { (finised) in
            self.btnAdd.isHidden = false
            self.btnMenu.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.viewAdd.alpha = 0
            } completion: { (finised) in
                self.viewAdd.isHidden = true
            }
        }
    }
    
    func onLike(_ cell:UITableViewCell) {
        if let indexPath = selectedIndexPath {
            names[indexPath.row].isLiked = false
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        if let indexPath = tableView.indexPath(for: cell), let nameID = names[indexPath.row].nameID {
            selectedIndexPath = indexPath
            names[indexPath.row].isLiked = true
            DataSource.instance.selectLikedName(nameID, selectedMale)
        }
    }
    
    func onUnlike(_ cell:UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell), let nameID = names[indexPath.row].nameID {
            selectedIndexPath = nil
            names[indexPath.row].isLiked = false
            DataSource.instance.unselectLikedName(nameID, selectedMale)
        }
    }
    
    @IBAction func onShare(_ sender: Any?) {
        var text = "Мені подобаються такі імена:\n\n"
        for name in names {
            if name.isLiked {
                text = text + "❤️ " + (name.name ?? "") + "\n"
            } else {
                text = text + "👶🏻 " + (name.name ?? "") + "\n"
            }
        }
        text += "\nОтримайте більше інформації про імена в додатку \"Ім'я малюка\" (https://apps.apple.com/ua/app/id1553686058)."
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func onRemoveNameFromFavorites(_ indexPath:IndexPath) {
        let alert = UIAlertController(title: nil, message: "Ви впевнені, що хочете видалити це ім'я зі списку вподобаних імен?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ні", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Так", style: .destructive, handler: { _ in
            self.removeNameFromFavorites(indexPath)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeNameFromFavorites(_ indexPath:IndexPath) {
        if let nameID = self.names[indexPath.row].nameID, nameID != "" {
            DataSource.instance.unlikeName(nameID, self.selectedMale)
        } else {
            if let name = self.names[indexPath.row].name {
                DataSource.instance.removeNewNameDB(name, self.selectedMale)
            }
        }
        self.names.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.reloadData()
        if self.names.count == 0 {
            self.labelEmpty.isHidden = false
            self.btnShare.isHidden = true
            self.viewShare.isHidden = true
        }
    }
    
    //MARK: Search
    
    func showSearch() {
        viewSearchBg.isHidden = false
        searchTableView.reloadData()
    }
    
    func hideSearch() {
        viewSearchBg.isHidden = true
    }

}

extension CNFavoritesViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count <= Constants.nameLimit, updatedText.count > 0 {
            DataSource.instance.searchForAdding(updatedText, selectedMale) { (names) in
                self.searchNames = names
            }
        } else {
            hideSearch()
        }
        return updatedText.count <= Constants.nameLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.count > 0 {
            DataSource.instance.checkNameDB(text, selectedMale) { (name) in
                if let name = name, (name.select == 1 || name.select == -1) {
                    let alert = UIAlertController(title:nil, message: "Favorites.NameSelected".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок".localized(), style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    DataSource.instance.addNewNameDB(text, self.selectedMale)
                    self.onCloseAdd(nil)
                    self.updateData()
                }
            }
        } else {
            self.onCloseAdd(nil)
        }
        return true
    }
    
}

extension CNFavoritesViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return searchNames.count
        }
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNSearchAddTableViewCell", for: indexPath) as! CNSearchAddTableViewCell
            cell.isLast = indexPath.row == searchNames.count - 1
            cell.name = searchNames[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNFavoriteTableViewCell", for: indexPath) as! CNFavoriteTableViewCell
        cell.isLast = indexPath.row == names.count - 1
        cell.name = names[indexPath.row]
        if self.names[indexPath.row].isLiked {
            selectedIndexPath = indexPath
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            if searchNames[indexPath.row].select == 0, let nameID = searchNames[indexPath.row].nameID {
                DataSource.instance.likeName(nameID, selectedMale)
                self.onCloseAdd(nil)
                self.updateData()
            } else if searchNames[indexPath.row].select == 1 {
                let alert = UIAlertController(title:nil, message: "Favorites.NameLiked".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок".localized(), style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title:nil, message: "Favorites.NameDisliked".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок".localized(), style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            return
        }
        if let nameID = self.names[indexPath.row].nameID, let value = self.names[indexPath.row].value, nameID != "", let vc = UIStoryboard.load(controller: .card) as? CNCardViewController {
            vc.modalPresentationStyle = .overCurrentContext
            vc.isMale = self.selectedMale
            vc.name = self.names[indexPath.row]
            vc.isSelectedView = true
            vc.modalPresentationStyle = .fullScreen
//            navigationController?.pushViewController(vc, animated: true)
            present(vc, animated: true, completion:nil)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.onRemoveNameFromFavorites(indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        deleteAction.title = "Remove".localized()
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}
