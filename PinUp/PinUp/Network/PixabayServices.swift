//
//  PixaServices.swift
//  PinUp
//
//  Created by Shanu Singh on 14/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation

enum Result<String>{
    case success
    case failure(String)
}

protocol GetImage {
    typealias Pixa = ( (_ images: [PixabayModal]?,_ error: String?)->())
    func getImageBy(name:String, page:Int,completion: @escaping Pixa)
    func getImageBy(id:Int, completion: @escaping ( (_ images: PixabayModal?,_ error: String?)->())
    )
}

struct PixabayServices: GetImage{
    
    
    let router = Router()
    
    func getImageBy(name: String, page: Int, completion: @escaping Pixa) {
        router.request(.nameQuery(byName: name, page: 1)) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    
                    var array = [PixabayModal]()
                    
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(PixabayModal.self, from: responseData)
                        
                        array.append(apiResponse)
                        
                        
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                    completion(array,nil)
                    
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
            
            
        }
    }
    
    func getImageBy(id: Int, completion: @escaping ((PixabayModal?, String?) -> ())) {
        router.request(.idQuery(byId: id)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(PixabayModal.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
            
            
        }
    }
    
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    
}






