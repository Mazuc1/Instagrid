//
//  LayoutViewModel.swift
//  Instagrid
//
//  Created by Loic Mazuc on 26/11/2021.
//

import UIKit

class LayoutViewModel {
    
    //  MARK: - Properties
    
    var currentConfiguration: Configuration
    let configurations: [Configuration] = [Layout.firstTemplate, Layout.secondTemplate, Layout.thirdTemplate]
    
    private let marginsViewLayout: CGFloat = 15
    
    //  MARK: - Init
    
    init() {
        currentConfiguration = Layout.firstTemplate
    }
    
    //  MARK: - Methods
    
    func updateConfiguration(at index: Int) {
        currentConfiguration = configurations[index]
    }
    
    func createFrame(at index: Int, for frame: CGRect) -> (size: CGSize, origin: CGPoint) {
        let size = getSizeFor(ratio: currentConfiguration.ratio[index], frame: frame)
        let origin = getPointFor(location: currentConfiguration.locations[index], frame: frame)
        return (size: size, origin: origin)
    }
    
    private func getSizeFor(ratio: Ratio, frame: CGRect) -> CGSize {
        switch ratio {
        case .quarter:
            let sideLength = (frame.width / 2) - 15 - marginsViewLayout / 2
            return CGSize(width: sideLength, height: sideLength)
        case .half:
            let height = (frame.height / 2) - 15 - marginsViewLayout / 2
            let width = frame.width - 30
            return CGSize(width: width, height: height)
        }
    }
    
    private func getPointFor(location: Location, frame: CGRect) -> CGPoint {
        let centerXPoint = (frame.width / 2) + (marginsViewLayout / 2)
        let centerYPoint = (frame.height / 2) + (marginsViewLayout / 2)
        
        switch location {
        case .top, .left, .topLeft: return CGPoint(x: 15, y: 15)
        case .right, .topRight: return CGPoint(x: centerXPoint, y: 15)
        case .bottom, .bottomLeft: return CGPoint(x: 15, y: centerYPoint)
        case .bottomRight: return CGPoint(x: centerXPoint, y: centerYPoint)
        }
    }
}
