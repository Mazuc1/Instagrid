//
//  ViewController.swift
//  Instagrid
//
//  Created by Loïc MAZUC on 15/11/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //  MARK: - Properties
    
    //  MARK: - Outlets
    
    @IBOutlet weak var labelInstagrid: UILabel!
    @IBOutlet weak var labelSwipeToShare: UILabel!
    @IBOutlet weak var stackViewLayout: UIStackView!
    
    //  MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //  MARK: - Actions
    
    @IBAction func didSelectLayout(_ sender: UIButton) {
        clearStackView()
        sender.setBackgroundImage(UIImage(named: "Selected_\(sender.tag)"), for: .normal)
    }
    
    //  MARK: - Methods

    private func configureUI() {
        view.backgroundColor = .background
        
        labelInstagrid.text = "Instagrid"
        labelInstagrid.font = UIFont.thirstySoft(size: 30)
        
        labelSwipeToShare.text = "^\nSwipe up to share"
        labelSwipeToShare.font = UIFont.delm(size: 26)
    }
    
    private func clearStackView() {
        _ = stackViewLayout.subviews.map {
            if let button = $0 as? UIButton {
                button.setBackgroundImage(UIImage(named: "Layout_\(button.tag)"), for: .normal)
            }
        }
    }

}

