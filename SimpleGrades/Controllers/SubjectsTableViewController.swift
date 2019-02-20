//
//  SubjectsTableViewController.swift
//  SimpleGrades
//
//  Created by Marvin von Rappard on 15.02.19.
//  Copyright © 2019 Marvin von Rappard. All rights reserved.
//

import UIKit

var selectedSubject: [Any] = []

class SubjectsTableViewController: UITableViewController {
    var allSubjects: [[Any]] = []
    
    override func viewDidAppear(_ animated: Bool) {
        reloadContent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (selectedSemester[1] as! String) + ": " + String(describing: selectedSemester[2])

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func reloadContent() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if UserDefaults.standard.string(forKey: "token") == nil || UserDefaults.standard.string(forKey: "token") == "" {
                self.performSegue(withIdentifier: "authSegue", sender: self)
            }
        }
        
        let apiCommunication = APICommunication()
        
        let postRequest: [[Any]] = [
            ["semesterid", String(format: "%@", selectedSemester[0] as! CVarArg)]
        ]
        
        apiCommunication.sendPost(requestPath: "Subjects/getAll", postRequest: postRequest) { (result) in
            if apiCommunication.validateStatus(parsedData: result) {
                self.allSubjects = result["payload"] as! [[Any]]
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
            self.editSubject(subject: self.allSubjects[indexPath.row])
        })
        editAction.backgroundColor = UIColor.orange
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {
            (action, indexPath) in
            apiCommunication.deleteItem(type: 2, id: self.allSubjects[indexPath.row][0] as! Int) { (result) in
                if result {
                    self.reloadContent()
                } else {
                    print("Error while deleting Semester")
                }
            }
            
        })
        return [deleteAction, editAction]
    }
    
    func editSubject(subject: [Any]) {
        
        editorItem = [
            "mode": true,
            "type": 2,
            "id": subject[0],
            "name": subject[1],
            "grade": 0,
            "sender": self
        ]
        
        performSegue(withIdentifier: "editSegue", sender: self)
        
    }
    
    @IBAction func editSubject(_ sender: Any) {
        editorItem = [
            "mode": false,
            "type": 2,
            "id": 0,
            "name": "",
            "grade": 0,
            "sender": self
        ]
        
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubject = allSubjects[indexPath.row]
        performSegue(withIdentifier: "openGrades", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allSubjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectsCell", for: indexPath) as! GradeCategoryTableViewCell

        cell.labelName.text = allSubjects[indexPath.row][1] as? String
        cell.labelGrade.text = String(describing: allSubjects[indexPath.row][2])

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
