//
//  Json.swift
//  geolocation
//
//  Created by Goh Chun Lin on 8/5/20.
//  Copyright © 2020 GCL Project. All rights reserved.
//

import Foundation

class Json {
    class func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
          options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: json, options: options)
          if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
          }
        } catch {
          print(error)
        }

        return ""
    }
}
