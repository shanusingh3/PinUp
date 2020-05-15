//
//  NetworkManager.swift
//  PinUp
//
//  Created by Shanu Singh on 15/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//
//

import Foundation


public typealias  NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()


protocol NetworkRouter {
    func request(_ endpoint: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router: NetworkRouter {
    
    private var task : URLSessionTask?
    
    func request(_ endpoint: EndPoint, completion: @escaping NetworkRouterCompletion) {
        guard let url = endpoint.url else {return}
        let request = URLRequest(url: url)
        NetworkLogger.log(request: request)
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }
        task?.resume()
        
    }
    
    func cancel() {
        self.task?.cancel()
    }

}
