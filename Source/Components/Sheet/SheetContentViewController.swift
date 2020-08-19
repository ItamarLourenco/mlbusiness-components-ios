//
//  SheetContentViewController.swift
//  MLBusinessComponents
//
//  Created by Tomi De Lucca on 17/08/2020.
//

import UIKit

class SheetContentViewController: UIViewController {

    private(set) var viewController: UIViewController
    private var configuration: SheetConfiguration
    
    private var contentView = UIView()
    private var contentContainerView = UIView()
    private var handleView: UIVisualEffectView
    
    init(viewController: UIViewController, configuration: SheetConfiguration) {
        self.viewController = viewController
        self.configuration = configuration
        self.handleView = UIVisualEffectView(effect: UIBlurEffect(style: configuration.handle.tint.blurStyle()))
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        setupContentView()
        setupContentContainerView()
        setupChildView()
        setupHandleView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calculatePreferredContentSize()
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHandleView() {
        contentView.addSubview(handleView)
        handleView.translatesAutoresizingMaskIntoConstraints = false
        
        let gripHeight: CGFloat = 5.0
        let handleHeight: CGFloat
        
        if #available(iOS 11.0, *) {
            handleHeight = configuration.handle.height
        } else {
            handleHeight = SheetConfiguration.default.handle.height
        }
        
        NSLayoutConstraint.activate([
            handleView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor),
            handleView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
            handleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: (handleHeight - gripHeight) / 2),
            handleView.widthAnchor.constraint(equalToConstant: 40.0),
            handleView.heightAnchor.constraint(equalToConstant: gripHeight),
            handleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        handleView.layer.cornerRadius = gripHeight / 2
        handleView.layer.masksToBounds = true
    }
    
    private func setupContentContainerView() {
        contentView.addSubview(contentContainerView)
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            contentContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            contentContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        if configuration.cornerRadius > 0 {
            contentContainerView.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: configuration.cornerRadius)
            contentContainerView.layer.masksToBounds = true
        }
    }
    
    private func setupChildView() {
        viewController.willMove(toParent: self)
        addChild(viewController)
        contentContainerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leftAnchor.constraint(equalTo: contentContainerView.leftAnchor),
            viewController.view.rightAnchor.constraint(equalTo: contentContainerView.rightAnchor),
            viewController.view.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])
        
        if #available(iOS 11.0, *) {
            if configuration.handle.height > 0 {
                viewController.additionalSafeAreaInsets = UIEdgeInsets(top: configuration.handle.height, left: 0, bottom: 0, right: 0)
            }
        }
        
        viewController.didMove(toParent: self)
    }
    
    private func calculatePreferredContentSize() {
        let targetSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        preferredContentSize = viewController.view.systemLayoutSizeFitting(targetSize)
    }
}

private extension UIView {
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

private extension HandleTint {
    func blurStyle() -> UIBlurEffect.Style {
        switch self {
            case .light:
            return .extraLight
            case .dark:
            return .prominent
        }
    }
}
