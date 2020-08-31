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
import GoogleMobileAds


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var MobAdView: UIView!
    var bannerView: GADBannerView!
    
    var BannerID_1  = "ca-app-pub-3940256099942544/2934735716"
    let GadSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Banner Work Here
        
        bannerView = GADBannerView(adSize: GadSize)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = BannerID_1
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self as? GADBannerViewDelegate
        
        ////////////////////////****************************//////////////////////////////
//        
//        if FBSDKAccessToken.current() != nil{
//            FBSDKAccessToken.setCurrent(nil)
//        }
        let loginButton = FBSDKLoginButton()
        myView.addSubview(loginButton)
        loginButton.frame = CGRect(x: 40, y: 350, width: myView.frame.width - 75, height: 50)
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
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        MobAdView.addSubview(bannerView)
      
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
       
        // Do any additional setup after loading the view.

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
         SVProgressHUD.show()
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
                    SVProgressHUD.dismiss()
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
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] authResult, error in
                
                if(error != nil){
                    SVProgressHUD.dismiss()
                    self?.showToast(message: "Invalid email or password")
                    return
                }
                
                guard let strongSelf = self else { return }
                
                print("LogedIn!!!!!!!!")
                
                Firestore.firestore().getCurrentUser(userID: authResult!.user.uid ,completionHandler: {
                    user in
                    
                    print("ID is:  --> "+user.userID)
                    print("Username is:  --> "+user.userName)
                })
                
                SVProgressHUD.dismiss()
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
