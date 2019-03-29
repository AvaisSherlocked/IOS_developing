//
//  YelpData.swift
//  CouponGo
//
//  Created by Ava on 3/3/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import Foundation
//https://www.yelp.com/developers/documentation/v3/business


struct Business: Codable {
    let id: String!
    let name: String!
    let image_url: String?
    let url: String?
    let phone: String?
    let rating: Float?
    let coordinates: Point
}

struct Point: Codable {
    let latitude: Double
    let longitude: Double
}
struct Center: Codable {
    let longitude: Float?
    let latitude: Float?
}
struct BusinessResult: Codable {
    let businesses: [Business]
    let total: Int
    let region: Center
}


class YelpService {
    // private API
    private static let apiKey = "DveWqDdRd41VRQzFqLr_7aiMrIoGNWYTqnqF_pgdf7Ylcj8q-y6VqnCG69SRUhRDSQJzU4WDqUJnQS9nksxBTj8aEizAY2wIfSyTyYPlj0xkT1F2x81QplBzGKN8XHYx"
    var dataTask: URLSessionDataTask?
    
    private static let urlString = "https://api.yelp.com/v3/businesses/search?"
    
    class func search(latitude: String, longitude: String, completion: @escaping ([Business]?, Error?) -> ()) {
        let urlCoord = "term=restaurants&latitude=\(latitude)&longitude=\(longitude)&radius=1500&limit=40"
        guard let url = URL(string: urlString + urlCoord) else {
            print("invalid url: \(urlString + urlCoord)")
            return
        }
        print("the url is \(url)")
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("Bearer \(apiKey)",forHTTPHeaderField: "Authorization") 
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
//            print(String(data: data, encoding: .utf8) ?? "unable to print data")
            print("Status code: \(response.statusCode)")
            
            do {
                let decoder = JSONDecoder()  // from Json to swift object
                let businessResult = try decoder.decode(BusinessResult.self, from: data)
                print("decode successed")
                DispatchQueue.main.async { completion(businessResult.businesses, nil) }
                // jump out of do block once get a throw of error
            } catch (let error) {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
        
        task.resume()
    }
}
