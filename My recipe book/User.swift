//
//  User.swift
//  My recipe book
//
//  Created by bobo on 03/06/2021.
//

import Foundation

class User : Codable{
    var name : String?
    var email : String?
    var password : String?
    
    init( email : String, name : String, pass : String){
        self.name = name
        self.password = pass
        self.email = email
    }
    var dictionary : [String:Any] {
        return [
             "name" : self.name ?? "","email" : self.email ?? "", "password" : self.password ?? ""
        ]
    }

    func encodable() -> Dictionary<String, Any>{
        return
            [ "name" : self.name ?? "","email" : self.email ?? "", "password" : self.password ?? ""]
    }
}
