//
//  LogView.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class LogView: UIViewController {

    lazy var sectionLabel: UILabel = UILabel()
    lazy var dateCreatedLabel: UILabel = UILabel()
    lazy var dateUpdatedLabel: UILabel = UILabel()

    private var dateCreated: Date
    private var dateUpdated: Date
    private let horizontalMargin: CGFloat = 10
    private let verticalMargin: CGFloat = 10
    private let verticalItemSpacing: CGFloat = 15

    private let sectionLabelText = "notes"
    private var createdLabelText: String { "task created on \(DateConversion.toString(date: dateCreated)) " }
    private var updatedLabelText: String { "task updated on \(DateConversion.toString(date: dateUpdated)) " }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDisplay()
        view.backgroundColor = .systemBackground
    }

    private func setupDisplay() {
        sectionLabel.text = sectionLabelText
        sectionLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        sectionLabel.setup(in: view, margin: horizontalMargin)
        sectionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalMargin).isActive = true

        dateCreatedLabel.setup(in: view, margin: horizontalMargin)
        dateCreatedLabel.topAnchor.constraint(greaterThanOrEqualTo: sectionLabel.bottomAnchor, constant: verticalItemSpacing).isActive = true
        dateCreatedLabel.text = createdLabelText

        dateUpdatedLabel.setup(in: view, margin: horizontalMargin)
        dateUpdatedLabel.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: verticalItemSpacing).isActive = true
        dateUpdatedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -verticalMargin).isActive = true
        dateUpdatedLabel.text = updatedLabelText
    }

    init(dateCreated: Date, dateUpdated: Date) {
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UILabel {
    func setup(in view: UIView, margin: CGFloat) {
         translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(self)
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
