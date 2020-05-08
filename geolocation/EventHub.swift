//
//  EventHub.swift
//  geolocation
//
//  Created by Goh Chun Lin on 7/5/20.
//  Copyright © 2020 GCL Project. All rights reserved.
//

import Foundation
import Alamofire


class EventHub {
    static var eventHubKey = ""
    
    class func serizalizeDataForBatchPosting(data: [[String : Double]]) -> [[String : String]] {
        var arr = [[String : String]]()
        for item in data {
            let serializedInformation = try! JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            let serializedData = ["Body": String(data: serializedInformation, encoding: String.Encoding.utf8)!]
            arr.append(serializedData)
        }
        return arr
    }
    
    class func postEvent(data: [[String : String]]) {
        let eventHubName = NSURL(string: ApiKey.GetApiKey(key: "AzureEventHubEndpoint")!)!
        let azureSasTokenGeneratorUrl = ApiKey.GetApiKey(key: "SasTokenGeneratorUrl")!
        
        let urlString = "\(eventHubName)/messages"
        let json = Json.stringify(json: data)

        let url = URL(string: urlString)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        print(json)

        var request = URLRequest(url: url as URL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/vnd.microsoft.servicebus.json", forHTTPHeaderField: "Content-Type")
        request.setValue(eventHubKey, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        // Usage of responseString
        //
        // Reference:
        // 1. https://stackoverflow.com/questions/32355850/alamofire-invalid-value-around-character-0
        Alamofire.request(request).responseString {
            (response) in
            
            let statusCode = response.response?.statusCode
            print(statusCode ?? "-")
            
            if statusCode == 401 {
                
                var sasTokenRequest = URLRequest(url: URL(string: azureSasTokenGeneratorUrl)!)
                sasTokenRequest.httpMethod = HTTPMethod.post.rawValue
                
                Alamofire.request(sasTokenRequest).responseString {
                    (sasTokenResponse) in
                    
                    let sasTokenStatusCode = sasTokenResponse.response?.statusCode
                    
                    if sasTokenStatusCode == 200 {
                        eventHubKey = sasTokenResponse.result.value!
                        
                        postEvent(data: data)
                    } else {
                        print("ERROR: We cannot get the SAS token.")
                    }
                }
                
            } else {
                
                switch response.result {
                    case .success:
                        print(response)
                        break

                    case .failure(let error):
                        print(error)
                }
                
            }
        }
    }
    
    
}
