//
//  Layout.swift
//  Instagrid
//
//  Created by Loic Mazuc on 18/11/2021.
//

import Foundation

class Layout {
    static var one = Configuration(numberOfPhoto: 3, positions: [.top, .bottomLeft, .bottomRight], ratio: [.half, .quarter, .quarter])
    static var two = Configuration(numberOfPhoto: 3, positions: [.topLeft, .topRight, .bottom], ratio: [.quarter, .quarter, .half])
    static var three = Configuration(numberOfPhoto: 4, positions: [.topLeft, .topRight, .bottomLeft, .bottomRight], ratio: [.quarter, .quarter, .quarter, .quarter])
}
