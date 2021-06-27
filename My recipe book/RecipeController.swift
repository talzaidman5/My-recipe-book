//
//  File.swift
//  My recipe book
//
//  Created by bobo on 13/06/2021.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

class RecipeController: UIViewController{
    
    @IBOutlet weak var recipe_TXT_name: UITextField!
    @IBOutlet weak var recipe_TXT_ingredients: UITextField!
    @IBOutlet weak var recipe_TXT_type: UILabel!
    @IBOutlet weak var recipre_BTN_finishEdit: UIButton!
    @IBOutlet weak var recipe_BTN_delete: UIButton!
    @IBOutlet weak var recipte_BTN_edit: UIButton!
    var name = ""
    var ingredients = ""
    var type = ""
    @IBOutlet weak var recipe_image: UIImageView!
    let storage = Storage.storage()
    var imageEditing = UIImage()
    var imageEdit = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name =  UserDefaults.standard.string(forKey: "name")!
        self.ingredients =  UserDefaults.standard.string(forKey: "ingredients")!
        self.type =  UserDefaults.standard.string(forKey: "type")!
        recipe_TXT_name.isEnabled = false
        recipe_TXT_ingredients.isEnabled = false
        recipe_TXT_type.text = "Type: " + type
        recipe_TXT_name.text = name
        recipe_TXT_ingredients.text =  ingredients
        recipre_BTN_finishEdit.isHidden = true
        readImages()
        imageEditing = #imageLiteral(resourceName: "check-mark")
        imageEdit = #imageLiteral(resourceName: "edit")
    }
    func readImages(){
         let storge = Storage.storage().reference()
        storge.child(ViewController.user!.email! + "/" + name + ".png").getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            } else {
              let image = UIImage(data: data!)
              self.recipe_image.image = image
        }
        }
        }
    
    @IBAction func finishEdit(_sender : Any){
      
        let db = Firestore.firestore()
            let user = db.collection("Users").whereField("email", isEqualTo: ViewController.user?.email as Any)
            user.getDocuments(completion: { [self] (result, err) in
                if err != nil {
                    print("Error getting documents")
                } else {
                    let recipe = Recipe(name: self.recipe_TXT_name.text!,ingredients: self.recipe_TXT_ingredients.text!, type:
                                        self.type)
                    db.collection("Users").document((ViewController.user?.email)!).collection("recipes").addDocument(data: [
                                                                                                                        "name": recipe.name as Any,
                                                                                                                        "ingredients": recipe.ingredients as Any, "type": recipe.type as Any])
                    dismiss(animated: true, completion: nil)
                
            }
            })
        recipe_TXT_name.isEnabled = !recipe_TXT_name.isEnabled
        recipe_TXT_ingredients.isEnabled = !recipe_TXT_ingredients.isEnabled
        recipte_BTN_edit.setImage(imageEdit, for: .normal)
        recipre_BTN_finishEdit.isHidden = false
    }
    @IBAction func editClicked(_sender : Any){
        recipe_TXT_name.isEnabled = !recipe_TXT_name.isEnabled
        recipe_TXT_ingredients.isEnabled = !recipe_TXT_ingredients.isEnabled
        if(recipe_TXT_ingredients.isEnabled){
            recipte_BTN_edit.setImage(imageEditing, for: .normal)
        }
        else{
            recipte_BTN_edit.setImage(imageEdit, for: .normal)

        }
    }
    @IBAction func deleteRecipe(_sender : Any){
        let db = Firestore.firestore()
        db.collection("Users").document((ViewController.user?.email)!).collection("recipes").getDocuments() { (document, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  for document in document!.documents {
                      let nameRecipe = document.get("name") as! String
                    if(nameRecipe == self.name){
                        db.collection("Users").document((ViewController.user?.email)!).collection("recipes").document(document.documentID).delete()
                    }
                  }
              }
        }
    }
}
