//
//  LoginViewController.swift
//  FinishThisApp
//
//  Created by Asad on 26/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth
import FBSDKLoginKit
import SVProgressHUD


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var facebook_Login: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        if FBSDKAccessToken.current() != nil{
//            FBSDKAccessToken.setCurrent(nil)
//        }
        let loginButton = FBSDKLoginButton()
        myView.addSubview(loginButton)
        loginButton.frame = CGRect(x: 40, y: 400, width: myView.frame.width - 75, height: 50)
        loginButton.delegate = self
        
        if Auth.auth().currentUser != nil {
            print("USER::::::::::::::::::: Already logged in" + (Auth.auth().currentUser?.uid)!)
            let userId = (Auth.auth().currentUser?.uid)!
                let sb = UIStoryboard(name: "Home",bundle: nil)
                if let homeVC = sb.IIVC(vc: HomeViewController(),id: "Home_VC"){
                    homeVC.USERID = userId
                    self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
            
        else {
    
        }
        
        
        }
       
        // Do any additional setup after loading the view.

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        else{
            if result.isCancelled{
                print("Cancelled")
            }
            else{
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print("Facebook authentication with Firebase error: ", error)
                        return
                    }
                    print("User signed in!")
                    let userName = user?.displayName!
                    let userID = user?.uid
                    
                    let db = Firestore.firestore()
                    let user = User()
                    user.userID = userID!
                    user.userName = userName!
                    user.email = self.emailTF.text!
                    user.password = self.passwordTF.text!
                    db.add(user: user)
                    
                    let sb = UIStoryboard(name: "Home",bundle: nil)
                    if let homeVC = sb.IIVC(vc: HomeViewController(),id: "Home_VC"){
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                }

            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out Successfully")
    }
    
    
    fileprivate func presentLoginController() {
        
      let email = emailTF.text
      let password = passwordTF.text
        
           if email != "" && password != ""{
            
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] authResult, error in
                
                if(error != nil){
                    return
                }
                
                guard let strongSelf = self else { return }
                
                print("LogedIn!!!!!!!!")
                
                Firestore.firestore().getCurrentUser(userID: authResult!.user.uid ,completionHandler: {
                    user in
                    
                    print("ID is:  --> "+user.userID)
                    print("Username is:  --> "+user.userName)
                })
                
                
                let sb = UIStoryboard(name: "Home",bundle: nil)
                if let homeVC = sb.IIVC(vc: HomeViewController(),id: "Home_VC"){
                    strongSelf.navigationController?.pushViewController(homeVC, animated: true)
                }
                
                
            }
        }
        else{
            
            
        }
        

    }
        
    @IBAction func SignupB(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main",bundle: nil)
        if let signUpVC = sb.IIVC(vc: SignUpViewController(),id: "signup_vc"){
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    @IBAction func FacebookB(_ sender: UIButton) {
    }
    @IBAction func LoginB(_ sender: UIButton) {
        presentLoginController()
    }

}
