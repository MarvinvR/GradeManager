//
//  EditorViewController.swift
//  SimpleGrades
//
//  Created by Marvin von Rappard on 17.02.19.
//  Copyright © 2019 Marvin von Rappard. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var inputGrade: UITextField!
    let apiCommunication = APICommunication()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        if editorItem["type"] as! Int != 3 {
            lblGrade.isHidden = true
            inputGrade.isHidden = true
        } else {
            lblGrade.isHidden = false
            inputGrade.isHidden = false
        }
        
        
        self.title = getModeString(modeBool: editorItem["mode"] as! Bool) + " " + apiCommunication.getTypeString(typeInt: editorItem["type"] as! Int)
        
        if editorItem["mode"] as! Bool {
            inputName.text = editorItem["name"] as? String
            inputGrade.text = editorItem["grade"] as? String
        }
        
    }
    
    @IBAction func btnDone(_ sender: Any) {
        let postRequest: [[Any]] = [
            ["id", editorItem["id"] as! Int],
            ["name", inputName.text as! String],
            ["grade", inputGrade.text]
        ]
        
        print(postRequest)
        
        let pathString = apiCommunication.getTypeString(typeInt: editorItem["type"] as! Int) + "s/update"
        
        apiCommunication.sendPost(requestPath: pathString, postRequest: postRequest) { (result) in
            if self.apiCommunication.validateStatus(parsedData: result) {
                DispatchQueue.main.async(execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func getModeString(modeBool: Bool) -> String {
        if modeBool {
            return "Edit"
        } else {
            return "Add"
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
