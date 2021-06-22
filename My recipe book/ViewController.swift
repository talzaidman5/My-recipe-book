//
//  ViewController.swift
//  My recipe book
//
//  Created by bobo on 03/06/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var signIn_txt_password: UITextField!
    @IBOutlet weak var signIn_txt_mail: UITextField!
    static var user : User?
    @IBOutlet weak var signIn_txt_error: UILabel!
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if FirebaseApp.app() == nil { FirebaseApp.configure()}

    }
    @IBAction func signIn(_sender : Any){
         email = self.signIn_txt_mail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.signIn_txt_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if (error != nil){
                self.signIn_txt_error.text = error!.localizedDescription
                self.signIn_txt_error.textColor = UIColor.red
            }
            else {
                let db = Firestore.firestore()

                db.collection("Users").getDocuments() { (document, err) in
                      if let err = err {
                          print("Error getting documents: \(err)")
                      } else {
                          for document in document!.documents {
                              let emailUser = document.get("email") as! String
                            if(emailUser == self.email){
                                let name = document.get("name") as! String
                                let password = document.get("password") as! String
                                ViewController.user = User (email: self.email, name: name, pass: password)
                            }
                          }
                      }
                   self.getDataToSignIn(email : self.email)
            }
        }
        }
    }
    func getDataToSignIn(email : String){
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                self.present(nextViewController, animated:true, completion:nil)
        }
    }



    extension UIViewController {
        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}



