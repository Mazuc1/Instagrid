//
//  ViewController.swift
//  Instagrid
//
//  Created by Loïc MAZUC on 15/11/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //  MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    
    private var photoViews: [PhotoView] = []
    private var selectedLayoutIndex: Int = 0
    
    private var swipeGesture: UISwipeGestureRecognizer!
    private var defaultViewLayoutPosition: CGFloat = 0
    
    private var orientation: UIDeviceOrientation = .faceUp
    
    private var layoutViewModel: LayoutViewModel!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { [.landscapeLeft, .portrait] }
    
    private var portraitConstraints: [NSLayoutConstraint]!
    private var landscapeConstraints: [NSLayoutConstraint]!
    
    //  MARK: - Outlets
    
    @IBOutlet weak private var viewLayout: UIView!
    @IBOutlet weak private var labelInstagrid: UILabel!
    @IBOutlet weak private var labelSwipeToShare: UILabel!
    @IBOutlet weak private var stackViewLayout: UIStackView!
    
    //  MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutViewModel = LayoutViewModel()
        
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
        createLayout(configuration: layoutViewModel.currentConfiguration)
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
        layoutViewModel.updateConfiguration(at: sender.tag)
        createLayout(configuration: layoutViewModel.currentConfiguration)
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
    
    //  MARK: - Swipe
    
    @objc private func swipeToShare(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            defaultViewLayoutPosition = viewLayout.frame.origin.y
            animateSwipe(direction: .up, backToPosition: false)
        } else if swipe.direction == .left {
            defaultViewLayoutPosition = viewLayout.frame.origin.x
            animateSwipe(direction: .left, backToPosition: false)
            
        }
    }
    
    private func animateSwipe(direction: UISwipeGestureRecognizer.Direction, backToPosition: Bool) {
        if backToPosition {
            UIView.animate(withDuration: 1) {
                switch direction {
                case .up: self.viewLayout.frame.origin.y = self.defaultViewLayoutPosition
                case .left: self.viewLayout.frame.origin.x = self.defaultViewLayoutPosition
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
            let photoFrame = layoutViewModel.createFrame(at: i, for: viewLayout.frame)
            let photoView = PhotoView(tag: i, frame: CGRect(origin: photoFrame.origin, size: photoFrame.size), delegate: self)
            
            photoViews.append(photoView)
            viewLayout.addSubview(photoView)
        }
    }
    
    private func updateLayout(configuration: Configuration) {
        for (index, photoView) in photoViews.enumerated() {
            let photoFrame = layoutViewModel.createFrame(at: index, for: viewLayout.frame)
            photoView.frame = CGRect(origin: photoFrame.origin, size: photoFrame.size)
        }
    }
}

//  MARK: - UIImagePickerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        photoViews[selectedLayoutIndex].photoIsSelected(image: image)
    }
}

//  MARK: - Photo View Delegate

extension ViewController: PhotoViewDelegate {
    func openGallery(for index: Int) {
        selectedLayoutIndex = index
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
        
        updateLayout(configuration: layoutViewModel.currentConfiguration)
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
        constraints.append(labelSwipeToShare.rightAnchor.constraint(equalTo: viewLayout.leftAnchor))
        
        constraints.append(viewLayout.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(viewLayout.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(viewLayout.widthAnchor.constraint(equalToConstant: 275))
        constraints.append(viewLayout.heightAnchor.constraint(equalToConstant: 275))
        
        constraints.append(stackViewLayout.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: 10))
        constraints.append(stackViewLayout.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        
        return constraints
    }
    
}

