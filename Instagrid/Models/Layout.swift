//
//  Layout.swift
//  Instagrid
//
//  Created by Loic Mazuc on 18/11/2021.
//

import Foundation

struct Layout {
    static var firstTemplate = Configuration(numberOfPhoto: 3, locations: [.top, .bottomLeft, .bottomRight], ratio: [.half, .quarter, .quarter])
    static var secondTemplate = Configuration(numberOfPhoto: 3, locations: [.topLeft, .topRight, .bottom], ratio: [.quarter, .quarter, .half])
    static var thirdTemplate = Configuration(numberOfPhoto: 4, locations: [.topLeft, .topRight, .bottomLeft, .bottomRight], ratio: [.quarter, .quarter, .quarter, .quarter])
}
