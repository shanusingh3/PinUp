//
//  PixaServices.swift
//  PinUp
//
//  Created by Shanu Singh on 14/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation


//struct PixabayServices {
//
//
//    func startFetching(){
//        let session = URLSession.shared
//        let url = URL(string: "https://learnappmaking.com/ex/users.json")!
//
//        let task = session.dataTask(with: url) { data, response, error in
//
//            if error != nil || data == nil {
//                print("Client error!")
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
//                print("Server error!")
//                return
//            }
//
//            guard let mime = response.mimeType, mime == "application/json" else {
//                print("Wrong MIME type!")
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print(json)
//            } catch {
//                print("JSON error: \(error.localizedDescription)")
//            }
//        }
//
//        task.resume()
//    }
//}




import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct PixabayServices {
    
    static let PixaAPIKey = ""
    //let router = Router<MovieApi>()
    
//    func getImagesByQuery(name: String ,page: Int, completion: @escaping (_ movie: [Movie]?,_ error: String?)->()){
//
//        router.request(.newMovies(page: page)) { data, response, error in
//
//            if error != nil {
//                completion(nil, "Please check your network connection.")
//            }
//
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .success:
//                    guard let responseData = data else {
//                        completion(nil, NetworkResponse.noData.rawValue)
//                        return
//                    }
//                    do {
//                        print(responseData)
//                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
//                        print(jsonData)
//                        let apiResponse = try JSONDecoder().decode(MovieApiResponse.self, from: responseData)
//                        completion(apiResponse.movies,nil)
//                    }catch {
//                        print(error)
//                        completion(nil, NetworkResponse.unableToDecode.rawValue)
//                    }
//                case .failure(let networkFailureError):
//                    completion(nil, networkFailureError)
//                }
//            }
//        }
//    }
//
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
