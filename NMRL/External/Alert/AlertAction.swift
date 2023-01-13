//
//  AlertAction.swift
//  
//
//  Created by Vishnu M P on 26/05/19.
//  Copyright © 2019 Vishnu M P. All rights reserved.
//

import Foundation


enum AlertActionType{
    case yes
    case no
}

typealias AlertActionHandler = () -> Void

class AlertAction {
    
    let title: String
    let type: AlertActionType
    let handler: AlertActionHandler?
    
    init(title: String, type: AlertActionType, handler: AlertActionHandler?){
        self.title = title
        self.type = type
        self.handler = handler
    }
    
}
