//
//  UserProfileModel.swift
//  Besedka
//
//  Created by Ivan Kopiev on 15.03.2021.
//

import Foundation

struct UserProfileModel: Codable{
    var name: String?
    var aboutMe: String?
    var city: String?
    
    public mutating func initFromFile() {
        
        guard let path = Bundle.main.path(forResource: "userProfile", ofType: "json")  else {return}
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonDataFile = try Data(contentsOf: url)
            let user = try JSONDecoder().decode(UserProfileModel.self, from: jsonDataFile)
            self.name = user.name
            self.aboutMe = user.aboutMe
            self.city = user.city
        } catch{
            print(error)
        }
    }
    
    public func saveToFile(name: String){
        //write
        guard  let path = Bundle.main.path(forResource: name, ofType: "json") else { return}
        let url = URL(fileURLWithPath: path)
        try? JSONEncoder().encode(self).write(to: url)
    }
}
    
class DispatchGC {
    
    private let queque = DispatchQueue(label: "GetData", qos: .utility, attributes: .concurrent)
    
    //
    public func getUserProfile() -> UserProfileModel {
        
        guard let path = Bundle.main.path(forResource: "userProfile", ofType: "json")  else {return UserProfileModel()}
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonDataFile = try Data(contentsOf: url)
            let user = try JSONDecoder().decode(UserProfileModel.self, from: jsonDataFile)
            return user
        } catch{
            print(error)
            return UserProfileModel()
        }
    }
}


