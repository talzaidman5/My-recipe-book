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

class AllRecipeController:  UIViewController, UITableViewDelegate,UITableViewDataSource  {
    var recipeList : [Recipe]!
    @IBOutlet weak var allRecipe: UITableView!
   var homeController = HomeController()
    let cellId = "recipe"
    var temp : Recipe!
    @IBOutlet weak var allRecipe_BTN_starters: UIButton!
    @IBOutlet weak var allRecipe_BTN_mainDishes: UIButton!
    @IBOutlet weak var allRecipe_BTN_desserts: UIButton!
    var listToUpdate : [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeList = HomeController.recipeList;
        setupTable()
    }


    func setupTable(){
        allRecipe.delegate = self
        allRecipe.dataSource = self
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            OpenRecipe(index: indexPath.row)
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.recipeList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          var cell : Cell? = self.allRecipe.dequeueReusableCell(withIdentifier: cellId) as? Cell
          
        cell?.cell_LBL_name?.text = String(recipeList[indexPath.row].name!)
          
          if(cell == nil){
              cell = Cell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
          }
        return cell!
    }
    func OpenRecipe(index : Int){
        UserDefaults.standard.set(self.recipeList[index].name, forKey: "name")

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RecipeController") as! RecipeController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func updateTable(_sender : Any){
        update(typeClick: "Starers")
    }
    func update(typeClick: String){
        let db = Firestore.firestore()
       db.collection("Users").document((ViewController.user?.email)!).collection("recipes").getDocuments() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in document!.documents {
                    let type = document.get("type") as! String
                    if(type == typeClick){
                        self.temp = Recipe(name: document.get("name") as! String,
                                                 ingredients: document.get("ingredients") as! String,
                                                 type: document.get("type") as! String)
                        self.listToUpdate.append(self.temp)
                        print("***" ,self.temp)
                      
                        
                    }

                }
            }
       
            self.UpdateTableList(typeClick: self.listToUpdate)
    }
    
    }
    func UpdateTableList(typeClick: [Recipe]){
    }

}
