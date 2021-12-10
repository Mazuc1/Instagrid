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
    var configurations: [Configuration] = [Layout.one, Layout.two, Layout.three]
    
    let marginsViewLayout: CGFloat = 15
    
    //  MARK: - Init
    
    init() {
        currentConfiguration = configurations.first! // Layout one
    }
    
    //  MARK: - Methods
    
    func updateConfiguration(at index: Int) {
        currentConfiguration = configurations[index]
    }
    
    func createFrame(at index: Int, for frame: CGRect) -> (size: CGSize, origin: CGPoint) {
        let size = getSizeFor(ratio: currentConfiguration.ratio[index], frame: frame)
        let origin = getPointFor(position: currentConfiguration.positions[index], frame: frame)
        return (size: size, origin: origin)
    }
    
    private func getSizeFor(ratio: Ratio, frame: CGRect) -> CGSize {
        switch ratio {
        case .quarter:
            let calcul = (frame.width / 2) - 15 - marginsViewLayout / 2 //  Rename calcul : sideLength
            return CGSize(width: calcul, height: calcul)
        case .half:
            let height = (frame.height / 2) - 15 - marginsViewLayout / 2
            let width = frame.width - 30
            return CGSize(width: width, height: height)
        }
    }
    
    private func getPointFor(position: Positions, frame: CGRect) -> CGPoint {
        let centerXPoint = (frame.width / 2) + (marginsViewLayout / 2)
        let centerYPoint = (frame.height / 2) + (marginsViewLayout / 2)
        
        switch position {
        case .top, .left, .topLeft: return CGPoint(x: 15, y: 15)
        case .right, .topRight: return CGPoint(x: centerXPoint, y: 15)
        case .bottom, .bottomLeft: return CGPoint(x: 15, y: centerYPoint)
        case .bottomRight: return CGPoint(x: centerXPoint, y: centerYPoint)
        }
    }
}
