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
    
    @IBOutlet weak var recipe_TXT_name: UILabel!
    @IBOutlet weak var recipe_TXT_type: UILabel!
    
    @IBOutlet weak var recipe_BTN_delete: UIButton!
    var name = ""
    var ingredients = ""
    @IBOutlet weak var recipe_image: UIImageView!
    let storage = Storage.storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.name =  UserDefaults.standard.string(forKey: "name")!
        self.ingredients =  UserDefaults.standard.string(forKey: "ingredients")!

        recipe_TXT_name.text = name
        recipe_TXT_type.text =  ingredients
        readImages()
    }
    func readImages(){
         let storge = Storage.storage().reference()
        storge.child(ViewController.user!.email! + "/" + name + ".png").getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            } else {
              let image = UIImage(data: data!)
              self.recipe_image.image = image
                print("downloadURL")
        }
        }
        }
    @IBAction func editClicked(_sender : Any){
        
        
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
