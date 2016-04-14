//
//  SearchViewController.swift
//  H1-B
//
//  Created by Bond Wong on 12/28/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    let borderWidth:CGFloat = 1.5
    let cornerRadius:CGFloat = 7.5
    
    var options: [UIButton] = []
    var inputTuple: (UITextField, UITextField)!
    var choice: String!
    var session: NSURLSession! {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 15.0
        
        return NSURLSession(configuration: configuration)
    }
    
    var data: [String: String]?

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
        
        let optionsView = UIStackView()
        optionsView.axis = .Horizontal
        optionsView.spacing = 5
        optionsView.distribution = .FillEqually
        
        let titleOption = UIButton(type: .Custom)
        titleOption.setTitle("Title", forState: .Normal)
        titleOption.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        titleOption.layer.borderWidth = borderWidth
        titleOption.layer.borderColor = UIColor.lightGrayColor().CGColor
        titleOption.layer.cornerRadius = cornerRadius
        titleOption.addTarget(self, action: #selector(SearchViewController.selectOption(_:)), forControlEvents: .TouchUpInside)
        
        let employerOption = UIButton(type: .Custom)
        employerOption.setTitle("Employer", forState: .Normal)
        employerOption.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        employerOption.layer.borderWidth = borderWidth
        employerOption.layer.borderColor = UIColor.lightGrayColor().CGColor
        employerOption.layer.cornerRadius = cornerRadius
        employerOption.addTarget(self, action: #selector(SearchViewController.selectOption(_:)), forControlEvents: .TouchUpInside)
        
        let locationOption = UIButton(type: .Custom)
        locationOption.setTitle("Location", forState: .Normal)
        locationOption.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        locationOption.layer.borderWidth = borderWidth
        locationOption.layer.borderColor = UIColor.lightGrayColor().CGColor
        locationOption.layer.cornerRadius = cornerRadius
        locationOption.addTarget(self, action: #selector(SearchViewController.selectOption(_:)), forControlEvents: .TouchUpInside)
        
        options.appendContentsOf([titleOption, employerOption, locationOption])
        
        optionsView.addArrangedSubview(titleOption)
        optionsView.addArrangedSubview(employerOption)
        optionsView.addArrangedSubview(locationOption)
        
        contentView.addSubview(optionsView)
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        optionsView.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: (UIScreen.mainScreen().bounds.height-64)/5).active = true
        optionsView.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor, multiplier: 0.8).active = true
        optionsView.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
        optionsView.heightAnchor.constraintEqualToAnchor(contentView.heightAnchor, multiplier: 1/20).active = true
        
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
        upperInput.topAnchor.constraintEqualToAnchor(optionsView.bottomAnchor, constant: 20).active = true
        upperInput.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor, multiplier: 0.8).active = true
        upperInput.heightAnchor.constraintEqualToAnchor(optionsView.heightAnchor).active = true
        upperInput.centerXAnchor.constraintEqualToAnchor(optionsView.centerXAnchor).active = true
        
        
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
        
        selectOption(titleOption)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        inputTuple.0.resignFirstResponder()
        inputTuple.1.resignFirstResponder()
    }
    
    func selectOption(option: UIButton) {
        for button in options {
            if button == option {
                option.enabled = false
                option.backgroundColor = UIColor.lightGrayColor()
                option.setNeedsDisplay()
                
                switch option.titleForState(.Normal){
                    case let title where title == "Title":
                        selectTitleOption()
                    case let title where title == "Employer":
                        selectEmpolyerOption()
                    case let title where title == "Location":
                        selectLocationOption()
                    default:
                        break
                }
                
            } else {
                button.enabled = true
                button.backgroundColor = UIColor.clearColor()
                button.setNeedsDisplay()
            }
        }
    }
    
    func selectTitleOption() {
        inputTuple.0.placeholder = "Job Title"
        inputTuple.0.rightViewMode = .Never
        inputTuple.0.text = ""
        inputTuple.1.hidden = false
        inputTuple.1.placeholder = "City or State (optional)"
        inputTuple.1.text = ""
        
        self.choice = "Title"
    }
    
    func selectEmpolyerOption() {
        inputTuple.0.text = ""
        inputTuple.0.placeholder = "Empolyer name"
        inputTuple.1.hidden = true
        inputTuple.1.text = ""
        
        self.choice = "Employer"
    }
    
    func selectLocationOption() {
        inputTuple.0.placeholder = "City or State"
        inputTuple.0.rightViewMode = .Always
        inputTuple.0.text = ""
        inputTuple.1.hidden = true
        inputTuple.1.text = ""
        
        self.choice = "Location"
    }
    
    func search() {
        var upperInputText = inputTuple.0.text!
        upperInputText = upperInputText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        _ = inputTuple.1.text!
        if upperInputText == "" {
            let alert = UIAlertController(title: "Message Require", message: "Please input necessary message", preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: {[unowned self] _ in
                self.inputTuple.0.backgroundColor = UIColor(red: 236/255, green: 120/255, blue: 90/255, alpha: 1)
            })
            
            alert.addAction(dismissAction)
            
            self.presentViewController(alert, animated: true, completion: nil)

            return
        }
        
        self.inputTuple.0.backgroundColor = UIColor.whiteColor()
        
        var url = ""
        switch self.choice {
            case "Title":
                var location = inputTuple.1.text!
                location = location.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if location == "" {
                    url = "http://localhost:8080/v1/position/title/\(upperInputText)/0"
                } else {
                    url = "http://localhost:8080/v1/position/title/\(upperInputText)/address/\(location)/0"
                }
            case "Employer":
                url = "http://localhost:8080/v1/position/company/\(upperInputText)/0"
            case "Location":
                url = "http://localhost:8080/v1/position/location/\(upperInputText)/0"
            default:
                break
        }
        
        let task = session.dataTaskWithURL(NSURL(string: url)!, completionHandler: {[weak self](data: NSData?, response: NSURLResponse?, error: NSError?) in
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
                self!.data = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String : String]
                dispatch_async(dispatch_get_main_queue(), {
                    self?.performSegueWithIdentifier("searchResult", sender: self)
                })
            } catch let error as NSError{
                print("json error: \(error.localizedDescription)")
            }
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
    }

}
