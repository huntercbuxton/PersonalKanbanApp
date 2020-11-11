//
//  AddEditEpicVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class AddEditEpicVC: UIViewController, InputsInterfaceDelegate {

    // MARK: - InputsInterfaceDelegate conformance

    func enableSave() {
        self.saveBarButton.isEnabled = true
    }

    func disableSave() {
        self.saveBarButton.isEnabled = false
    }

    // MARK: - properties storing UI Components

    lazy var saveBarButton = UIBarButtonItem(barButtonSystemItem: .save,
                                                              target: self,
                                                              action: #selector(saveBtnTapped))
    lazy var cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(cancelBtnTapped))
    var scrollView: UIScrollView = UIScrollView()
    var contentView = UIView()
    lazy var titleTextField: PaddedTextField = PaddedTextField()
    lazy var notesTextView: LargeTextView = LargeTextView(text: "")
    lazy var table = UITableViewController()

    // MARK: - properties specifying UI style/layout

    private var titleText: String { useState == .create ? "create epic" : "edit epic" }
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    // MARK: - other properties

    let persistenceManager: PersistenceManager
    let useState: EditScreenUseState
    var epic: Epic?
    weak var updateDelegate: CoreDataDisplayDelegate!
        var inputValidationManager: InputValidationManager!

    // MARK: - initial setup of UI components

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        setupScrollViewAndContentView()
        setupTextField()
        setupTextView()
        setupTable()
        setupDataStuff()
    }

    private func setupNavBar() {
        self.title = self.titleText
        self.navigationItem.setRightBarButton(saveBarButton, animated: false)
        if self.useState == .create { saveBarButton.isEnabled = false }
        self.navigationItem.setLeftBarButton(cancelBarButton, animated: false)
    }

    private func setupScrollViewAndContentView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: scrollView, insets: margins)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -(margins.left + margins.right)).isActive = true
    }

    private func setupTextField() {
        let widthConst: CGFloat = contentView.layoutMargins.right
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthConst).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthConst).isActive = true
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        titleTextField.placeholder = UIConsts.titleFieldPlaceholderText
    }

    private func setupTextView() {
        let widthConst: CGFloat = contentView.layoutMargins.right
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesTextView)
        notesTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthConst).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthConst).isActive = true
    }

    private func setupTable() {
        let widthConst: CGFloat = contentView.layoutMargins.right
        self.addChild(table)
        self.table.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(table.view)
        self.table.view.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        self.table.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthConst).isActive = true
        self.table.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SavedLayouts.verticalSpacing).isActive = true
        self.table.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthConst).isActive = true
        table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let newSize = table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        table.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
    }

    // MARK: - other methods

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

    @objc func saveBtnTapped() {
        if useState == .create {
            createEpic(title: self.titleTextField.text!, notes: self.notesTextView.text)
        } else {
            saveChanges()
        }
        self.goBack()
        print("\(#function) was executed")
    }

    private func goBack() {
        self.navigationController?.popViewController(animated: true)
        self.updateDelegate.updateCoreData()
    }

    @objc func cancelBtnTapped() {
        self.goBack()
        print("\(#function) was completed")
    }

    private func setupDataStuff() {
        self.inputValidationManager = InputValidationManager()
        self.inputValidationManager.delegate = self
        self.titleTextField.inputValidationDelegate = self.inputValidationManager
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
