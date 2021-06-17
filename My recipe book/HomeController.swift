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
                let recipe =  self.InitRecipe(document: document)
                HomeController.recipeList.append(recipe)
               }
           }
       }

   }
    func InitRecipe(document: QueryDocumentSnapshot) -> Recipe{
        return Recipe(  name: document.get("name") as! String,
                                 ingredients: document.get("ingredients") as! String,
                                 type: document.get("type") as! String)
    }

}
