//
//  NewRecipe.swift
//  My recipe book
//
//  Created by bobo on 13/06/2021.
//
import UIKit
import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage

class NewRecipe: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var recipe : Recipe?
    var type : String = ""
    var counter : Int = 1
    @IBOutlet weak var newRecipe_pickerView_category: UIPickerView!
    var pickerData = [String]()
    var images = [String]()
    @IBOutlet weak var newRecipe_TXT_name: UITextField!
    @IBOutlet weak var newRecipe_TXT_ingredients: UITextView!
    @IBOutlet weak var newRecipe_BTN_add: UIButton!
    @IBOutlet weak var newRecipe_txt_error: UILabel!
    var result = [String]()
    private let storge = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllRecipeName()
        newRecipe_txt_error.text = ""
        pickerData = ["Starters", "Main dishes", "Desserts"]
        newRecipe_pickerView_category.dataSource = self
        newRecipe_pickerView_category.delegate = self
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = pickerData[row]
    }
    @IBAction func AddRecipe(_sender : Any){

    let db = Firestore.firestore()
        if(checkRecipe() == true){
        let user = db.collection("Users").whereField("email", isEqualTo: ViewController.user?.email as Any)
        user.getDocuments(completion: { [self] (result, err) in
            if err != nil {
                print("Error getting documents")
            } else {
                if self.type == ""{
                    self.type = self.pickerData[0]
                }
                let recipe = Recipe(name: self.newRecipe_TXT_name.text!,ingredients: self.newRecipe_TXT_ingredients.text!, type:
                                    self.type)
                db.collection("Users").document((ViewController.user?.email)!).collection("recipes").addDocument(data: [
                                                                                                                    "name": recipe.name as Any,
                                                                                                                    "ingredients": recipe.ingredients as Any, "type": recipe.type as Any])
                dismiss(animated: true, completion: nil)
            }
        })
        }
        }
func getAllRecipeName()
    {
    let db = Firestore.firestore()

    db.collection("Users").document((ViewController.user?.email)!).collection("recipes").getDocuments() { (document, err) in
          if let err = err {
              print("Error getting documents: \(err)")
          } else {
              for document in document!.documents {
                  let name = document.get("name") as! String
                    self.result.append(name)
              }
          }
    }
    }
    func checkRecipe()-> Bool{
        if(self.newRecipe_TXT_name.text == nil){
            newRecipe_txt_error.text = "Please fill in the name of the recipe"
            return false
        }
        if(self.newRecipe_TXT_ingredients.text == "Ingredients"){
            newRecipe_txt_error.text = "Please fill in the ingredients of the recipe"
            return false
        }
        for name in self.result {
            if(name == self.newRecipe_TXT_name.text){
                  self.newRecipe_txt_error.text = "Name already exists"
                  return false
              }
            }
        return true
    }

    @IBAction func UploadPhotos(_sender : Any){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil )
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage]as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        let email = (ViewController.user?.email)!
            storge.child(email + "/" + newRecipe_TXT_name.text! + ".png").putData(imageData, metadata: nil, completion: {_, error
            in guard error == nil else{
            print("failed to upload")
            return
        }
    })
        counter+=1
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
}

    
  

