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
    
    
    override func viewDidLoad() {
        let apiCommunication = APICommunication()
        
        super.viewDidLoad()

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
        if editorItem["type"] as! Int == 3 {
            "id": editorItem["id"],
            "name": inputName.text,
            "grade": inputGrade.text
        } else {
            let postRequest = [
                "id": editorItem["id"],
                "name": inputName.text
            ]
        }
        navigationController?.popViewController(animated: true)
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
