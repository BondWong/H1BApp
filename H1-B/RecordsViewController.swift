//
//  HistroyViewController.swift
//  H1-B
//
//  Created by Bond Wong on 12/30/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

class RecordsViewController: UITableViewController {
    lazy var session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.allowsCellularAccess = true
        config.timeoutIntervalForRequest = 15.0
        return NSURLSession(configuration: config)
    }()
    var url: String!
    var module: Module!
    var data: [String: AnyObject]?
    var seletedData: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        switch module {
        case let m where m == Module.BOOKMARK:
            self.navigationItem.title = "Bookmark"
        case let m where m == Module.SEARCH:
            self.navigationItem.title = "Records"
        default:
            self.navigationItem.title = "History"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let d = data {
            return d["elements"]!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("record", forIndexPath: indexPath)
        if cell.tag != 101 {
            cell.tag = 101
        } else {
            cell.textLabel?.text = ""
        }

        let title = (data?["elements"]?[indexPath.row]?["name"])!
        cell.textLabel?.text = "\(title!)"
        let state = (data?["elements"]?[indexPath.row]?["location"]?!["state"])!
        let city = (data?["elements"]?[indexPath.row]?["location"]?!["city"])!
        let company = (data?["elements"]?[indexPath.row]?["company"]?!["name"])!
        cell.detailTextLabel?.text = "\(company!) \(state!) \(city!)"
        
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.seletedData = data?["elements"]?[indexPath.row]!
        self.performSegueWithIdentifier("showDetail", sender: self)
        
        if self.module == Module.SEARCH {
            let selectedId = self.seletedData["id"] as! CLong
            for ele in history {
                let eleId = ele["id"] as! CLong
                if eleId == selectedId {
                    return
                }
            }
            history.append(self.seletedData)
            if history.count > 50 {
                history.removeFirst()
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let element: [[String: AnyObject]] = self.data!["elements"] as! [[String: AnyObject]]
        if self.module == Module.SEARCH && indexPath.row + 1 == element.count {
            let task = session.dataTaskWithURL(NSURL(string: url + "\(element.count)")!, completionHandler: {[weak self](data: NSData?, response: NSURLResponse?, error: NSError?) in
                if error != nil {
                    print(error?.userInfo)
                    return
                }
                
                let resp: NSHTTPURLResponse = response as! NSHTTPURLResponse
                
                if resp.statusCode != 200 {
                    print(resp.statusCode)
                    return
                }
                
                do {
                    var newData = try NSJSONSerialization.JSONObjectWithData(data!, options:[NSJSONReadingOptions.MutableContainers]) as? [String: AnyObject]
                    var originalElements: [[String: AnyObject]] = self?.data!["elements"] as! [[String: AnyObject]]
                    let newElements: [[String: AnyObject]] = newData!["elements"] as! [[String: AnyObject]]
                    originalElements.appendContentsOf(newElements)
                    
                    // self?.data!["elements"].append(d["elements"])
                } catch let error as NSError{
                    print("json error: \(error.localizedDescription)")
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self?.tableView.reloadData()
                })
                
            })
            task.resume()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc: EmployerDetailViewController = segue.destinationViewController as! EmployerDetailViewController
        vc.data = self.seletedData
        vc.module = self.module
    }
    
}
