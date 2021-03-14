//
//  EditSettingView.swift
//  Besedka
//
//  Created by Ivan Kopiev on 13.03.2021.
//

import UIKit

class EditSettingView: UIView {
    //NARK: - Properties
    lazy var form: UIView = {
        let view = UIView()
        view.addCornerRadius(14)
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var centerYAnc = NSLayoutConstraint()
    
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = self.frame.height / 2
        imageView.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        return imageView
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        createDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createDesign()
    }
    
    convenience init(frame: CGRect, imageView: UIImageView){
        self.init(frame: frame)
        self.avatarImageView = imageView
        createDesign()

        
    }
    
//MARK: - Helpers
    private func createDesign(){
        
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        let tapReconizer = UITapGestureRecognizer(target: self, action: #selector(hide))
        addGestureRecognizer(tapReconizer)
//        addGradientBackgroundColor()
//        applyBlurEffect()
        addSubview(form)
        addSubview(avatarImageView)
        createConstraints()
    }
    
    private func createConstraints(){

        
        NSLayoutConstraint.activate([
            
            self.avatarImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            self.avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            self.avatarImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            self.avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
            
            form.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height/6),
            form.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.width/8),
            form.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.frame.width/8),
            form.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.frame.height/6),

        ])

  
    }
    
    func addGradientBackgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor(red: 121/255, green: 22/255, blue: 211/255, alpha: 0.5).cgColor,UIColor(red: 58/255, green: 67/255, blue: 235/255, alpha: 0.5).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at:0)
    }
    
    @objc func hide(){
        self.isHidden = true
        
    }
}
