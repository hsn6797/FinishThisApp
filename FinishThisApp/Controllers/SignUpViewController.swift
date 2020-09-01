//
//  SignUpViewController.swift
//  FinishThisApp
//
//  Created by Hassan on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SVProgressHUD

class SignUpViewController:UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorL: UILabel!
    @IBOutlet weak var Create_button: UIButton!
    @IBOutlet weak var verifyBtn: UIButton!
    
    
    
    var USER_ID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        verifyBtn.isHidden = true
        self.navigationItem.title = "Sign Up"
        
        // TAP gesture
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        
        
    }
    
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func CreateAccountB(_ sender: UIButton) {
        
 
        let emailText = emailTF.text!
        let PasswordText = passwordTF.text!
        if emailText != "" && PasswordText != ""{
            
            let user = Auth.auth().createUser(withEmail:emailText , password:PasswordText , completion: {
                result, err in
                if err != nil{
                    // Error
                }
                else{
                    
                    self.USER_ID = result!.user.uid;
                    
                    result!.user.sendEmailVerification { (error) in
                        guard let error = error else{
                            self.Create_button.isHidden = true
                            self.verifyBtn.isHidden = false
                            self.Alert(Message: "Please check your email and click the verfication link that we've sent you \n then Press Create to Proceed", title: "Email Verification")
                            return print("Verfication sent")
                            
                        }
                    }
                    
                }
            })
        }
        else{
            self.Alert(Message: "Kindly type your email & password", title: "Error!")
        }
        
        
        
    }
    
    @IBAction func VerifyEmailButton(_ sender: Any) {
        
        guard let userAuth = Auth.auth().currentUser else{return}
        
        userAuth.reload { (error) in
            SVProgressHUD.show()
            switch userAuth.isEmailVerified {
            case true:
                print("User Email is verified")
                                let db = Firestore.firestore()
                                let user = User()
                                user.userID = userAuth.uid
                                user.userName = self.usernameTF.text!
                                user.email = self.emailTF.text!
                                user.password = self.passwordTF.text!
                                db.add(user: user)
                SVProgressHUD.dismiss()
                let sb = UIStoryboard(name: "Home",bundle: nil)
                if let HomeVC = sb.IIVC(vc: HomeViewController(),id: "Home_VC"){
                    self.navigationController?.pushViewController(HomeVC, animated: true)
                }
                
                
            case false:
                SVProgressHUD.dismiss()
                self.Alert(Message: "You did'nt verify your email\nkindly re-enter your email", title: "Oops..!")
                print("User is not verified")
                self.verifyBtn.isHidden = true
                self.Create_button.isHidden = false
                self.emailTF.text = ""
                self.passwordTF.text = ""
                
                userAuth.delete(completion: { (error) in
                    if let error = error{
                        
                    }
                    else{
                        print("user deleted Successfully")
                    }
                })
                
            }

        }
        
        
    }
    
    func Alert (Message: String,title:String){
        
        let alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func BackB(_ sender: UIButton) {
//        let sb = UIStoryboard(name: "Main",bundle: nil)
//        if let s = sb.IIVC(vc: LoginViewController(),id: "login_vc"){
//        self.navigationController?.pushViewController(s, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}
