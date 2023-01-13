//
//  Model.swift
//  NMRL
//
//  Created by Akhil Johny on 06/06/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import Foundation

struct UserData : Codable {
    
    let resultType      : Int?
    var customerInfo    : User?
    var token           : String?
    
    static var current : UserData?
    
    enum CodingKeys: String, CodingKey {
        
        case resultType         = "resultType"
        case customerInfo       = "customerInfo"
        case token              = "token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultType = try values.decodeIfPresent(Int.self, forKey: .resultType)
        customerInfo = try values.decodeIfPresent(User.self, forKey: .customerInfo)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
    
}

struct User : Codable {
    
    var name                    : String?
    var family                  : String?
    var emailAddress            : String?
    var mobileNumber            : String?
    var birthDate               : String?
    var titleType               : Int?
    var chargedBalance          : String?
    var qrTickets               : [QrTickets]?
    var gender                  : Int?
    var socialSecurityNumber    : String?
    
    enum CodingKeys: String, CodingKey {
        
        case name                   = "name"
        case family                 = "family"
        case emailAddress           = "emailAddress"
        case mobileNumber           = "mobileNumber"
        case birthDate              = "birthDate"
        case titleType              = "titleType"
        case chargedBalance         = "chargedBalance"
        case qrTickets              = "qrTickets"
        case gender                 = "gender"
        case socialSecurityNumber   = "socialSecurityNumber"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        family = try values.decodeIfPresent(String.self, forKey: .family)
        emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress)
        mobileNumber = try values.decodeIfPresent(String.self, forKey: .mobileNumber)
        birthDate = try values.decodeIfPresent(String.self, forKey: .birthDate)
        titleType = try values.decodeIfPresent(Int.self, forKey: .titleType)
        chargedBalance = try values.decodeIfPresent(String.self, forKey: .chargedBalance)
        qrTickets = try values.decodeIfPresent([QrTickets].self, forKey: .qrTickets)
        gender = try values.decodeIfPresent(Int.self, forKey: .gender)
        socialSecurityNumber = try values.decodeIfPresent(String.self, forKey: .socialSecurityNumber)
    }
    
}

struct QrTickets : Codable {
    
    let referenceNumber         : String?
    let ticketContent           : String?
    let ticketSerial            : Int?
    let qrType                  : String?
    let productCode             : Int?
    let sourceStation1          : Int?
    let destinationStation1     : Int?
    let sourceStation2          : Int?
    let destinationStation2     : Int?
    let zone                    : Int?
    let tripsCount              : Int?
    let price                   : String?
    let purchaseDate            : String?
    let issueDate               : String?
    let expirationDate          : String?
    let qrTicketStatus          : String?
    
    enum CodingKeys: String, CodingKey {
        
        case referenceNumber        = "referenceNumber"
        case ticketContent          = "ticketContent"
        case ticketSerial           = "ticketSerial"
        case qrType                 = "qrType"
        case productCode            = "productCode"
        case sourceStation1         = "sourceStation1"
        case destinationStation1    = "destinationStation1"
        case sourceStation2         = "sourceStation2"
        case destinationStation2    = "destinationStation2"
        case zone                   = "zone"
        case tripsCount             = "tripsCount"
        case price                  = "price"
        case purchaseDate           = "purchaseDate"
        case issueDate              = "issueDate"
        case expirationDate         = "expirationDate"
        case qrTicketStatus         = "qrTicketStatus"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        referenceNumber = try values.decodeIfPresent(String.self, forKey: .referenceNumber)
        ticketContent = try values.decodeIfPresent(String.self, forKey: .ticketContent)
        ticketSerial = try values.decodeIfPresent(Int.self, forKey: .ticketSerial)
        qrType = try values.decodeIfPresent(String.self, forKey: .qrType)
        productCode = try values.decodeIfPresent(Int.self, forKey: .productCode)
        sourceStation1 = try values.decodeIfPresent(Int.self, forKey: .sourceStation1)
        destinationStation1 = try values.decodeIfPresent(Int.self, forKey: .destinationStation1)
        sourceStation2 = try values.decodeIfPresent(Int.self, forKey: .sourceStation2)
        destinationStation2 = try values.decodeIfPresent(Int.self, forKey: .destinationStation2)
        zone = try values.decodeIfPresent(Int.self, forKey: .zone)
        tripsCount = try values.decodeIfPresent(Int.self, forKey: .tripsCount)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        purchaseDate = try values.decodeIfPresent(String.self, forKey: .purchaseDate)
        issueDate = try values.decodeIfPresent(String.self, forKey: .issueDate)
        expirationDate = try values.decodeIfPresent(String.self, forKey: .expirationDate)
        qrTicketStatus = try values.decodeIfPresent(String.self, forKey: .qrTicketStatus)
    }
    
}


