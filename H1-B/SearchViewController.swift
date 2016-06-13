//
//  SearchViewController.swift
//  H-1B
//
//  Created by Bond Wong on 12/28/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

let protl: String = "http"
let domain: String = "45.33.70.244"
let version: String = "v1"
let networkPrefix: String = "\(protl)://\(domain)/\(version)"

class SearchViewController: UIViewController {
    let borderWidth:CGFloat = 1.5
    let cornerRadius:CGFloat = 7.5
    let start = 0
    
    var options: [UIButton] = []
    var inputTuple: (UITextField, UITextField)!
    var choice: String!
    lazy var session: NSURLSession! = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 15.0
        
        return NSURLSession(configuration: configuration)
    }()
    var url: String!
    var data: CollectionResult?
    
    var heightFactor:CGFloat {
        switch(getDeviceModel()) {
        case .IPHONE4_4s:
            return 1/15
        case .IPHONE5_5s:
            return 1/15
        case .IPHONE6_6s:
            return 1/18
        case .IPHONE6p_6ps:
            return 1/20
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let contentView = UIView()
        
        self.view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: UIScreen.mainScreen().bounds.width))
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: UIScreen.mainScreen().bounds.height - 64))
        
        let upperInput = UITextField()
        upperInput.backgroundColor = UIColor.whiteColor()
        upperInput.rightViewMode = .Never
        upperInput.returnKeyType = .Search
        upperInput.addTarget(self, action: #selector(SearchViewController.search), forControlEvents: .EditingDidEndOnExit)
        upperInput.rightView = UIImageView(image: UIImage(named: "pin"))
        upperInput.textAlignment = .Center
        upperInput.layer.cornerRadius = cornerRadius
        upperInput.layer.borderWidth = borderWidth
        upperInput.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        contentView.addSubview(upperInput)
        
        upperInput.translatesAutoresizingMaskIntoConstraints = false
        upperInput.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: (UIScreen.mainScreen().bounds.height-64)/5).active = true
        upperInput.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor, multiplier: 0.8).active = true
        upperInput.heightAnchor.constraintEqualToAnchor(contentView.heightAnchor, multiplier: heightFactor).active = true
        upperInput.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
        
        let lowerInput = UITextField()
        lowerInput.backgroundColor = UIColor.whiteColor()
        lowerInput.returnKeyType = .Search
        lowerInput.rightViewMode = .Always
        lowerInput.addTarget(self, action: #selector(SearchViewController.search), forControlEvents: .EditingDidEndOnExit)
        lowerInput.rightView = UIImageView(image: UIImage(named: "pin"))
        lowerInput.textAlignment = .Center
        lowerInput.layer.cornerRadius = cornerRadius
        lowerInput.layer.borderColor = upperInput.layer.borderColor
        lowerInput.layer.borderWidth = borderWidth
        
        contentView.addSubview(lowerInput)
        lowerInput.translatesAutoresizingMaskIntoConstraints = false
        lowerInput.topAnchor.constraintEqualToAnchor(upperInput.bottomAnchor, constant: 20).active = true
        lowerInput.widthAnchor.constraintEqualToAnchor(upperInput.widthAnchor).active = true
        lowerInput.heightAnchor.constraintEqualToAnchor(upperInput.heightAnchor).active = true
        lowerInput.centerXAnchor.constraintEqualToAnchor(upperInput.centerXAnchor).active = true
        
        inputTuple = (upperInput, lowerInput)
        inputTuple.0.placeholder = "Job Title, Keywords or Company"
        inputTuple.1.placeholder = "Location (City, State)"
        
        let searchButton = UIButton(type: .Custom)
        searchButton.setTitle("Search", forState: .Normal)
        searchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        searchButton.layer.borderWidth = borderWidth
        searchButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        searchButton.layer.cornerRadius = cornerRadius
        searchButton.addTarget(self, action: #selector(SearchViewController.search), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.topAnchor.constraintEqualToAnchor(lowerInput.bottomAnchor, constant: 20).active = true
        searchButton.widthAnchor.constraintEqualToAnchor(lowerInput.widthAnchor).active = true;
        searchButton.heightAnchor.constraintEqualToAnchor(lowerInput.heightAnchor).active = true;
        searchButton.centerXAnchor.constraintEqualToAnchor(lowerInput.centerXAnchor).active = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        inputTuple.0.resignFirstResponder()
        inputTuple.1.resignFirstResponder()
    }
    
    func search() {
        var upperInputText = inputTuple.0.text!
        var lowerInputText = inputTuple.1.text!
        upperInputText = upperInputText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        lowerInputText = lowerInputText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if upperInputText == "" && lowerInputText == "" {
            let alert = UIAlertController(title: "Message Require", message: "Please input keyword or location", preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
            
            alert.addAction(dismissAction)
            
            self.presentViewController(alert, animated: true, completion: nil)

            return
        }
        
        upperInputText = upperInputText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        lowerInputText = lowerInputText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
        url = "\(networkPrefix)/position/keyword/\(upperInputText)/location\(lowerInputText)"
        
        let task = session.dataTaskWithURL(NSURL(string: url + "\(start)")!, completionHandler: {[weak self](data: NSData?, response: NSURLResponse?, error: NSError?) in
            if error != nil {
                print(error?.userInfo)
                return
            }
            let resp: NSHTTPURLResponse? = response as? NSHTTPURLResponse
            if let r = resp {
                if r.statusCode != 200 {
                    print(r.statusCode)
                    return
                }
            }
            
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:[NSJSONReadingOptions.MutableContainers]) as! [String: AnyObject]
                
                self!.data = toCollectionResult(jsonData)
            } catch let error as NSError{
                print("json error: \(error.localizedDescription)")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self!.performSegueWithIdentifier("searchResult", sender: self)
            })
            
            }
        )
        task.resume()
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let rvc = segue.destinationViewController as! RecordsViewController
        rvc.data = self.data
        rvc.module = Module.SEARCH
        rvc.url = self.url
    }

}
