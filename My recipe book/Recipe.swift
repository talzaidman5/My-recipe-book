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
    


    var name : String?
    var ingredients : String?
    var type : String?
    var photos = [String]()

    init( name : String, ingredients : String, type : String){
        self.name = name
        self.ingredients = ingredients
        self.type = type
    }
    
    func encodable() -> Dictionary<String, Any>{
        return
            [ "name" : self.name ?? "","ingredients" : self.ingredients ?? "", "photos" : self.photos ]
    }
    

}
