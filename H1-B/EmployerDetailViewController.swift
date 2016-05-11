//
//  EmployerDetailViewController.swift
//  H-1B
//
//  Created by Bond Wong on 12/30/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

class EmployerDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var module: Module!
    var borderColor: UIColor!
    var indicatorViews: (UIView, UIView)!
    var mainViews: (UITableView, UIView)!
    var position: Position?
    
    let rowHeight = UIScreen.mainScreen().bounds.height * 0.4 / 4

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Company Name"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Bookmark-fill"), style: .Done, target: self, action: #selector(EmployerDetailViewController.bookmark(_:)))
        
        if bookmarklist[position!.id] != nil {
            self.navigationItem.rightBarButtonItem!.tintColor = UIColor(patternImage: UIImage(named: "Bookmark-fill")!)
        }
        
        let segmentView = UIView()
        segmentView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(segmentView)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
        segmentView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        segmentView.heightAnchor.constraintEqualToConstant(40).active = true
        
        
        let aboutElementView = UIView()
        aboutElementView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.addSubview(aboutElementView)
        aboutElementView.topAnchor.constraintEqualToAnchor(segmentView.topAnchor).active = true
        aboutElementView.bottomAnchor.constraintEqualToAnchor(segmentView.bottomAnchor).active = true
        aboutElementView.widthAnchor.constraintEqualToAnchor(segmentView.widthAnchor, multiplier: 0.5).active = true
        aboutElementView.leadingAnchor.constraintEqualToAnchor(segmentView.leadingAnchor).active = true
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(EmployerDetailViewController.aboutViewSingleFingerTap(_:)))
        aboutElementView.addGestureRecognizer(singleFingerTap)
        
        
        let aboutLable = UILabel()
        aboutLable.text = "About"
        aboutLable.textColor = UIColor.blackColor()
        aboutLable.translatesAutoresizingMaskIntoConstraints = false
        aboutElementView.addSubview(aboutLable)
        aboutLable.centerYAnchor.constraintEqualToAnchor(aboutElementView.centerYAnchor).active = true
        aboutLable.centerXAnchor.constraintEqualToAnchor(aboutElementView.centerXAnchor).active = true
        
        let aboutElementBottomView = UIView()
        aboutElementBottomView.hidden = true
        aboutElementBottomView.backgroundColor = self.navigationController?.navigationBar.barTintColor
        aboutElementBottomView.translatesAutoresizingMaskIntoConstraints = false
        aboutElementView.addSubview(aboutElementBottomView)
        aboutElementBottomView.centerXAnchor.constraintEqualToAnchor(aboutElementView.centerXAnchor).active = true
        aboutElementBottomView.widthAnchor.constraintEqualToAnchor(aboutElementView.widthAnchor, multiplier: 0.8).active = true
        aboutElementBottomView.heightAnchor.constraintEqualToAnchor(aboutElementView.heightAnchor, multiplier: 1/10).active = true
        aboutElementBottomView.bottomAnchor.constraintEqualToAnchor(aboutElementView.bottomAnchor).active = true
        
        
        let sponsoredTitlesElementView = UIView()
        sponsoredTitlesElementView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.addSubview(sponsoredTitlesElementView)
        sponsoredTitlesElementView.topAnchor.constraintEqualToAnchor(segmentView.topAnchor).active = true
        sponsoredTitlesElementView.bottomAnchor.constraintEqualToAnchor(segmentView.bottomAnchor).active = true
        sponsoredTitlesElementView.widthAnchor.constraintEqualToAnchor(segmentView.widthAnchor, multiplier: 0.5).active = true
        sponsoredTitlesElementView.trailingAnchor.constraintEqualToAnchor(segmentView.trailingAnchor).active = true
        
        let sponsoredTitles = UILabel()
        sponsoredTitles.text = "Sponsored Titles"
        sponsoredTitles.textColor = UIColor.blackColor()
        sponsoredTitles.translatesAutoresizingMaskIntoConstraints = false
        sponsoredTitlesElementView.addSubview(sponsoredTitles)
        sponsoredTitles.centerYAnchor.constraintEqualToAnchor(sponsoredTitlesElementView.centerYAnchor).active = true
        sponsoredTitles.centerXAnchor.constraintEqualToAnchor(sponsoredTitlesElementView.centerXAnchor).active = true
        
        let sponsoredTitlesBottomView = UIView()
        sponsoredTitlesBottomView.hidden = true
        sponsoredTitlesBottomView.backgroundColor = self.navigationController?.navigationBar.barTintColor
        sponsoredTitlesBottomView.translatesAutoresizingMaskIntoConstraints = false
        sponsoredTitlesElementView.addSubview(sponsoredTitlesBottomView)
        sponsoredTitlesBottomView.centerXAnchor.constraintEqualToAnchor(sponsoredTitlesElementView.centerXAnchor).active = true
        sponsoredTitlesBottomView.widthAnchor.constraintEqualToAnchor(sponsoredTitlesElementView.widthAnchor, multiplier: 0.8).active = true
        sponsoredTitlesBottomView.heightAnchor.constraintEqualToAnchor(sponsoredTitlesElementView.heightAnchor, multiplier: 1/10).active = true
        sponsoredTitlesBottomView.bottomAnchor.constraintEqualToAnchor(sponsoredTitlesElementView.bottomAnchor).active = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(EmployerDetailViewController.sponsoredViewSingleFingerTap(_:)))
        sponsoredTitlesElementView.addGestureRecognizer(singleTap)
        
        indicatorViews = (aboutElementBottomView, sponsoredTitlesBottomView)
        
        
        let aboutView = UITableView()
        borderColor = aboutView.separatorColor
        aboutView.hidden = true
        aboutView.layer.borderWidth = 1
        aboutView.layer.borderColor = aboutView.separatorColor?.CGColor
        aboutView.separatorStyle = .None
        aboutView.scrollEnabled = false
        aboutView.dataSource = self
        aboutView.delegate = self
        
        self.view.addSubview(aboutView)
        aboutView.translatesAutoresizingMaskIntoConstraints = false
        aboutView.topAnchor.constraintEqualToAnchor(segmentView.bottomAnchor, constant: UIScreen.mainScreen().bounds.height / 50).active = true
        aboutView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.9).active = true
        aboutView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        aboutView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.4).active = true
        
        
        let sponsoredTitlesView = UIScrollView()
        sponsoredTitlesView.hidden = true
        sponsoredTitlesView.scrollEnabled = true
        sponsoredTitlesView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sponsoredTitlesView)
        sponsoredTitlesView.topAnchor.constraintEqualToAnchor(aboutView.topAnchor).active = true
        sponsoredTitlesView.widthAnchor.constraintEqualToAnchor(aboutView.widthAnchor).active = true
        sponsoredTitlesView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
        sponsoredTitlesView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        
        addDataToSponsoredTitlesView(sponsoredTitlesView)
        
        
        mainViews = (aboutView, sponsoredTitlesView)
        
        
        showAbout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        
        let seperator = UIView()
        seperator.backgroundColor = tableView.separatorColor
        seperator.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(seperator)
        seperator.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor).active = true
        seperator.heightAnchor.constraintEqualToConstant(1).active = true
        seperator.widthAnchor.constraintEqualToAnchor(cell.widthAnchor, multiplier: 0.9).active = true
        seperator.centerXAnchor.constraintEqualToAnchor(cell.centerXAnchor).active = true
        
        let itemLabel = UILabel()
        itemLabel.font = UIFont(name: itemLabel.font!.fontName, size: itemLabel.font!.pointSize - 3)
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(itemLabel)
        itemLabel.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor, constant: rowHeight/10).active = true
        itemLabel.leadingAnchor.constraintEqualToAnchor(seperator.leadingAnchor).active = true
        
        let dataLabel = UILabel()
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(dataLabel)
        dataLabel.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -rowHeight/10).active = true
        dataLabel.leadingAnchor.constraintEqualToAnchor(itemLabel.leadingAnchor).active = true
        
        switch indexPath.row {
        case 0:
            itemLabel.text = "Employer Name"
            dataLabel.text = position!.company.name
        case 1:
            itemLabel.text = "Contact"
            dataLabel.text = position!.company.contact
        case 2:
            itemLabel.text = "Street"
            dataLabel.text = position!.company.address.street
        case 3:
            itemLabel.text = "City, State and Zipode"
            dataLabel.text = "\(position!.company.address.city) \(position!.company.address.state) \(position!.company.address.zipCode)"
        default:
            break
        }
        dataLabel.sizeToFit()
        
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func aboutViewSingleFingerTap(gestureRecognizer: UITapGestureRecognizer) {
        showAbout()
    }
    
    func sponsoredViewSingleFingerTap(gestureRecognizer: UITapGestureRecognizer) {
        showSponsoredTitles()
    }
    
    func showAbout() {
        indicatorViews.0.hidden = false
        indicatorViews.1.hidden = true
        mainViews.0.hidden = false
        mainViews.1.hidden = true
    }
    
    func showSponsoredTitles() {
        indicatorViews.0.hidden = true
        indicatorViews.1.hidden = false
        mainViews.0.hidden = true
        mainViews.1.hidden = false
    }
    
    func addDataToSponsoredTitlesView(sponsoredTitlesView: UIScrollView) {
        for i in 0..<5 {
            let dataView = UIView()
            dataView.backgroundColor = UIColor.whiteColor()
            dataView.layer.borderColor = self.borderColor.CGColor
            dataView.layer.borderWidth = 1
            dataView.translatesAutoresizingMaskIntoConstraints = false
            sponsoredTitlesView.addSubview(dataView)
            dataView.topAnchor.constraintEqualToAnchor(sponsoredTitlesView.topAnchor, constant: CGFloat(i) * (UIScreen.mainScreen().bounds.height / 5 + UIScreen.mainScreen().bounds.height / 5 / 5)).active = true
            dataView.widthAnchor.constraintEqualToAnchor(sponsoredTitlesView.widthAnchor).active = true
            dataView.centerXAnchor.constraintEqualToAnchor(sponsoredTitlesView.centerXAnchor).active = true
            dataView.heightAnchor.constraintEqualToConstant(UIScreen.mainScreen().bounds.height / 5).active = true
            sponsoredTitlesView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width * 0.9, height: CGFloat(i + 1) * (UIScreen.mainScreen().bounds.height / 5 + UIScreen.mainScreen().bounds.height / 5 / 5))
            
            
            let titleLabel = UILabel()
            titleLabel.text = position!.name
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            dataView.addSubview(titleLabel)
            titleLabel.topAnchor.constraintEqualToAnchor(dataView.topAnchor, constant: rowHeight / 15).active = true
            titleLabel.leadingAnchor.constraintEqualToAnchor(dataView.leadingAnchor, constant:  rowHeight / 15).active = true
            
            let visatypeLabel = UILabel()
            visatypeLabel.text = "Visa Type: H-1B"
            visatypeLabel.translatesAutoresizingMaskIntoConstraints = false
            dataView.addSubview(visatypeLabel)
            visatypeLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: rowHeight / 15).active = true
            visatypeLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
            
            let wageLabel = UILabel()
            wageLabel.text = "Salary: \(position!.salary)"
            wageLabel.translatesAutoresizingMaskIntoConstraints = false
            dataView.addSubview(wageLabel)
            wageLabel.topAnchor.constraintEqualToAnchor(visatypeLabel.bottomAnchor, constant: rowHeight / 15).active = true
            wageLabel.leadingAnchor.constraintEqualToAnchor(visatypeLabel.leadingAnchor).active = true
            
            let workLocationLabel = UILabel()
            workLocationLabel.text = "Work Location: \(position!.address.city) \(position!.address.state)"
            workLocationLabel.translatesAutoresizingMaskIntoConstraints = false
            dataView.addSubview(workLocationLabel)
            workLocationLabel.topAnchor.constraintEqualToAnchor(wageLabel.bottomAnchor, constant: rowHeight / 15).active = true
            workLocationLabel.leadingAnchor.constraintEqualToAnchor(wageLabel.leadingAnchor).active = true
            
        }
    }
    
    func bookmark(barButtonItem: UIBarButtonItem) {
        if barButtonItem.tintColor == nil {
            barButtonItem.tintColor = UIColor(patternImage: UIImage(named: "Bookmark-fill")!)
            
            bookmarklist[position!.id] = toDict(position!)
            if bookmarklist.count > 50 {
                bookmarklist.removeAtIndex(bookmarklist.startIndex)
            }
        }
        else {
            barButtonItem.tintColor = nil
            
            bookmarklist.removeValueForKey(position!.id)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
