//
//  HomeController.swift
//  My recipe book
//
//  Created by bobo on 05/06/2021.
//

import Foundation
import  UIKit
import Firebase
class HomeController : UIViewController{
    @IBOutlet weak var home_txt_name: UILabel!
   static var recipeList = [Recipe]()
    var recipe = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        home_txt_name.text = "Hi " + (ViewController.user?.name!)!
        InitTable()
    }
    func InitTable(){
       let db = Firestore.firestore()
        db.collection("Users").document((ViewController.user?.email)!).collection("recipes").getDocuments(){ [self] (querySnapshot, err) in
           if let err = err {
               print("Error getting documents: \(err)")
           } else {
               for document in querySnapshot!.documents {
                let recipe =  self.InitRecipe(recipe: document.data());
                HomeController.recipeList.append(recipe)
               }
           }
       }

   }
    func InitRecipe(recipe: [String: Any]) -> Recipe{
        return Recipe(name: Array(recipe.values)[1] as! String, ingredients: Array(recipe.values)[0] as! String, type: Array(recipe.values)[2]  as! String)
    

    }

}
