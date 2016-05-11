//
//  File.swift
//  H-1B
//
//  Created by Bond Wong on 5/11/16.
//  Copyright © 2016 Bond Wong. All rights reserved.
//


//{
//    company =     {
//        address =         {
//            city = EDISON;
//            id = 5;
//            state = NJ;
//            street = "4 ETHEL RD, SUITE 403B";
//            zipCode = 08817;
//        };
//        contact = 7325492030;
//        name = "INTEGRATED RESOURCES, INC";
//    };
//    id = 7;
//    location =     {
//        city = VINELAND;
//        id = 2;
//        state = NJ;
//        street = "";
//        zipCode = 08362;
//    };
//    name = "OCCUPATIONAL THERAPISTS";
//    salary = "$32.97/Hour";
//    visaType = "H-1B";
//}

import Foundation

class Position: NSObject {
    var id: CLong
    var name: String
    var salary: String
    var visaType: String
    var address: Address
    var company: Company
    
    override init() {
        id = 0
        name = ""
        salary = ""
        visaType = ""
        address = Address()
        company = Company()
        
        super.init()
    }
    
}

class Company: NSObject {
    var name: String
    var address: Address
    var contact: String
    
    override init() {
        name = ""
        address = Address()
        contact = ""
        
        super.init()
    }
}

class Address: NSObject {
    var state: String
    var city: String
    var zipCode: String
    var street: String
    
    override init() {
        state = ""
        city = ""
        zipCode = ""
        street = ""
        
        super.init()
    }
}