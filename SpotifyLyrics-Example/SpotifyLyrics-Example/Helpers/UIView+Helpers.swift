//
//  UIView+Helpers.swift
//  SpotifyLyrics-Example
//
//  Created by Olteanu Andrei on 13/02/2019.
//  Copyright © 2019 Andrei Olteanu. All rights reserved.
//

import UIKit

extension UIView {

    func snap(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
