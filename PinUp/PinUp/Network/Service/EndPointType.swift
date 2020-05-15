//
//  EndPointType.swift
//  PinUp
//
//  Created by Shanu Singh on 14/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseUrl : URL {get}
    var path : String {get}
    var httpMethod : HTTPMethod {get}
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    
}
