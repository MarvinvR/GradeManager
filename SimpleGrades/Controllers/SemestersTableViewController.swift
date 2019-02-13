//
//  SemestersTableViewController.swift
//  SimpleGrades
//
//  Created by Marvin von Rappard on 12.02.19.
//  Copyright © 2019 Marvin von Rappard. All rights reserved.
//

import UIKit

var selectedSemester: Int = -1

class SemestersTableViewController: UITableViewController {
    var allSemesters = [[]]

    @IBOutlet var s: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if UserDefaults.standard.string(forKey: "token") == nil || UserDefaults.standard.string(forKey: "token") == "" {
                self.performSegue(withIdentifier: "authSegue", sender: self)
            }
        }
        
        let apiCommunication = APICommunication()
        
        
        apiCommunication.sendPost(requestPath: "Semesters/getAll", postRequest: []) { (result) in
            if apiCommunication.validateStatus(parsedData: result) {
                self.allSemesters = result["payload"] as! [[Any]]
                
                self.s.reloadData()
//                    print("Error: Invalid request")
//                    apiCommunication.showError(text: "Invalid request", sender: self)
                
                
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  allSemesters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "semestersCell", for: indexPath) as! GradeCategoryTableViewCell

        cell.labelName.text = allSemesters[indexPath.row][0] as! String
        cell.labelGrade.text = allSemesters[indexPath.row][1] as! String

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
