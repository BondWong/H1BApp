//
//  HistroyViewController.swift
//  H-1B
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
    var data: CollectionResult?
    var selectedPosition: Position?
    
    var delegate: LocalDataDelegate!
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        switch module {
        case let m where m == Module.BOOKMARK:
            self.navigationItem.title = "Bookmark"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecordsViewController.updateData), name: Event.ADD_BOOKMARK.rawValue, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecordsViewController.updateData), name: Event.REMOVE_BOOKMARK.rawValue, object: nil)
        case let m where m == Module.SEARCH:
            self.navigationItem.title = "Records"
        default:
            self.navigationItem.title = "History"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecordsViewController.updateData), name: Event.ADD_HISTORY.rawValue, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecordsViewController.updateData), name: Event.REMOVE_HISTORY.rawValue, object: nil)
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
            return d.positions.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(getDeviceModel()) {
        case .IPHONE4_4s:
            return UIScreen.mainScreen().bounds.height / 8
        case .IPHONE5_5s:
            return UIScreen.mainScreen().bounds.height / 8
        case .IPHONE6_6s:
            return UIScreen.mainScreen().bounds.height / 10
        case .IPHONE6p_6ps:
            return UIScreen.mainScreen().bounds.height / 10
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("record", forIndexPath: indexPath)
        if cell.tag != 101 {
            cell.tag = 101
        } else {
            cell.textLabel?.text = ""
        }

        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        let position: Position = data!.positions[indexPath.row]
        
        cell.textLabel?.text = "\(position.name)"
        cell.detailTextLabel?.text = "\(position.company.name) \(position.address.state) \(position.address.city)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedPosition = data?.positions[indexPath.row]
        self.performSegueWithIdentifier("showDetail", sender: self)
        
        if self.module == Module.SEARCH {
            if history[self.selectedPosition!.id] == nil {
                history[self.selectedPosition!.id] = toDict(self.selectedPosition!)
                NSNotificationCenter.defaultCenter().postNotificationName(Event.ADD_HISTORY.rawValue, object: self)
            }
            
            if history.count > 50 {
                history.removeAtIndex(history.startIndex)
                NSNotificationCenter.defaultCenter().postNotificationName(Event.REMOVE_HISTORY.rawValue, object: self)
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let positions: [Position] = self.data!.positions
        let hasNext = self.data!.hasNext
        if self.module == Module.SEARCH && indexPath.row + 1 == positions.count && hasNext {
            let task = session.dataTaskWithURL(NSURL(string: url + "\(positions.count)")!, completionHandler: {[weak self](data: NSData?, response: NSURLResponse?, error: NSError?) in
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
                    let newData = try NSJSONSerialization.JSONObjectWithData(data!, options:[NSJSONReadingOptions.MutableContainers]) as! [String: AnyObject]
                    
                    let newCollection = toCollectionResult(newData)
                    newCollection.positions.appendContentsOf(self!.data!.positions)
                    self?.data? = newCollection
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self?.tableView.reloadData()
                    })
                } catch let error as NSError{
                    print("json error: \(error.localizedDescription)")
                    return
                }
                
            })
            task.resume()
        }
    }
    
    func updateData() {
        self.data = self.delegate.getData() as? CollectionResult
        self.tableView.reloadData()
        self.delegate.synchronize()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc: EmployerDetailViewController = segue.destinationViewController as! EmployerDetailViewController
        vc.position = self.selectedPosition
        vc.module = self.module
    }
    
}
