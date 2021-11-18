//
//  Collection+extension.swift
//  FrenchGameFactory
//
//  Created by Loic Mazuc on 04/11/2021.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element {
     return (startIndex <= index && index < endIndex) ? self[index] : self[startIndex]
   }
}
