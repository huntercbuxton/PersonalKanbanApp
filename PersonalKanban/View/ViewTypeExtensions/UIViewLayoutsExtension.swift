//
//  UIViewLayoutsExtension.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/21/20.
//

import UIKit

public extension UIView {

    func constrainEdgeAnchors(to view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        constrainHEdgesAnchors(view, constant: constant)
        constrainVEdgeAnchors(view, constant: constant)
    }

    // MARK: - constrain using UIEdgeInsets

    func constrainEdgeAnchors(to view: UIView, insets: UIEdgeInsets) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
                                      trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right),
                                      topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
                                      bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)])
    }

    func constrainEdgeAnchors(to view: UIScrollView, insets: UIEdgeInsets) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
                                      trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
                                      topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
                                      bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)])
    }

    // MARK: - constrain to matching anchors of a view

    func constrainHEdgesAnchors(_ view: UIView, constant: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
    }

    func constrainVEdgeAnchors(_ view: UIView, constant: CGFloat) {
        topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
    }

    func constrainCenterAnchors(_ view: UIView, constant: CGFloat) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }

    func constrainDimensionAnchors(to view: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1) {
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: constant).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: constant).isActive = true
    }

    // MARK: - constraining to constant values

    func constrainDimeensionAnchorsToConstant(width wConst: CGFloat, height hConst: CGFloat) {
        widthAnchor.constraint(equalToConstant: wConst).isActive = true
        widthAnchor.constraint(equalToConstant: hConst).isActive = true
    }

}
