//
//  Configuration.swift
//  Instagrid
//
//  Created by Loic Mazuc on 18/11/2021.
//

import Foundation

struct Configuration {
    let numberOfPhoto: Int
    let locations: [Location]
    let ratio: [Ratio]
}

enum Location {
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
