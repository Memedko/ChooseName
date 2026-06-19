//
//  CNCardViewController.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 23.01.2021.
//

import UIKit

protocol CNCardViewControllerDelegate {
    func likeName()
    func dislikeName()
}

class CNCardViewController: UIViewController, CNCardNameTableViewCellDelegate {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var viewDislike: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintTableTop: NSLayoutConstraint!
    
    var cellList:[String] = [Constants.cellName]
    var bgGradient = CAGradientLayer()
    var isMale:Bool = true
    var cellCountBeforeCelebrities:Int = 0
    var cellCountBeforeCharacters:Int = 0
    var cellCountBeforeSongs:Int = 0
    var cellCountBeforeSameNames:Int = 0
    var cellCountBeforeChildren:Int = 0
    var delegate: CNCardViewControllerDelegate?
    var isSelectedView:Bool = false
    var sameNames:[Any] = []
    var name:Name? {
        didSet {
            cellList = [Constants.cellName]
            let lastName = isMale ? (UserDefaults.standard.string(forKey: Constants.savedMaleLastName) ?? "") : (UserDefaults.standard.string(forKey: Constants.savedFemaleLastName) ?? "")
            let fatherName = isMale ? (UserDefaults.standard.string(forKey: Constants.savedMaleFatherName) ?? "") : (UserDefaults.standard.string(forKey: Constants.savedFemaleFatherName) ?? "")
            if lastName.count > 0 || fatherName.count > 0 {
                cellList.append(Constants.cellLastName)
            }
            if lastName.count > 0 && fatherName.count > 0 {
                cellList.append(Constants.cellInitialsTitle)
                cellList.append(Constants.cellInitials)
            }
            
            if let descriptionValue = name?.value, descriptionValue.count > 0 {
                cellList.append(Constants.cellDescriptionTitle)
                cellList.append(Constants.cellDescription)
            }

            if let vesionsValue = name?.vesions, vesionsValue.count > 0 {
                cellList.append(Constants.cellVersionsTitle)
                cellList.append(Constants.cellVersions)
            }
            
            if let nameTrans = name?.nameTrans, nameTrans.count > 0 {
                cellList.append(Constants.cellRuTitle)
                cellList.append(Constants.cellRu)
            } else if let nameEn = name?.nameEng, nameEn.count > 0 {
                cellList.append(Constants.cellEnTitle)
                cellList.append(Constants.cellEn)
            }
            
            if let nameLangs = name?.langs, nameLangs.count > 0 {
                cellList.append(Constants.cellLangsTitle)
                cellList.append(Constants.cellLangs)
            }
            
            if let daysValue = name?.days, daysValue.count > 0 {
                cellList.append(Constants.cellDaysTitle)
                cellList.append(Constants.cellDays)
            }
            if let celebrities = name?.celebrities, celebrities.count > 0 {
                cellList.append(Constants.cellCelebritiesTitle)
                cellCountBeforeCelebrities = cellList.count
                for _ in celebrities {
                    cellList.append(Constants.cellCelebrity)
                }
            }
            if let characters = name?.characters, characters.count > 0 {
                cellList.append(Constants.cellCharactersTitle)
                cellCountBeforeCharacters = cellList.count
                for _ in characters {
                    cellList.append(Constants.cellCharacters)
                }
            }
            if let songs = name?.songs, songs.count > 0 {
                cellList.append(Constants.cellSongsTitle)
                cellCountBeforeSongs = cellList.count
                for _ in songs {
                    cellList.append(Constants.cellSong)
                }
            }
            
            if let childner = name?.children, childner.count > 0 {
                cellList.append(Constants.cellChildrenTitle)
                cellCountBeforeChildren = cellList.count
                for _ in childner {
                    cellList.append(Constants.cellChild)
                }
            }
            
            if let same = name?.sameNames, same.count > 0 {
                sameNames = []
                cellList.append(Constants.cellSameTitle)
                let sameNamesList = same.components(separatedBy: ", ")
                cellCountBeforeSameNames = cellList.count
                for sameName in sameNamesList {
                    sameNames.append(sameName)
                    cellList.append(Constants.cellSame)
                    DataSource.instance.getSearchEqualResult(isMale: isMale, search: sameName) { (nameRecord) in
                        if let name = nameRecord {
                            self.updateSameName(name)
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        setupUI()
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateName(_:)), name: NSNotification.Name(rawValue: "updateName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSameName(_:)), name: NSNotification.Name(rawValue: "updateSameName"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func updateName(_ notification: NSNotification) {
        if let updatedNameID = notification.userInfo?["nameID"] as? String, updatedNameID == name?.nameID {
            DataSource.instance.getNameDB(updatedNameID, isMale, callblock: { (updatedName) in
                if updatedName != nil {
                    self.name = updatedName
                    self.tableView.reloadData()
                }
            })
        }
     }
    
    @objc func changeSameName(_ notification: NSNotification) {
        if let updatedSameNameID = notification.userInfo?["sameNameID"] as? String {
            DataSource.instance.getNameDB(updatedSameNameID, isMale, callblock: { (sameName) in
                if let sameName = sameName {
                    self.updateSameName(sameName)
                }
            })
        }
     }
    
    func setupUI() {
        bgGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        viewBg.layer.insertSublayer(bgGradient, at: 0)
        isMale ? setupBoyLayout() : setupGirlLayout()
        
        btnDetails.layer.borderWidth = 1
        btnDetails.layer.borderColor = (UIColor.init(named: "SecondaryTextColor") ?? UIColor.white).cgColor
        btnDetails.layer.cornerRadius = 10
        
        if name?.select == 1 || name?.select == -1 {
            btnLike.isHidden = true
            btnDislike.isHidden = true
            viewLike.isHidden = true
            viewDislike.isHidden = true
            constraintTableBottom.priority = UILayoutPriority(rawValue: 950)
        }
//        if isSelectedView {
//            btnDetails.isHidden = true
//            setupNavigationUI()
//            navigationCorntroller?.setNavigationBarHidden(false, animated: true)
//            constraintTableTop.priority = UILayoutPriority(rawValue: 950)
//        }
    }
    
    func setupNavigationUI() {
        title = "Favorites.Title".localized()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: (UIColor.init(named: "MainTextColor") ?? .white),
            NSAttributedString.Key.font: UIFont.init(name: "MontserratAlternates-Medium", size: 17) ?? UIFont.boldSystemFont(ofSize: 19)
        ]
        navigationController?.navigationBar.tintColor = UIColor.init(named: "MainTextColor") ?? .white
        navigationItem.setHidesBackButton(true, animated: true)
        let imgBack = UIImage(named:"arrow_left")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:imgBack, style:.plain, target:self, action:#selector(onBack))
    }
    
    @objc func onBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupBoyLayout() {
        bgGradient.colors = [(UIColor.init(named: "BoyGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "BoyGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        viewDislike.backgroundColor = UIColor.init(named: "Boy1Color")
        btnDislike.backgroundColor = UIColor.init(named: "Boy1Color")
        viewLike.backgroundColor = UIColor.init(named: "Boy2Color")
        btnLike.backgroundColor = UIColor.init(named: "Boy2Color")
    }
    
    func setupGirlLayout() {
        bgGradient.colors = [(UIColor.init(named: "GirlGradient1Color") ?? UIColor.blue).cgColor , (UIColor.init(named: "GirlGradient2Color") ?? UIColor.black).cgColor]
        bgGradient.locations = [0.0, 1.0]
        viewBg.layer.insertSublayer(bgGradient, at: 0)
        viewDislike.backgroundColor = UIColor.init(named: "Girl1Color")
        btnDislike.backgroundColor = UIColor.init(named: "Girl1Color")
        viewLike.backgroundColor = UIColor.init(named: "Girl2Color")
        btnLike.backgroundColor = UIColor.init(named: "Girl2Color")
    }
    
    func hideCard() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSameName(_ nameRecord:Name) {
        var list:[Any] = []
        var updatedIndex:Int?
        for (index, name) in sameNames.enumerated() {
            if let name = name as? String, name == nameRecord.name {
                list.append(nameRecord)
                updatedIndex = index
            } else if let name = name as? Name, name.name == nameRecord.name {
                list.append(nameRecord)
                updatedIndex = index
            } else {
                list.append(name)
            }
        }
        sameNames = list
        if let index = updatedIndex, Constants.isProd == true {
            let indexPath = IndexPath(row: cellCountBeforeSameNames + index, section: 0)
            tableView?.reloadRows(at: [indexPath], with: .none)
        } else {
            tableView?.reloadData()
        }
    }
    
    //MARK: Actions
    
    @IBAction func onHideCard(_ sender: Any) {
        hideCard()
    }
    
    @IBAction func onLike(_ sender: Any) {
        var shownCardsCount = UserDefaults.standard.integer(forKey: Constants.shownCardsCount)
        shownCardsCount += 1
        UserDefaults.standard.set(shownCardsCount, forKey: Constants.shownCardsCount)
        if delegate != nil {
            delegate?.likeName()
        } else {
            if let selectedNameID = name?.nameID {
                DataSource.instance.likeName(selectedNameID, isMale)
                let nameData:[String:String] = ["sameNameID": selectedNameID]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSameName"), object: nil, userInfo: nameData)
            }
        }
        hideCard()
    }
    
    @IBAction func onDisike(_ sender: Any) {
        var shownCardsCount = UserDefaults.standard.integer(forKey: Constants.shownCardsCount)
        shownCardsCount += 1
        UserDefaults.standard.set(shownCardsCount, forKey: Constants.shownCardsCount)
        if delegate != nil {
            delegate?.dislikeName()
        } else {
            if let selectedNameID = name?.nameID {
                DataSource.instance.dislikeName(selectedNameID, isMale)
                let nameData:[String:String] = ["sameNameID": selectedNameID]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSameName"), object: nil, userInfo: nameData)
            }
        }
        hideCard()
    }
    
    func onCopyNameID(_ nameID:String) {
        UIPasteboard.general.string = nameID
        let alert = UIAlertController(title:nil, message: "Card.IDCopied".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок".localized(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension CNCardViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastName = isMale ? (UserDefaults.standard.string(forKey: Constants.savedMaleLastName) ?? "") : (UserDefaults.standard.string(forKey: Constants.savedFemaleLastName) ?? "")
        let fatherName = isMale ? (UserDefaults.standard.string(forKey: Constants.savedMaleFatherName) ?? "") : (UserDefaults.standard.string(forKey: Constants.savedFemaleFatherName) ?? "")
        if cellList[indexPath.row] == Constants.cellName {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardNameTableViewCell", for: indexPath) as! CNCardNameTableViewCell
            cell.name = name?.name
            cell.nameID = name?.nameID
            cell.delegate = self
            return cell
        } else if cellList[indexPath.row] == Constants.cellLastName {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardLastNameTableViewCell", for: indexPath) as! CNCardLastNameTableViewCell
            cell.fullName = (name?.name ?? "") + " " + fatherName + ((lastName.count > 0) ? " " : "") + lastName
            return cell
        } else if cellList[indexPath.row] == Constants.cellInitialsTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.Initials".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellInitials {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardContentTableViewCell", for: indexPath) as! CNCardContentTableViewCell
            let nameFirst = String(name?.name?.first ?? "A")
            let fatherNameFirst = String(fatherName.first ?? "A")
            let lastNameFirst = String(lastName.first ?? "A")
            cell.content = lastNameFirst + nameFirst + fatherNameFirst + ", " + nameFirst + fatherNameFirst + lastNameFirst + "\n" + nameFirst + ". " + fatherNameFirst + ". " + lastName + ", " + lastName + " " + nameFirst + ". " + fatherNameFirst + "."
            return cell
        } else if cellList[indexPath.row] == Constants.cellVersionsTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.Versions".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellVersions {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardContentTableViewCell", for: indexPath) as! CNCardContentTableViewCell
            cell.content = name?.vesions ?? ""
            return cell
        } else if cellList[indexPath.row] == Constants.cellDescriptionTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.Description".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellDescription {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardContentTableViewCell", for: indexPath) as! CNCardContentTableViewCell
            cell.content = name?.value ?? ""
            return cell
        } else if cellList[indexPath.row] == Constants.cellEnTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = UIImage.init(named: "flag_en")
            cell.title = "Card.EnVersion".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellEn {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardContentTableViewCell", for: indexPath) as! CNCardContentTableViewCell
            cell.content = name?.nameEng ?? ""
            return cell
        } else if cellList[indexPath.row] == Constants.cellRuTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.title = "Card.TransVersion".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellRu {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardContentTableViewCell", for: indexPath) as! CNCardContentTableViewCell
            cell.content = name?.nameTrans ?? ""
            return cell
        } else if cellList[indexPath.row] == Constants.cellDaysTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.NameDays".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellDays {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardContentTableViewCell", for: indexPath) as! CNCardContentTableViewCell
            cell.content = name?.days ?? ""
            return cell
        } else if cellList[indexPath.row] == Constants.cellCelebritiesTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.FamousPersons".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellCelebrity {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardCelebrityTableViewCell", for: indexPath) as! CNCardCelebrityTableViewCell
            if let celebs = name?.celebrities, celebs.count > (indexPath.row - cellCountBeforeCelebrities) {
                cell.celebrity = celebs[indexPath.row - cellCountBeforeCelebrities]
            }
            return cell
        } else if cellList[indexPath.row] == Constants.cellCharactersTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.Characters".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellCharacters {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardCelebrityTableViewCell", for: indexPath) as! CNCardCelebrityTableViewCell
            if let characters = name?.characters, characters.count > (indexPath.row - cellCountBeforeCharacters) {
                cell.character = characters[indexPath.row - cellCountBeforeCharacters]
            }
            return cell
        } else if cellList[indexPath.row] == Constants.cellSongsTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.Media".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellSong {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardSongTableViewCell", for: indexPath) as! CNCardSongTableViewCell
            if let songs = name?.songs, songs.count > (indexPath.row - cellCountBeforeSongs) {
                cell.song = songs[indexPath.row - cellCountBeforeSongs]
            }
            return cell
        } else if cellList[indexPath.row] == Constants.cellSameTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.Same".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellSame {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardSameNameTableViewCell", for: indexPath) as! CNCardSameNameTableViewCell
            if sameNames.count > (indexPath.row - cellCountBeforeSameNames) {
                if let name = sameNames[indexPath.row - cellCountBeforeSameNames] as? String {
                    cell.name = name
                } else if let name = sameNames[indexPath.row - cellCountBeforeSameNames] as? Name {
                    if let descript = name.value, descript.count > 0 {
                        cell.nameRecord = name
                    } else {
                        cell.name = name.name
                    }
                }
                cell.isLast = indexPath.row == cellCountBeforeSameNames + sameNames.count - 1
            }
            return cell
        } else if cellList[indexPath.row] == Constants.cellLangsTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Варіанти імені мовами світу"
            return cell
        } else if cellList[indexPath.row] == Constants.cellLangs {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardLangsTableViewCell", for: indexPath) as! CNCardLangsTableViewCell
            cell.content = name?.langs
            return cell
        } else if cellList[indexPath.row] == Constants.cellChildrenTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardTitleTableViewCell", for: indexPath) as! CNCardTitleTableViewCell
            cell.icon = nil
            cell.title = "Card.Children".localized()
            return cell
        } else if cellList[indexPath.row] == Constants.cellChild {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardChildTableViewCell", for: indexPath) as! CNCardChildTableViewCell
            cell.child = name?.children[0]
            if let children = name?.children, children.count > (indexPath.row - cellCountBeforeChildren) {
                cell.child = children[indexPath.row - cellCountBeforeChildren]
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CNCardNameTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row - cellCountBeforeSameNames
        if index >= 0 && index < sameNames.count {
            if let name = sameNames[index] as? Name {
                if let vc = UIStoryboard.load(controller: .card) as? CNCardViewController {
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.isMale = self.isMale
                    vc.name = name
                    present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
}
