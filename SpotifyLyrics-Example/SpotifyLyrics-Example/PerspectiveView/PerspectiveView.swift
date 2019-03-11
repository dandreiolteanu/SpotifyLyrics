//
//  PerspectiveView.swift
//  SpotifyLyrics
//
//  Created by Andrei Olteanu on 19/11/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import UIKit

class PerspectiveView: UIView {

    // MARK: - Public properties

    enum Direction: Int {
        case yAxis
        case xAxis
        case both

        var dismissalOffset: CGFloat {
            switch self {
            case .yAxis:
                return 80
            case .xAxis:
                return 60
            case .both:
                return 90
            }
        }

        var alphaFadeOffset: CGFloat {
            switch self {
            case .yAxis, .xAxis:
                return 20
            case .both:
                return 40
            }
        }

        func transform(from translation: CGPoint) -> CGAffineTransform {
            switch self {
            case .yAxis:
                return CGAffineTransform(translationX: 0, y: translation.y)
            case .xAxis:
                return CGAffineTransform(translationX: translation.x, y: 0)
            case .both:
                return CGAffineTransform(translationX: translation.x, y: translation.y)
            }
        }

        func offset(from translation: CGPoint) -> CGFloat {
            switch self {
            case .yAxis:
                return abs(translation.y)
            case .xAxis:
                return abs(translation.x)
            case .both:
                return (abs(translation.x) + abs(translation.y)) / 1.5
            }
        }
    }

    /// Default direction is set to yAxis
    var direction: Direction = .yAxis

    // MARK: - Private properties

    private let firstView: UIView
    private let secondView: UIView

    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

    // This will always return the view closer to our eyes
    private var aboveView: UIView {
        return isFirstViewAbove ? firstView : secondView
    }

    // This will always return the view further to our eyes
    private var belowView: UIView {
        return isFirstViewAbove ? secondView : firstView
    }

    /// The initial "state"
    private var isFirstViewAbove = true
    private var isInTransition = false

    // MARK: - Lifecycle

    init(frontView: UIView, behindView: UIView) {
        self.firstView = frontView
        self.secondView = behindView

        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = .clear

        addSubview(firstView)
        addSubview(secondView)
        addGestureRecognizer(panGesture)

        setupInitialAnimationState()
    }

    private func setupConstraints() {
        firstView.snap(to: self)
        secondView.snap(to: self)
    }

    private func setupInitialAnimationState() {
        aboveView.layer.zPosition = .above

        belowView.layer.zPosition = .below
        belowView.transform = CGAffineTransform.scale.concatenating(.translation)
    }

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)

        switch sender.state {
        case .began, .changed:
            handlePanChanged(translation)
        case .ended:
            handlePanEnded()
        default:
            return
        }
    }

    private func handlePanChanged(_ translation: CGPoint) {
        let offset = direction.offset(from: translation)

        // Noticed that spotify makes the alpha percent grow quickly
        let alphaPercent = 1 - (offset - direction.alphaFadeOffset) / 100

        aboveView.transform = direction.transform(from: translation)
        aboveView.alpha = offset > direction.alphaFadeOffset ? alphaPercent : 1.0

        guard offset > direction.dismissalOffset else { return }
        panGesture.isEnabled = false
        handleTransition()
    }

    /// It means that the user did not pan enough and the aboveView needs to transform to identity
    private func handlePanEnded() {
        UIView.animate(withDuration: 0.33,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: {

            self.aboveView.transform = .identity
            self.aboveView.alpha = 1.0

        }, completion: nil)
    }

    private func handleTransition() {

        UIView.animate(withDuration: 0.33, animations: {
            self.aboveView.alpha = 1.0
            self.aboveView.layer.zPosition = .below
            self.aboveView.transform = CGAffineTransform.scale.concatenating(.translation)

            self.belowView.layer.zPosition = .above
            self.belowView.transform = .identity
        }, completion: { _ in
            self.isFirstViewAbove.toggle()
            self.panGesture.isEnabled = true
        })
    }
}

// MARK: - Constants

private extension CGAffineTransform {
    static let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
    static let translation = CGAffineTransform(translationX: 0, y: -30)
}

private extension CGFloat {
    static let below: CGFloat = 1
    static let above: CGFloat = 2
}
