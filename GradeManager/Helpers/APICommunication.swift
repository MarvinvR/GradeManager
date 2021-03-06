//
//  APICommunication.swift
//  SimpleGrades
//
//  Created by Marvin von Rappard on 12.02.19.
//  Copyright © 2019 Marvin von Rappard. All rights reserved.
//

import Foundation
import UIKit

class APICommunication {
    let apiUrl: String = "https://api.von-rappard.ch/simplegrades/"
    
    init() {
        
    }
    
    public func sendPost(requestPath: String, postRequest: [[Any]], completionHandler: @escaping (_ result: [String: Any]) -> Void) {
        
        let url = URL(string: apiUrl + requestPath)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var postString: String = ""
        if postRequest.count > 0 {
            postString += String(describing: postRequest[0][0]) + "=" + String(describing: postRequest[0][1])
            
            for i in 1..<postRequest.count {
                postString += "&" + String(describing: postRequest[i][0]) + "=" + String(describing: postRequest[i][1])
            }
        }
        
        if UserDefaults.standard.string(forKey: "token") != nil && UserDefaults.standard.string(forKey: "token") != "" {
            postString += "&token=" + UserDefaults.standard.string(forKey: "token")!
        }
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                
                do{
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                    completionHandler(parsedData)
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            }
        }
        task.resume()
    }
    
    func checkAuth() ->Bool {
        return UserDefaults.standard.string(forKey: "token") == nil || UserDefaults.standard.string(forKey: "token") == ""
    }
    
    public func validateStatus(parsedData: [String: Any]) -> Bool {
        
        let status = parsedData["status"] as! Int
        
        if status == 401 {
            storeToken(token: "")
            return false
        } else if status < 300 {
            storeToken(token: parsedData["token"] as! String)
            return true
        } else if status < 400 {
            storeToken(token: parsedData["token"] as! String)
            return true
        } else {
            showError(text: parsedData["payload"] as! String, sender: UIViewController())
            return false
        }
    }
    
    public func deleteItem(type: Int, id: Int, completionHandler: @escaping (_ result: Bool) -> Void) {
        let deleteType = getTypeString(typeInt: type)
        
        if deleteType == "" {
            return
        }
        
        let postRequest = [
            ["id", String(describing: id)]
        ]
        
        sendPost(requestPath: deleteType + "s/delete", postRequest: postRequest) { (result) in
            completionHandler(self.validateStatus(parsedData: result))
        }
    }
    
    public func getTypeString(typeInt: Int) -> String {
        switch typeInt {
        case 1:
            return "Semester"
        case 2:
            return "Subject"
        case 3:
            return "Grade"
        default:
            return ""
        }
    }
    
    public func showError(text: String, sender: UIViewController) {
        print(text)
    }
    
    private func storeToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }
    
}
