//
//  GradesTableViewController.swift
//  SimpleGrades
//
//  Created by Marvin von Rappard on 15.02.19.
//  Copyright © 2019 Marvin von Rappard. All rights reserved.
//

import UIKit

var selectedGrade: [Any] = ["", "", ""]

class GradesTableViewController: UITableViewController {
    var allGrades: [[Any]] = []
    
    override func viewDidAppear(_ animated: Bool) {
        reloadContent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (selectedSubject[1] as! String) + ": " + String(describing: selectedSubject[2])
        
    }
    
    func reloadContent() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if UserDefaults.standard.string(forKey: "token") == nil || UserDefaults.standard.string(forKey: "token") == "" {
                self.performSegue(withIdentifier: "authSegue", sender: self)
            }
        }
        
        let apiCommunication = APICommunication()
        
        
        
        let postRequest: [[Any]] = [
            ["semesterid", String(format: "%@", selectedSemester[0] as! CVarArg)],
            ["subjectid", String(format: "%@", selectedSubject[0] as! CVarArg)]
        ]
        
        apiCommunication.sendPost(requestPath: "Grades/getAll", postRequest: postRequest) { (result) in
            if apiCommunication.validateStatus(parsedData: result) {
                self.allGrades = result["payload"] as! [[Any]]
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
                
                
            } else {
                apiCommunication.showError(text: "Invalid request", sender: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let apiCommunication = APICommunication()
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {
            (action, indexPath) in
            self.editGrade(grade: self.allGrades[indexPath.row])
        })
        editAction.backgroundColor = UIColor.orange
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {
            (action, indexPath) in
            apiCommunication.deleteItem(type: 2, id: self.allGrades[indexPath.row][0] as! Int) { (result) in
                if result {
                    self.reloadContent()
                } else {
                    print("Error while deleting Semester")
                }
            }
            
        })
        return [deleteAction, editAction]
    }
    
    func editGrade(grade: [Any]) {
        
        editorItem = [
            "mode": true,
            "type": 3,
            "id": grade[0],
            "name": grade[1],
            "grade": 0,
            "sender": self
        ]
        
        performSegue(withIdentifier: "editSegue", sender: self)
        
    }
    
    @IBAction func addGrade(_ sender: Any) {
        editorItem = [
            "mode": false,
            "type": 3,
            "id": 0,
            "name": "",
            "grade": 0,
            "sender": self
        ]
        
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGrade = allGrades[indexPath.row]
        //performSegue(withIdentifier: "openSubjects", sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  allGrades.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradesCell", for: indexPath) as! GradeCategoryTableViewCell
        
        cell.labelName.text = allGrades[indexPath.row][1] as? String
        cell.labelGrade.text = String(describing: allGrades[indexPath.row][2])
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
