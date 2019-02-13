//
//  LoginViewController.swift
//  SimpleGrades
//
//  Created by Marvin von Rappard on 12.02.19.
//  Copyright © 2019 Marvin von Rappard. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view. completionHandler: @escaping (_ result: Any) -> Void
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        let apiCommunication = APICommunication()
        
        let postRequest: [[String]] = [
            ["email", inputEmail.text!],
            ["password", inputPassword.text!]
        ]
        
        apiCommunication.sendPost(requestPath: "Authentication/login", postRequest:  postRequest) { (result) -> Void in
            if apiCommunication.validateStatus(parsedData: result as! [String : Any]) {
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
