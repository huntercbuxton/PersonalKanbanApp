//
//  ComposeTaskVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

enum EditScreenUseState {
    case create
    case edit
}

class AddEditTaskVC: UIViewController, InputsInterfaceDelegate {

    private let useState: EditScreenUseState
    private var titleText: String { useState == .create ? "Create Task" : "Edit Task" }
    private var titlePlaceholderText: String = "add a title"
    private var taskMO: Task?
    private let sectionSpacing: CGFloat = 20.0

    let persistenceManager: PersistenceManager

    var inputValidationManager: InputValidationManager!

    // MARK: UI Elements

    lazy var saveBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                              target: self,
                                                              action: #selector(savedBarButtonTapped))

    lazy var cancelBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(cancelBarButtonTapped))

    var scrollView: UIScrollView = UIScrollView()
    var contentView = UIView()

    lazy var titleTextField: PaddedTextField = PaddedTextField()

    lazy var notesTextView: LargeTextView = LargeTextView(text: "Test Text Here")

    lazy var table: TaskEditingTable = TaskEditingTable()

    // MARK: instance methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground

        setupUIElements()
        setupDataStuff()
    }

    // MARK: InputsInterfaceDelegate conformance

    func enableUse(for: String) {
        self.saveBarButton.isEnabled = true
    }

    func disableUse(for: String) {
        self.saveBarButton.isEnabled = false
    }

    private func createTask(title: String, notes: String) {
        let task = Task(context: persistenceManager.context)
        task.title = title
        task.notes = notes
        persistenceManager.save()
    }

    @objc func savedBarButtonTapped() {
        createTask(title: "a random title", notes: "some notes also")
        self.goBack()
        print("\(#function) was executed")
    }

    @objc func cancelBarButtonTapped() {
        self.goBack()
        print("\(#function) was completed")
    }

    private func goBack() {
        if self.useState == .create {
            self.dismiss(animated: true, completion: {})
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: initial setup

    private func setupUIElements() {
        self.title = self.titleText
        self.navigationItem.setRightBarButton(saveBarButton, animated: false)
        saveBarButton.isEnabled = false
        self.navigationItem.setLeftBarButton(cancelBarButton, animated: false)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])

        let widthConst: CGFloat = contentView.layoutMargins.right

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthConst).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthConst).isActive = true
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0).isActive = true
        titleTextField.layer.borderWidth = 2.5
        titleTextField.layer.borderColor = UIColor.systemGray5.cgColor
        titleTextField.layer.cornerRadius = 8
        titleTextField.placeholder = titlePlaceholderText

        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesTextView)
        print(String(describing: widthConst))
        notesTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: sectionSpacing).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthConst).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthConst).isActive = true
        notesTextView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        notesTextView.isScrollEnabled = false
        notesTextView.layer.borderWidth = 2.5
        notesTextView.layer.borderColor = UIColor.systemGray5.cgColor
        notesTextView.layer.cornerRadius = 8

        self.addChild(table)
        self.table.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(table.view)
        self.table.view.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: sectionSpacing).isActive = true
        self.table.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        self.table.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        self.table.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let newSize = table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        table.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
    }

    private func setupDataStuff() {
        self.inputValidationManager = InputValidationManager()
        self.inputValidationManager.delegate = self
        self.titleTextField.inputValidationDelegate = self.inputValidationManager
        self.notesTextView.inputValidationDelegate = self.inputValidationManager
        if self.useState == .edit { prefillInputFields() }
    }

    private func prefillInputFields() {
        guard let task = taskMO else { fatalError("taskMO was nil when executing \(#function)") }
        self.titleTextField.text = task.title
        self.notesTextView.text = task.notes
    }

    // MARK: initialization

    init(persistenceManager: PersistenceManager, useState: EditScreenUseState, task: Task? = nil) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.taskMO = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
