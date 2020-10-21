//
//  AddEditEpicVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class AddEditEpicVC: UIViewController, InputsInterfaceDelegate {

    let persistenceManager: PersistenceManager

    let useState: EditScreenUseState

    var epic: Epic?

    var updateDelegate: CoreDataDisplayDelegate!

    var inputValidationManager: InputValidationManager!

    private var titleText: String { useState == .create ? "Create Epic" : "Edit Epic" }

    private var titlePlaceholderText: String = "add a title"

    private let sectionSpacing: CGFloat = 20.0

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

    lazy var notesTextView: LargeTextView = LargeTextView(text: "")

    lazy var table = UITableViewController() //TaskEditingTable = TaskEditingTable(useState: self.useState, editingDelegate: self)

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

    private func createEpic(title: String, notes: String) {
        let epic = Epic(context: persistenceManager.context)
        epic.title = title
        epic.quickNote = notes
        persistenceManager.save()
    }

    private func saveChanges() {
        guard let epic = epic else { fatalError("epic was nil when executing \(#function)") }
        epic.title = titleTextField.text!
        epic.quickNote = notesTextView.text
        persistenceManager.save()
        self.updateDelegate.updateCoreData()
    }

    @objc func savedBarButtonTapped() {
        if useState == .create {
            createEpic(title: self.titleTextField.text!, notes: self.notesTextView.text)
        } else {
            saveChanges()
        }
        self.goBack()
        print("\(#function) was executed")
    }

    private func goBack() {
        if self.useState == .create {
            self.dismiss(animated: true, completion: {})
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        self.updateDelegate.updateCoreData()
    }


    @objc func cancelBarButtonTapped() {
        self.goBack()
        print("\(#function) was completed")
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
        guard let epic = epic else { fatalError("taskMO was nil when executing \(#function)") }
        self.titleTextField.text = epic.title
        self.notesTextView.text = epic.quickNote
    }

    // MARK: EditTaskTableDelegate conformance

    func deleteTask() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in print("called handler for Cancel action") }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {_ in
            guard let epic = self.epic else { fatalError("taskMO was nil when executing \(#function)") }
            self.persistenceManager.delete(epic: epic)
            self.goBack()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: initialization


    init(persistenceManager: PersistenceManager, useState: EditScreenUseState, epic: Epic? = nil, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.epic = epic
        self.updateDelegate = updateDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
