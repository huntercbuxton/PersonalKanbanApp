//
//  ComposeTaskVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class AddEditTaskVC: UIViewController, InputsInterfaceDelegate {

    let persistenceManager: PersistenceManager

    var inputValidationManager: InputValidationManager!

    lazy var saveBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                              target: self,
                                                              action: #selector(savedBarButtonTapped))

    lazy var cancelBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(cancelBarButtonTapped))

    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top//.fill
        stackView.distribution = .equalCentering//.equalSpacing
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .darkGray
        return stackView
    }()

    lazy var titleTexttField: PaddedTextField = PaddedTextField()

    lazy var notesTextView: LargeTextView = LargeTextView(text: "Test Text Here")

    private func createTask(title: String, notes: String) {
        let task = Task(context: persistenceManager.context)
        task.title = title
        task.notes = notes
        persistenceManager.save()
    }

    @objc func savedBarButtonTapped() {
        createTask(title: "a random title", notes: "some notes also")
        self.dismiss(animated: true, completion: {})
        print("\(#function) was executed")
    }

    @objc func cancelBarButtonTapped() {
        self.dismiss(animated: true, completion: {})
        print("\(#function) was completed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUIElements()
        setupDataStuff()

        let vHeight: CGFloat = view.frame.size.height - view.layoutMargins.bottom * 2
    /* print(String(describing: vHeight), "is the vHeight from view.frame.size.height -
         view.layoutMargins.top - view.layoutMargins.bottom") */
        notesTextView.topAnchor.constraint(equalTo: titleTexttField.bottomAnchor, constant: 15.0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: vHeight).isActive = true
    }

    // MARK: InputsInterfaceDelegate conformance

    func enableUse(for: String) {
        self.saveBarButton.isEnabled = true
    }

    func disableUse(for: String) {
        self.saveBarButton.isEnabled = false
    }

    // MARK: initial setup

    private func setupUIElements() {
        self.title = "Create Task"
        self.navigationItem.setRightBarButton(saveBarButton, animated: false)
        saveBarButton.isEnabled = false
        self.navigationItem.setLeftBarButton(cancelBarButton, animated: false)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.setupLayout(in: self.view)
    }

    private func setupDataStuff() {
        self.titleTexttField.setupLayout(in: stackView)
        notesTextView.setupLayout(in: stackView)
        self.inputValidationManager = InputValidationManager()
        self.inputValidationManager.delegate = self
        self.titleTexttField.inputValidationDelegate = self.inputValidationManager
        self.notesTextView.inputValidationDelegate = self.inputValidationManager
    }

    // MARK: initialization

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension UIStackView {

    func setupLayout(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        isBaselineRelativeArrangement = true
    }
}
