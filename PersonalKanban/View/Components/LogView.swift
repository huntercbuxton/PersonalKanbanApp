//
//  LogView.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class LogView: UIViewController {

    private var dateCreated: Date?
    private var dateUpdated: Date?

    lazy var createdLabel: UILabel = UILabel()
    lazy var updatedLabel: UILabel = UILabel()

    var createdLabelText: String {
        get {
            if let date = self.dateCreated {
                return "date created: \(DateConversion.toString(date: date)) "
            } else {
                return "Date created is nil"
            }
        }
    }
    var updatedLabelText: String {
        get {
            if let date = self.dateUpdated {
                return "date updated: \(DateConversion.toString(date: date)) "
            } else {
                return "Date updated is nil"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDisplay()
    }

    private func setupDisplay() {
        createdLabel.setup(in: view)
        createdLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        createdLabel.text = createdLabelText

        updatedLabel.setup(in: view)
        updatedLabel.topAnchor.constraint(equalTo: createdLabel.bottomAnchor).isActive = true
        updatedLabel.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        updatedLabel.text = updatedLabelText
    }

    init(dateCreated: Date?, dateUpdated: Date?) {
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UILabel {
    func setup(in view: UIView) {
         translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(self)
         self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
