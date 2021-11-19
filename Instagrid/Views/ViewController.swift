//
//  ViewController.swift
//  Instagrid
//
//  Created by Loïc MAZUC on 15/11/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //  MARK: - Properties
    
    var imagePicker = UIImagePickerController()
    var currentConfiguration: Int = 2
    
    let marginsViewLayout: CGFloat = 15
    var photoViews: [PhotoView] = []
    var selectedIndex: Int = 0
    
    var swipeGesture: UISwipeGestureRecognizer!
    var defaultPosition: CGFloat = 0
    
    var orientation: UIDeviceOrientation = .faceUp
    
    //  MARK: - Outlets
    
    var portraitConstraints: [NSLayoutConstraint]!
    var landscapeConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var labelInstagrid: UILabel!
    @IBOutlet weak var labelSwipeToShare: UILabel!
    @IBOutlet weak var stackViewLayout: UIStackView!
    
    //  MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        
        configureUI()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToShare(_:)))
        swipeGesture.direction = .up
        view.addGestureRecognizer(swipeGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createLayout(configuration: getConfiguration(for: currentConfiguration))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            labelSwipeToShare.text = "^\nSwipe up to share"
            swipeGesture.direction = .up
            orientation = .faceUp
        } else {
            labelSwipeToShare.text = "< Swipe left to share"
            swipeGesture.direction = .left
            orientation = .landscapeLeft
        }
        
        updateConstraints()
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
        currentConfiguration = index
        switch index {
        case 1: return Layout.one
        case 2: return Layout.two
        case 3: return Layout.three
        default: return Layout.one
        }
    }
    
    //  MARK: - Swipe
    
    @objc private func swipeToShare(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            defaultPosition = viewLayout.frame.origin.y
            animateSwipe(direction: .up, backToPosition: false)
        } else if swipe.direction == .left {
            defaultPosition = viewLayout.frame.origin.x
            animateSwipe(direction: .left, backToPosition: false)
            
        }
    }
    
    private func animateSwipe(direction: UISwipeGestureRecognizer.Direction, backToPosition: Bool) {
        if backToPosition {
            UIView.animate(withDuration: 1) {
                switch direction {
                case .up: self.viewLayout.frame.origin.y = self.defaultPosition
                case .left: self.viewLayout.frame.origin.x = self.defaultPosition
                default: print("wrong swipe direction")
                }
            }
        } else {
            UIView.animate(withDuration: 1) {
                switch direction {
                case .up: self.viewLayout.frame.origin.y = -self.viewLayout.frame.height
                case .left: self.viewLayout.frame.origin.x = -self.viewLayout.frame.width
                default: print("wrong swipe direction")
                }
            } completion: {
                if $0 { self.presentActivityController(direction: direction) }
            }
        }
    }
    
    private func presentActivityController(direction: UISwipeGestureRecognizer.Direction) {
        let photo = viewLayout.asImage()
        let activityController = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            switch direction {
            case .up: self.animateSwipe(direction: .up, backToPosition: true)
            case .left: self.animateSwipe(direction: .left, backToPosition: true)
            default: print("error: presentActivityController")
            }
        }
        present(activityController, animated: true)
    }

}

//  MARK: - Create Layout

extension ViewController {
    
    private func createLayout(configuration: Configuration) {
        viewLayout.removeSubviews()
        photoViews.removeAll()
        
        for i in 0..<configuration.numberOfPhoto {
            let size = getSizeFor(ratio: configuration.ratio[i])
            let point = getPointFor(position: configuration.positions[i])
            
            let photoView = PhotoView(tag: i, frame: CGRect(origin: point, size: size), delegate: self)
            
            photoViews.append(photoView)
            viewLayout.addSubview(photoView)
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

//  MARK: - UIImagePickerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        photoViews[selectedIndex].photoIsSelected(image: image)
    }
}

//  MARK: - Photo View Delegate

extension ViewController: PhotoViewDelegate {
    func openGallery(for index: Int) {
        selectedIndex = index
        present(imagePicker, animated: true, completion: nil)
    }
}

//  MARK: - Constraints

extension ViewController {
    
    fileprivate func updateConstraints() {
        if orientation == .faceUp {
            stackViewLayout.axis = .horizontal
            _ = landscapeConstraints.map { $0.isActive = false }
            _ = portraitConstraints.map { $0.isActive = true }
        } else if orientation == .landscapeLeft {
            stackViewLayout.axis = .vertical
            _ = portraitConstraints.map { $0.isActive = false }
            _ = landscapeConstraints.map { $0.isActive = true }
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        createLayout(configuration: getConfiguration(for: currentConfiguration))
    }
    
    fileprivate func configureLayout() {
        viewLayout.translatesAutoresizingMaskIntoConstraints = false
        labelInstagrid.translatesAutoresizingMaskIntoConstraints = false
        labelSwipeToShare.translatesAutoresizingMaskIntoConstraints = false
        stackViewLayout.translatesAutoresizingMaskIntoConstraints = false
        
        portraitConstraints = createPortraitConstraints()
        landscapeConstraints = createLandscapeConstraints()
        updateConstraints()
    }
    
    fileprivate func createPortraitConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(labelInstagrid.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10))
        constraints.append(labelInstagrid.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        
        constraints.append(labelSwipeToShare.topAnchor.constraint(equalTo: labelInstagrid.bottomAnchor, constant: 40))
        constraints.append(labelSwipeToShare.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        
        constraints.append(viewLayout.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(viewLayout.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(viewLayout.widthAnchor.constraint(equalToConstant: 300))
        constraints.append(viewLayout.heightAnchor.constraint(equalToConstant: 300))
        
        constraints.append(stackViewLayout.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20))
        constraints.append(stackViewLayout.centerXAnchor.constraint(equalTo: view.centerXAnchor))

        return constraints
    }
    
    fileprivate func createLandscapeConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(labelInstagrid.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10))
        constraints.append(labelInstagrid.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        
        constraints.append(labelSwipeToShare.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor))
        constraints.append(labelSwipeToShare.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        
        constraints.append(viewLayout.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(viewLayout.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(viewLayout.widthAnchor.constraint(equalToConstant: 275))
        constraints.append(viewLayout.heightAnchor.constraint(equalToConstant: 275))
        
        constraints.append(stackViewLayout.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: 20))
        constraints.append(stackViewLayout.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        
        return constraints
    }
    
}

