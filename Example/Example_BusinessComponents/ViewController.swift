//
//  ViewController.swift
//  Example_BusinessComponents
//
//  Created by Juan sebastian Sanzone on 9/9/19.
//  Copyright © 2019 Mercado Libre. All rights reserved.
//

import UIKit
import MLBusinessComponents

class ViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    
    private weak var ringView: MLBusinessLoyaltyRingView?
    private weak var loyaltyHeaderView: MLBusinessLoyaltyHeaderView?
    private var discountTouchpointsView: MLBusinessTouchpointsView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateRing()
    }
}

// MARK: Setups
extension ViewController {
    private func setupView() {
        let newRingView = setupRingView()
        self.ringView = newRingView
        let dividingLineView = setupDividingLineView(bottomOf: newRingView)
        let itemDescriptionView = setupItemDescriptionView(bottomOf: dividingLineView)
        let crossSellingBoxView = setupCrossSellingBoxView(bottomOf: itemDescriptionView)
        let discountView = setupDiscountView(numberOfItems: 6, bottomOf: crossSellingBoxView)
        let actionCardView = setupActionCardView(bottomOf: discountView)
        let discountTouchpointView = setupDiscountTouchpointsView(numberOfItems: 6, bottomOf: actionCardView)
        let downloadAppView = setupDownloadAppView(bottomOf: discountTouchpointView)
        let loyaltyHeaderView = setupLoyaltyHeaderView(bottomOf: downloadAppView)
        let animatedButtonView = setupAnimatedButtonView(bottomOf: loyaltyHeaderView)
        let rowView = setupRowView(bottomOf: animatedButtonView)
        let hybridRow = setupHybridRowView(bottomOf: rowView)
        
        hybridRow.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -64).isActive = true
    }

    private func setupRingView() -> MLBusinessLoyaltyRingView {
        let ringView = MLBusinessLoyaltyRingView(LoyaltyRingData(), fillPercentProgress: false)

        containerView.addSubview(ringView)

        NSLayoutConstraint.activate([
            ringView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            ringView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            ringView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])

        ringView.addTapAction { deepLink in
            print(deepLink)
        }

        return ringView
    }

    private func setupDividingLineView(bottomOf targetView: UIView) -> UIView {
        let dividingLineView = MLBusinessDividingLineView(hasTriangle: true)
        containerView.addSubview(dividingLineView)
        NSLayoutConstraint.activate([
            dividingLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            dividingLineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            dividingLineView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 20)
        ])
        return dividingLineView
    }

    private func setupDiscountView(numberOfItems: Int, bottomOf targetView: UIView) -> MLBusinessDiscountBoxView {
        let discountView = MLBusinessDiscountBoxView(DiscountData(numberOfItems: numberOfItems))
        containerView.addSubview(discountView)
        NSLayoutConstraint.activate([
            discountView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            discountView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            discountView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16)
        ])
        discountView.addTapAction { (selectedIndex, deepLink, trackId) in
            print("EBC: index \(selectedIndex), deeplink: \(deepLink ?? ""), trackId: \(trackId ?? "")")
            discountView.update(DiscountData(numberOfItems: Int.random(in: 1...6)))
        }
        return discountView
    }

    private func setupActionCardView(bottomOf targetView: UIView) -> MLBusinessActionCardView {
        let actionCardView = MLBusinessActionCardView(ActionCardData())
        containerView.addSubview(actionCardView)
        NSLayoutConstraint.activate([
            actionCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            actionCardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            actionCardView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16)
        ])
        actionCardView.addTapAction {
            print("Button tapped")
        }
        return actionCardView
    }
    
    private func setupDiscountTouchpointsView(numberOfItems: Int, bottomOf targetView: UIView) -> UIView {
        discountTouchpointsView = MLBusinessTouchpointsView()
        guard let discountTouchpointsView = discountTouchpointsView else { return UIView(frame: .zero) }
        discountTouchpointsView.delegate = self
        discountTouchpointsView.setTouchpointsTracker(with: DiscountTrackerData(touchPointId: "BusinessComponents-Example"))
        discountTouchpointsView.update(with: DiscountTouchpointsGridData(numberOfItems: numberOfItems))
        containerView.addSubview(discountTouchpointsView)
        NSLayoutConstraint.activate([
            discountTouchpointsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            discountTouchpointsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            discountTouchpointsView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16)
        ])
        return discountTouchpointsView
    }
    
    private func setupDownloadAppView(bottomOf targetView: UIView) -> MLBusinessDownloadAppView {
        let downloadAppView = MLBusinessDownloadAppView(DownloadAppData())
        containerView.addSubview(downloadAppView)
        NSLayoutConstraint.activate([
            downloadAppView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16),
            downloadAppView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            downloadAppView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])

        downloadAppView.addTapAction { (deepLink) in
//            print(deepLink)
        }
        
        return downloadAppView
    }

    private func setupCrossSellingBoxView(bottomOf targetView: UIView) -> MLBusinessCrossSellingBoxView {

        let crossSellingBoxView = MLBusinessCrossSellingBoxView(CrossSellingBoxData())
        containerView.addSubview(crossSellingBoxView)
        NSLayoutConstraint.activate([
            crossSellingBoxView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            crossSellingBoxView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            crossSellingBoxView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16)
        ])

        crossSellingBoxView.addTapAction { (deepLink) in
            print(deepLink)
        }
        
        return crossSellingBoxView
    }
    
    private func setupLoyaltyHeaderView(bottomOf targetView: UIView) -> MLBusinessLoyaltyHeaderView {
        let loyaltyHeaderView = MLBusinessLoyaltyHeaderView(LoyaltyHeaderData(), fillPercentProgress: false)
        containerView.addSubview(loyaltyHeaderView)
        NSLayoutConstraint.activate([
            loyaltyHeaderView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16),
            loyaltyHeaderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            loyaltyHeaderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
            ])
        self.loyaltyHeaderView = loyaltyHeaderView
        return loyaltyHeaderView
    }
    
    private func setupItemDescriptionView(bottomOf targetView: UIView) -> MLBusinessItemDescriptionView {
        let itemDescriptionView = MLBusinessItemDescriptionView(ItemDescriptionData())
        containerView.addSubview(itemDescriptionView)
        NSLayoutConstraint.activate([
            itemDescriptionView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16),
            itemDescriptionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            itemDescriptionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
            ])
        return itemDescriptionView
    }

    private func setupAnimatedButtonView(bottomOf targetView: UIView) -> MLBusinessAnimatedButton {
        let animatedButtonView = MLBusinessAnimatedButton(normalLabel: "Normal", loadingLabel: "Loading")
        containerView.addSubview(animatedButtonView)
        NSLayoutConstraint.activate([
            animatedButtonView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16),
            animatedButtonView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            animatedButtonView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        animatedButtonView.addTarget(self, action: #selector(animatedButtonDidTap(_:)), for: .touchUpInside)
        animatedButtonView.delegate = self

        return animatedButtonView
    }
    
    private func setupRowView(bottomOf targetView: UIView) -> MLBusinessRowView {
        let rowView = MLBusinessRowView()
        rowView.update(with: RowData())
        containerView.addSubview(rowView)
        NSLayoutConstraint.activate([
            rowView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16),
            rowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            rowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        return rowView
    }
    
    private func setupHybridRowView(bottomOf targetView: UIView) -> UIView {
        let discountTouchpointsView = MLBusinessTouchpointsView()
        discountTouchpointsView.setTouchpointsTracker(with: DiscountTrackerData(touchPointId: "BusinessComponents-Example"))
        discountTouchpointsView.update(with: HybridCarouselData())
        containerView.addSubview(discountTouchpointsView)
        NSLayoutConstraint.activate([
            discountTouchpointsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            discountTouchpointsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            discountTouchpointsView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 16)
        ])
        return discountTouchpointsView
    }

    @objc
    private func animatedButtonDidTap(_ button: MLBusinessAnimatedButton) {
        button.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            button.finishLoading(color: .ml_meli_green(), image: nil)
        }
    }

}

extension ViewController {
    private func animateRing() {
        ringView?.fillPercentProgressWithAnimation()
        loyaltyHeaderView?.fillPercentProgressWithAnimation()
    }
}

extension ViewController: MLBusinessAnimatedButtonDelegate {
    func expandAnimationInProgress() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func didFinishAnimation(_ animatedButton: MLBusinessAnimatedButton) {
        guard let navigationController = navigationController else { return }

        let newVC = UIViewController()
        newVC.view.backgroundColor = .red

        animatedButton.goToNextViewController(newVC, navigationController)
    }

    func progressButtonAnimationTimeOut() {
        print("TimeOut")
    }

}

extension ViewController: MLBusinessTouchpointsUserInteractionHandler {
    func didTap(with selectedIndex: Int, deeplink: String, trackingId: String) {
        print("EBC: index \(selectedIndex), deeplink: \(deeplink), trackId: \(trackingId)")
        guard let discountTouchpointsView = discountTouchpointsView else { return }
        discountTouchpointsView.update(with: DiscountTouchpointsGridData(numberOfItems: Int.random(in: 1...6)))
    }
}
