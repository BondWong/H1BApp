//
//  Utils.swift
//  H1-B
//
//  Created by Bond Wong on 12/31/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import Foundation
import UIKit

func getDeviceModel() -> DeviceModel {
    let height = UIScreen.mainScreen().bounds.height
    
    switch(height) {
    case 480.0:
        return DeviceModel.IPHONE4_4s
    case 568.0:
        return DeviceModel.IPHONE5_5s
    case 667.0:
        return DeviceModel.IPHONE6_6s
    case 736.0:
        return DeviceModel.IPHONE6p_6ps
    default:
        return DeviceModel.IPHONE6p_6ps
    }
}

func createPosition(data: [String: AnyObject]) -> Position {
    let companyAddress = Address()
    
    let companyData: [String: AnyObject] = data["company"] as! [String: AnyObject]
    let companyAddressData: [String: AnyObject] = companyData["address"] as! [String: AnyObject]
    
    companyAddress.state = companyAddressData["state"] as! String
    companyAddress.city = companyAddressData["city"] as! String
    companyAddress.street = companyAddressData["street"] as! String
    companyAddress.zipCode = companyAddressData["zipCode"] as! String
    
    let company = Company()
    
    company.contact = companyData["contact"] as! String
    company.name = companyData["name"] as! String
    company.address = companyAddress
    
    let positionAddress = Address()
    
    let positionAddressData: [String: AnyObject] = data["location"] as! [String: AnyObject]
    
    positionAddress.state = positionAddressData["state"] as! String
    positionAddress.city = positionAddressData["city"] as! String
    positionAddress.street = positionAddressData["street"] as! String
    positionAddress.zipCode = positionAddressData["zipCode"] as! String
    
    let position = Position()

    position.id = "\(data["id"]!)"
    position.name = data["name"] as! String
    position.salary = data["salary"] as! String
    position.visaType = data["visaType"] as! String
    position.address = positionAddress
    position.company = company
    
    return position
    
}

func toDict(position: Position) -> [String: AnyObject] {
    var posDict = [String: AnyObject]()
    posDict["name"] = position.name
    posDict["id"] = position.id
    posDict["salary"] = position.salary
    posDict["visaType"] = position.visaType
    
    var companyDict = [String:AnyObject]()
    companyDict["name"] = position.company.name
    companyDict["contact"] = position.company.contact
    
    var companyAddrDict = [String: AnyObject]()
    companyAddrDict["state"] = position.company.address.state
    companyAddrDict["city"] = position.company.address.city
    companyAddrDict["street"] = position.company.address.street
    companyAddrDict["zipCode"] = position.company.address.zipCode
    
    companyDict["address"] = companyAddrDict
    
    var addrDict = [String: AnyObject]()
    addrDict["state"] = position.address.state
    addrDict["city"] = position.address.city
    addrDict["street"] = position.address.street
    addrDict["zipCode"] = position.address.zipCode
    
    posDict["company"] = companyDict
    posDict["location"] = addrDict
    
    return posDict
}

func toCollectionResult(data: [String: AnyObject]) -> CollectionResult {
    let result: CollectionResult = CollectionResult()
    result.hasNext = data["hasNext"] as! Bool
    result.pageNum = data["pageNum"] as! Int
    result.pageSize = data["pageSize"] as! Int
    
    let elements = data["elements"] as! [[String: AnyObject]]
    var positions: [Position] = []
    for element in elements {
        positions.append(createPosition(element))
    }
    
    result.positions = positions
    
    return result
}

class CollectionResult: NSObject {
    var positions: [Position]
    var hasNext: Bool
    var pageNum: Int
    var pageSize: Int
    
    override init() {
        positions = []
        hasNext = false
        pageNum = 0
        pageSize = 30
        
        super.init()
    }
}
