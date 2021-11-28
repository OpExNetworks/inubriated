//  EncodeJSON.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import Foundation

func encodeJSON<T: Codable>(structure: T, formatted: Bool) -> String {
    let encoder = JSONEncoder()
    if formatted { encoder.outputFormatting = [.sortedKeys, .prettyPrinted] }
    guard let jsonData = (try? encoder.encode(structure)) else { return "{}" }
    let jsonString = String(data: jsonData, encoding: .utf8)!
    return jsonString
}
