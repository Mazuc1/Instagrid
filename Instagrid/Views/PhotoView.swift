//
//  PhotoView.swift
//  Instagrid
//
//  Created by Loic Mazuc on 19/11/2021.
//

import UIKit

protocol PhotoViewDelegate: AnyObject {
    func openGallery(for index: Int)
}

class PhotoView: UIView {
    
    private var delegate: PhotoViewDelegate?
    private var image: UIImage?
    
    var imageView: UIImageView = {
        UIImageView().configure {
            $0.contentMode = .scaleAspectFill
        }
    }()
    
    var button: UIButton = {
        UIButton().configure {
            $0.setImage(UIImage(named: "Plus"), for: .normal)
            $0.adjustsImageWhenHighlighted = false
            $0.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        }
    }()
    
    init(tag: Int, frame: CGRect, delegate: PhotoViewDelegate?) {
        super.init(frame: frame)
        button.tag = tag
        self.delegate = delegate
        
        layer.cornerRadius = 5
        backgroundColor = .white
        clipsToBounds = true
        
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size)
        
        addSubview(imageView)
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func openGallery(_ button: UIButton) {
        delegate?.openGallery(for: button.tag)
    }
    
    func photoIsSelected(image: UIImage) {
        self.image = image
        imageView.image = image
        button.setImage(nil, for: .normal)
    }

}
