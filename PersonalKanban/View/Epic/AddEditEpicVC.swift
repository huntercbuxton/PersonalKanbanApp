//
//  AddEditEpicVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class AddEditEpicVC: UIViewController, InputsInterfaceDelegate, EpicDetailsMenuDelegate {

    // MARK: - EpicDetailsMenuDelegate conformance

    func updateTasks() {
        self.taskTable?.reloadDisplay()
        taskTableHeight = taskTable!.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        taskTableHeightConstraint!.constant = taskTableHeight!
        taskTable!.view.layoutIfNeeded()
    }

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

    lazy var inputValidation: EpicInputValidationManager = EpicInputValidationManager(delegate: self)
    var editingTable: EpicDetailsEditorMenuVC?
    var taskTable: EpicTasksList?
    var taskTableHeight: CGFloat?
    var taskTableHeightConstraint: NSLayoutConstraint?

    // MARK: - properties specifying UI style/layout

    private var titleText: String { useState == .create ? "create epic" : "" }
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    // MARK: - other properties

    let persistenceManager: PersistenceManager
    let useState: CreateOrEdit
    var epic: Epic?
    weak var updateDelegate: CoreDataDisplayDelegate!
    // MARK: - initial setup of UI components

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        setupScrollViewAndContentView()
        setupTextField()
        if self.useState == .edit {
            self.editingTable = EpicDetailsEditorMenuVC(persistenceManager: self.persistenceManager, epic: self.epic!, selectionDelegate: self)
            self.taskTable = EpicTasksList(persistenceManager: self.persistenceManager, epic: self.epic!)
            setupTables()
        } else {
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
        setupDataStuff()
    }

    private func setupNavBar() {
        self.title = self.titleText
        self.navigationItem.setRightBarButton(saveBarButton, animated: false)
        if self.useState == .create {
            saveBarButton.isEnabled = false
            self.navigationItem.setLeftBarButton(cancelBarButton, animated: false)
        }
    }

    private func setupScrollViewAndContentView() {
        scrollView.layoutWithGuide(in: view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: scrollView, insets: margins)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -(margins.left + margins.right)).isActive = true
    }

    private func setupTextField() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margins.right).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margins.right).isActive = true
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        titleTextField.placeholder = UIConsts.titleFieldPlaceholderText
        titleTextField.text = epic?.title
    }

    private func setupTables() {
        self.addChild(taskTable!)
        self.taskTable!.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskTable!.view)
        self.taskTable!.view.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        self.taskTable!.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margins.right).isActive = true
        self.taskTable?.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margins.right).isActive = true
        taskTable?.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        taskTableHeight = taskTable!.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        taskTableHeightConstraint = taskTable!.view.heightAnchor.constraint(equalToConstant: taskTableHeight!)
        taskTableHeightConstraint!.isActive = true

        self.addChild(editingTable!)
        self.editingTable!.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(editingTable!.view)
        self.editingTable!.view.topAnchor.constraint(equalTo: taskTable!.view.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        self.editingTable!.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margins.right).isActive = true
        self.editingTable?.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margins.right).isActive = true
        editingTable?.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let newSize = editingTable!.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        editingTable!.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        self.editingTable!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SavedLayouts.verticalSpacing).isActive = true
    }

    // MARK: - other methods

    private func createEpic(title: String) {
        let epic = Epic(context: persistenceManager.context)
        epic.title = title
        persistenceManager.save()
    }

    private func saveChanges() {
        guard let epic = epic else { fatalError("epic was nil when executing \(#function)") }
        epic.title = titleTextField.text!
        persistenceManager.save()
        self.updateDelegate.updateCoreData()
    }

    @objc func saveBtnTapped() {
        if useState == .create {
            createEpic(title: self.titleTextField.text!)
        } else {
            saveChanges()
        }
        self.goBack()
    }

    private func goBack() {
        self.navigationController?.popViewController(animated: true)
        self.updateDelegate.updateCoreData()
    }

    @objc func cancelBtnTapped() {
        self.goBack()
    }

    private func setupDataStuff() {
        titleTextField.epicUpdateDelegate = self.inputValidation
    }

    // MARK: - EditTaskTableDelegate conformance

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

    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, epic: Epic? = nil, updateDelegate: CoreDataDisplayDelegate) {
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
