//
//  ViewController.swift
//  Instagrid
//
//  Created by Loïc MAZUC on 15/11/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //  MARK: - Properties
    
    let marginsViewLayout: CGFloat = 15
    
    //  MARK: - Outlets
    
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var labelInstagrid: UILabel!
    @IBOutlet weak var labelSwipeToShare: UILabel!
    @IBOutlet weak var stackViewLayout: UIStackView!
    
    //  MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createLayout(configuration: Layout.two)
    }
    
    //  MARK: - Actions
    
    @IBAction func didSelectLayout(_ sender: UIButton) {
        clearStackView()
        sender.setBackgroundImage(UIImage(named: "Selected_\(sender.tag)"), for: .normal)
        createLayout(configuration: getConfiguration(for: sender.tag))
    }
    
    //  MARK: - Methods

    private func configureUI() {
        view.backgroundColor = .background
        
        labelInstagrid.text = "Instagrid"
        labelInstagrid.font = UIFont.thirstySoft(size: 30)
        
        labelSwipeToShare.text = "^\nSwipe up to share"
        labelSwipeToShare.font = UIFont.delm(size: 26)
        
        viewLayout.backgroundColor = .darkBlue
    }
    
    private func clearStackView() {
        _ = stackViewLayout.subviews.map {
            if let button = $0 as? UIButton {
                button.setBackgroundImage(UIImage(named: "Layout_\(button.tag)"), for: .normal)
            }
        }
    }
    
    private func getConfiguration(for index: Int) -> Configuration {
        switch index {
        case 1: return Layout.one
        case 2: return Layout.two
        case 3: return Layout.three
        default: return Layout.one
        }
    }

}

//  MARK: - Create Layout

extension ViewController {
    
    private func createLayout(configuration: Configuration) {
        viewLayout.removeSubviews()
        for i in 0..<configuration.numberOfPhoto {
            let size = getSizeFor(ratio: configuration.ratio[i])
            let point = getPointFor(position: configuration.positions[i])
            let view = UIView(frame: CGRect(origin: point, size: size))
            view.layer.cornerRadius = 5
            view.backgroundColor = .white
            viewLayout.addSubview(view)
        }
    }
    
    private func getSizeFor(ratio: Ratio) -> CGSize {
        switch ratio {
        case .quarter:
            let calcul = (viewLayout.frame.width / 2) - 15 - marginsViewLayout / 2
            return CGSize(width: calcul, height: calcul)
        case .half:
            let height = (viewLayout.frame.height / 2) - 15 - marginsViewLayout / 2
            let width = viewLayout.frame.width - 30
            return CGSize(width: width, height: height)
        }
    }
    
    private func getPointFor(position: Positions) -> CGPoint {
        let centerXPoint = (viewLayout.frame.width / 2) + (marginsViewLayout / 2)
        let centerYPoint = (viewLayout.frame.height / 2) + (marginsViewLayout / 2)
        
        switch position {
        case .top, .left, .topLeft: return CGPoint(x: 15, y: 15)
        case .right, .topRight: return CGPoint(x: centerXPoint, y: 15)
        case .bottom, .bottomLeft: return CGPoint(x: 15, y: centerYPoint)
        case .bottomRight: return CGPoint(x: centerXPoint, y: centerYPoint)
        }
    }
    
}

