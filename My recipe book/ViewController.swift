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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if FirebaseApp.app() == nil { FirebaseApp.configure()}

    }
    @IBAction func signIn(_sender : Any){
        let email = self.signIn_txt_mail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.signIn_txt_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if (error != nil){
                self.signIn_txt_mail.text = error!.localizedDescription
                self.signIn_txt_mail.textColor = UIColor.red
            }
            else {
                self.getDataToSignIn(email : email)
            }
        }

    }
    func getDataToSignIn(email : String){
        let db = Firestore.firestore()
        let user = db.collection("Users").document(email)
        user.getDocument { (result, error) in
            if (error != nil){
                self.signIn_txt_mail.text = error!.localizedDescription
                self.signIn_txt_mail.textColor = UIColor.red
            }
            else {
                self.initClient(email : email, result : result!)
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                self.present(nextViewController, animated:true, completion:nil)
                
            }
            }
        }
    
    func initClient(email : String, result : DocumentSnapshot){
        let name = result.get("name") as! String
        let email = result.get("email") as! String
        let password = result.get("password") as! String
        ViewController.user = User(email: email, name: name, pass: password)
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



