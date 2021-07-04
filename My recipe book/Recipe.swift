//
//  Recipe.swift
//  My recipe book
//
//  Created by bobo on 13/06/2021.
//

import Foundation
class Recipe : Codable , Equatable{
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.name == rhs.name
    }
    

    var imageID : String?
    var name : String?
    var ingredients : String?
    var type : String?

    init( name : String, ingredients : String, type : String, id : String){
        self.name = name
        self.ingredients = ingredients
        self.type = type
        self.imageID = id
    }
     static func setID() -> String{
        return UUID().uuidString
    }
    func encodable() -> Dictionary<String, Any>{
        return
            [ "name" : self.name ?? "","ingredients" : self.ingredients ?? "", "imageID" : self.imageID ?? "" ]
    }
    func setImageID(id : String){
        
        self.imageID = id
    }
    

}
