//
//  Configuration.swift
//  Instagrid
//
//  Created by Loic Mazuc on 18/11/2021.
//

import Foundation

struct Configuration {
    var numberOfPhoto: Int
    var positions: [Positions]
    var ratio: [Ratio]
}

enum Positions { // Rename
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

enum Ratio {
    case quarter
    case half
}
