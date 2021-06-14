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
    private let storge = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["Starters", "Main dishes", "desserts"]
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
        _ = storge.child(email + "/file" + String(counter) + ".png").putData(imageData, metadata: nil, completion: {_, error
            in guard error == nil else{
            print("failed to upload")
            return
        }
        self.storge.child(email + "/file" + String(self.counter) + ".png").downloadURL(completion: {url, error in
            guard let url = url, error == nil
            else{
                return
            }
            let urlString = url.absoluteString
            print("downloadURL")
            UserDefaults.standard.set(urlString, forKey: "url")
        })
        })
        counter+=1
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
}

    
  

