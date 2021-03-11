//
//  ThemesViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 06.03.2021.
//

import UIKit

protocol ThemeProtocol {
    func changeTheme(name: String)
}

class ThemesViewController: UIViewController {
    //MARK: - Properties
    var delegate : ThemeProtocol?
    var themeSelected: ((String)->())?
    
    
    //UI objects
    lazy var dayButton : ThemeButton = {
        let button = ThemeButton()
        button.formView.backgroundColor = UIColor(red: 1.00, green: 0.98, blue: 0.98, alpha: 1.00)
        button.bubbleViewTwo.backgroundColor = UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
        button.textLabel.text = "Day"
        return button
    }()
    lazy  var nightBar  : ThemeButton = {
        let button = ThemeButton()
        button.formView.backgroundColor = .black
        button.textLabel.text = "Night"
        button.bubbleViewOne.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        button.bubbleViewTwo.backgroundColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
        return button
    }()
    let myButton = ThemeButton()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "Settings"
        createDesign()
    }
    
    deinit {
        print("deinit theme view ")
    }
    
    
    //MARK: - Helpers
    
    fileprivate func createDesign() {
        view.backgroundColor = Theme.current.backgroundColor
        
        // StackView
        let stackView = UIStackView(arrangedSubviews: [myButton, dayButton, nightBar])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            stackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        if let theme = UserDefaults.standard.string(forKey: "theme") {
            switch theme {
            case "Classic":
                self.myButton.formView.layer.borderColor = UIColor(red: 0, green: 0.55, blue: 0.55, alpha: 1).cgColor
                self.myButton.formView.layer.borderWidth = 3
            case "Day":
                self.dayButton.formView.layer.borderColor = UIColor(red: 0, green: 0.55, blue: 0.55, alpha: 1).cgColor
                self.dayButton.formView.layer.borderWidth = 3
            default:
                self.nightBar.formView.layer.borderColor = UIColor(red: 0, green: 0.55, blue: 0.55, alpha: 1).cgColor
                self.nightBar.formView.layer.borderWidth = 3
            }
        }

        nightBar.addTarget(self, action: #selector(changeMode(sender:)), for: .touchUpInside)
        myButton.addTarget(self, action: #selector(changeMode(sender:)), for: .touchUpInside)
        dayButton.addTarget(self, action: #selector(changeMode(sender:)), for: .touchUpInside)
      

    }
    
    private func checkSelectedTheme(theme: String){
        switch theme {
        case "Classic":
            self.dayButton.formView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
            self.dayButton.formView.layer.borderWidth = 1
            self.nightBar.formView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
            self.nightBar.formView.layer.borderWidth = 1
        
        case "Night":
            self.myButton.formView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
            self.myButton.formView.layer.borderWidth = 1
            self.dayButton.formView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
            self.dayButton.formView.layer.borderWidth = 1
            
        default:
            self.myButton.formView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
            self.myButton.formView.layer.borderWidth = 1
            self.nightBar.formView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
            self.nightBar.formView.layer.borderWidth = 1
        }
    }
    
  //MARK: - Selectors

    @objc func changeMode(sender: ThemeButton) {
        //Сохранение название темы
        UserDefaults.standard.setValue(sender.textLabel.text, forKey: "theme")
        checkSelectedTheme(theme: sender.textLabel.text ?? "Day")
        
        //Замыкание
        themeSelected?(sender.textLabel.text ?? "")
        
        //Делегирование - Для проверки раскомментировать
//        guard let delegate = delegate else { return }
//        delegate.changeTheme(name: sender.textLabel.text ?? "vns")
//
        self.createDesign()
        UIApplication.shared.windows.reload()
      
    }
   
    
}

