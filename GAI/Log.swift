//
//  Log.swift
//  GAI
//
//  Created by Александр on 03.12.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

func DLog(_ messages: Any..., fullPath: String = #file, line: Int = #line, functionName: String = #function) {
    let file = NSURL.fileURL(withPath: fullPath)
    for message in messages {
        print("\(file.pathComponents.last!):\(line) -> \(functionName) \(message)")
    }
}
