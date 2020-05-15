//
//  EndPoint.swift
//  PinUp
//
//  Created by Shanu Singh on 15/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation


/*This is a end point struct use to get the end points like path and queryItems.
 *In out case the path would be fixed i.e /api but it could be different as the scope of application will grow
 *QueryItems will contains all the URL queries as well as the KEY for this particular API.
 * */

struct EndPoint {
    let path: String
    let queryItems: [URLQueryItem]
}


// Extension of the endPoint Struct to configure the EndPoint and URLQueryItems
extension EndPoint{
    //This function will search for the image by name. The search bar query will be passed in this function and it will return the ENDPOINT that will be configured with the desire query.
    static func nameQuery(byName query: String,page : Int) -> EndPoint{
        return EndPoint(path: "/api", queryItems: [
            URLQueryItem(name: "key", value: "16556937-db6fd4627bd71772e29325ad8"),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(20)")
        ])
    }
    //This function will return the ENDPOINT configure particullary for given ID of the image.
    static func idQuery(byId id: Int) -> EndPoint{
        return EndPoint(path: "/api", queryItems: [
            URLQueryItem(name: "key", value: "16556937-db6fd4627bd71772e29325ad8"),
            URLQueryItem(name: "id", value: "\(id)"),
            URLQueryItem(name: "image_type", value: "photo")
        ])
    }
}

//This extension will return the url along with the desire path and URLQueryItems that user will call to get the image.
extension EndPoint{
    var url : URL?{
        var component = URLComponents()
        component.scheme = "https"
        component.host = "pixabay.com"
        component.path = path
        component.queryItems = queryItems
        return component.url
    }
}



