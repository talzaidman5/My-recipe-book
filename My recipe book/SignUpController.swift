//
//  SignUpController.swift
//  My recipe book
//
//  Created by bobo on 03/06/2021.
//
import UIKit
import Firebase
import FirebaseAuth

class SignUpController : UIViewController{
    
    @IBOutlet weak var signUp_txt_mail: UITextField!
    @IBOutlet weak var signUp_txt_name: UITextField!
    @IBOutlet weak var signUp_txt_password: UITextField!

    @IBAction func signUp(_sender : Any){
        if FirebaseApp.app() == nil { FirebaseApp.configure()}
        let userName = signUp_txt_name.text!
        let passwrod = signUp_txt_password.text!
        let email = signUp_txt_mail.text!
        Auth.auth().createUser(withEmail: email, password: passwrod){(result,err) in
            if err != nil{
                self.signUp_txt_name.text = err?.localizedDescription
                self.signUp_txt_name.textColor = UIColor.red
            }
            if (result != nil){
                let db = Firestore.firestore()
                    let user = User(email: email, name: userName, pass: passwrod)
                    db.collection("Users").document(email).setData(user.encodable())
                let dict = ["email": user.email,
                            "name": user.name]

                db.collection("users").addDocument(data: dict as [String : Any])

                    self.goToSignIn()
                }
            }


    }
    
  
func goToSignIn(){
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
    self.present(nextViewController, animated:true, completion:nil)
}


}




