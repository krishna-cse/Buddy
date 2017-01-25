//
//  fetchPosts.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/10/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import Foundation

class postController {
    
    
    
    public func connectionRequest(page: Int, category: Int, attention: Int, target_uid: Int , completion: @escaping (_ result: [Any]) -> Void){
        var postsArray = NSArray()
        if let authorization =  UserDefaults.standard.string(forKey:"authorization") {
            print("authorization : \(authorization)")
            //            let url = URL(string: "http://52.87.233.57:80/post/list")
            //            var request = URLRequest.init(url: url!)
            //            request.httpMethod = "POST"
            //            let session = URLSession.shared
            //
            //            let param = ["page":page, "category":category, "attention":attention, "target_uid":target_uid] as Dictionary<String, Int>
            //            request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
            //            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            let urlString = "http://52.87.233.57:80/post/list"
            let url = URL.init(string: urlString)
            
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            
            let param = ["page":page, "category":category, "attention":attention, "target_uid":target_uid] as Dictionary<String, Int>
            request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, err)  in
                if err != nil {
                    if let error : NSError = err as? NSError {
                        if error.code == -1009 {
                            
                            postsArray = [-1]
                            return
                        }
                    }
                }
//                print("Response : \(response)")
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Body : \(strData)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    if json is NSDictionary {
                        let dict = json as! NSDictionary
                        if let responseCode = dict["response_code"] as? Int {
                            DispatchQueue.main.async(execute: {
                                switch(responseCode){
                                case 5:
                                    break;
                                case 1:
                                    if let responseArray: NSArray = dict["posts"] as? NSArray{
                                        if responseArray.count == 0{
                                            //                                            self.i -= 1
                                            postsArray = [0]
                                            return
                                        }
                                        else {
                                            print("post1: \(postsArray)")
                                            postsArray = (dict["posts"] as! NSArray)
                                            print("post2: \(postsArray)")
                                            print("post2 count: \(postsArray.count)")
                                            if postsArray.count != 0{
                                                completion(postsArray as! [Any])
                                            }
                                        }
                                    }
                                    break;
                                case -1:
                                    break;
                                case 100 :
                                    postsArray = [-2]
                                    break;
                                default:
                                    break;
                                }
                            })
                        }
                    }
                    else{
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                }
                catch let error as NSError {
                    print("Error occured : \(error)")
                }
                
            })
            task.resume()
            
            return
        }
        else{
            print(UserDefaults.standard.string(forKey: "authorization") as Any)
            return
        }
    }
    
    func calculateTimeGap(unixTime : Double) -> String {
        var str = ""
        let stDate = Date(timeIntervalSince1970: unixTime/1000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        
        let end = Date()
        
        let gregorian = Calendar
            .init(identifier: Calendar.Identifier.gregorian)
        let components = gregorian.dateComponents([Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: stDate, to: end)
        
        if components.month! < 1 || components.day! < 30{
            if components.day! < 1 {
                if components.hour! < 1 {
                    if components.minute! < 1 {
                        str = "\(components.second!) sec ago"
                    }
                    else if (components.minute! == 1) {
                        str = "\(components.minute!) min ago"
                    }
                    else{
                        str = "\(components.minute!) mins ago"
                    }
                }
                else if (components.hour! == 1 && components.minute! == 0) {
                    str = "\(components.hour!) hr ago"
                }
                else if (components.hour! == 1 && components.minute! == 1){
                    str = "\(components.hour!) hr \(components.minute!) min ago"
                }
                else if (components.hour! == 1 && components.minute! > 1){
                    str = "\(components.hour!) hr \(components.minute!) mins ago"
                }
                else {
                    str = "\(components.hour!) hrs \(components.minute!) mins ago"
                }
            }
            else if (components.day == 1){
                str = "\(components.day!) day ago"
            }
            else{
                str = "\(components.day!) days ago"
            }
        }
        else if(components.month! == 1){
            str = "\(components.month!) month ago"
        }
        else{
            str = "\(components.month!) months ago"
        }
        return str
    }
    
    
    func flag_bell_hug_postRequest(sender: NSArray , completion : @escaping (_ result : Int) -> Void){
        
        let pid = sender[0] as! Int
        let isFlagBellHug = sender[1] //.titleLabel!.text!
        let isSelected = UserDefaults.standard.bool(forKey: "\(pid)_\(isFlagBellHug)")
        
        if let authorization = UserDefaults.standard.string(forKey: "authorization"){
            print("authorization : \(authorization)")
            let urlString = "http://52.87.233.57:80/post/\(isFlagBellHug)"
            print("urlString: \(urlString)")
            let url: NSURL = NSURL(string: urlString)!
            
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            
            let param = ["pid":pid as NSObject] as Dictionary<String, NSObject>
            print("param: \(param)")
            request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Body: \(strData)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    if let dict = json as? NSDictionary {
                        // ... process the data
                        print("flag_bell_hug_postRequest_dict: \(dict)")
                        //var msg = "No message"
                        
                        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                        if(error != nil) {
                            print(error!.localizedDescription)
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: '\(jsonStr)'")
                            //postCompleted(succeeded: false, msg: "Error")
                        }
                        else {
                            
                            // The JSONObjectWithData constructor didn't return an error. But, we should still
                            // check and make sure that json has a value using optional binding.
                            if let dict = json as? NSDictionary {
                                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                                if let response_code = dict["response_code"] as? Int {
                                    print("response_code: \(response_code)")
                                    DispatchQueue.main.async(execute: {
                                        if response_code == 1 {
                                            if isSelected == false {
                                                completion(1)
                                            }
                                            else{
                                                completion(2)
                                            }
                                        }
                                    })
                                }
                                return
                            }
                            else {
                                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                print("Error could not parse JSON: \(jsonStr)")
                                //postCompleted(succeeded: false, msg: "Error")
                            }
                        }
                    }
                } catch let error as NSError {
                    print("An error occurred: \(error)")
                }
            })
            task.resume()
            return
        }
        else{
            completion(0)
            return
        }
    }
    
    
    func createPost(category: Int, content: String , completion : @escaping ( _ result: String) -> Void) {
        if let authorization = UserDefaults.standard.string(forKey: "authorization") {
            
            let urlString = "http://52.87.233.57:80/post/create"
            let url : URL = URL(string: urlString)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let session = URLSession.shared
            
            let param = ["category":category as NSObject,"content":content as NSObject] as Dictionary<String,NSObject>
            request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    print("error : \(error)")
                }
                else {
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        if let dict = json as? NSDictionary {
                            if (dict["response_code"] as? Int) != nil {
                                DispatchQueue.main.async(execute: { 
                                    completion("1")
                                })
                            }
                            else{
                                print("culdn't parse json")
                            }
                        }
                    }
                    catch let error as NSError {
                        print("error occured : \(error.localizedDescription)")
                    }
                }
            })
            task.resume()
        }
    }
    
    func postComment(pid : Int, content: String, completion: @escaping (_ result: String) -> Void ) {
        if let authorization = UserDefaults.standard.string(forKey: "authorization") {
            
            let urlString = "http://52.87.233.57:80/comment/create"
            let url = URL(string: urlString)
            let urlSession = URLSession.shared
            var request = URLRequest.init(url: url!)
            request.httpMethod = "POST"
            let param = ["pid": pid as NSObject, "content":content as NSObject] as Dictionary<String,NSObject>
            request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            
            let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if error != nil {
                    
                }
                else{
                    do{
                        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        if let dict = json as? NSDictionary {
                            if let responseCode = dict["response_code"] as? Int {
                                if responseCode == 1{
                                    completion("1")
                                }
                            }
                        }
                    }
                }
                
            })
            task.resume()
        }
        else{
            print("error occured")
        }
    }
    
    func getComments(pid: Int, page: Int, completion: @escaping (_ result : Any) -> Void)  {
        if let authorization = UserDefaults.standard.string(forKey: "authorization") {
            
            let urlString = "http://52.87.233.57:80/comment/list"
            let url = URL(string: urlString)
            let urlSession = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let params = ["pid":pid as NSObject, "page":page as NSObject] as Dictionary<String,NSObject>
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil{
                    
                }
                else {
                    do{
                        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        if let dict = json as? NSDictionary {
                            if let responseCode = dict["response_code"] as? Int {
                                switch responseCode {
                                case 1:
                                    if let responseArray = dict["comments"] as? NSArray {
                                       completion(responseArray)                                    }
                                    break;
                                case 5:
                                    break;
                                default:
                                    break;
                                }
                            }
                        }
                    }
                }
            })
            task.resume()
            
        }
    }
    
    
    
}
