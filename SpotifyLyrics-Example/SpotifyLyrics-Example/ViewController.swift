//
//  ViewController.swift
//  SpotifyLyrics-Example
//
//  Created by Olteanu Andrei on 13/02/2019.
//  Copyright © 2019 Andrei Olteanu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let frontView = UIImageView(image: #imageLiteral(resourceName: "frontImg"))
    private let behindView = UIImageView(image: #imageLiteral(resourceName: "behindImg"))

    private lazy var perspectiveView = PerspectiveView(frontView: frontView, behindView: behindView)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(perspectiveView)

        perspectiveView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            perspectiveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            perspectiveView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            perspectiveView.heightAnchor.constraint(equalToConstant: 320),
            perspectiveView.widthAnchor.constraint(equalToConstant: 320)])
    }
}

