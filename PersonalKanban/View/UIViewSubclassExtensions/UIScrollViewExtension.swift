//
//  UIScrollViewExtension.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/12/20.
//

import UIKit

extension UIScrollView {

    func layoutWithGuide(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
