//
//  AllRecipeController.swift
//  My recipe book
//
//  Created by bobo on 13/06/2021.
//

import Foundation
import UIKit
import  Firebase
import FirebaseFirestore

class AllRecipeController:  UIViewController  {
   var homeController = HomeController()
    var temp : Recipe!
    @IBOutlet weak var allRecipe_BTN_starters: UIButton!
    @IBOutlet weak var allRecipe_BTN_mainDishes: UIButton!
    @IBOutlet weak var allRecipe_BTN_desserts: UIButton!
    var listToUpdate : [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func updateTableMainDishes(_sender : Any){
        update(typeClick: "Main dishes")
    }
    @IBAction func updateTableDesserts(_sender : Any){
        update(typeClick: "Desserts")
    }
    
    @IBAction func updateTable(_sender : Any){
        update(typeClick: "Starters")
    }
    func update(typeClick: String){
        let db = Firestore.firestore()
       db.collection("Users").document((ViewController.user?.email)!).collection("recipes").getDocuments() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.listToUpdate.removeAll()
                for document in document!.documents {
                    let type = document.get("type") as! String
                    if(type == typeClick){
                        self.temp = Recipe(name: document.get("name") as!String, ingredients: document.get("ingredients") as! String,type: document.get("type") as!String)
                        self.listToUpdate.append(self.temp)
                    }
                }
            }
            self.UpdateTableList(typeClick: self.listToUpdate)
    }
    }
    func UpdateTableList(typeClick: [Recipe]){
        HomeController.recipeList = typeClick
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TableRowController") as! TableRowController
        self.present(nextViewController, animated:true, completion:nil)

    }

}
