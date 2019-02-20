//
//  SignupViewController.swift
//  SimpleGrades
//
//  Created by Marvin von Rappard on 20.02.19.
//  Copyright © 2019 Marvin von Rappard. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        let apiCommunication = APICommunication()
        
        let postRequest: [[String]] = [
            ["name", txtName.text!],
            ["email", txtEmail.text!],
            ["password", txtPassword.text!],
            ["confirmpassword", txtConfirmPassword.text!]
        ]
        
        apiCommunication.sendPost(requestPath: "Authentication/signup", postRequest:  postRequest) { (result) -> Void in
            if apiCommunication.validateStatus(parsedData: result) {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.performSegue(withIdentifier: "signinSegue", sender: self)
                }
            }
        }
        
        
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
