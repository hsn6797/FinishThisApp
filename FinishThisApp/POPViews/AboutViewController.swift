//
//  AboutViewController.swift
//  FinishThisApp
//
//  Created by Asad on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var AboutTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "About Us"

        // Do any additional setup after loading the view.
    }
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
