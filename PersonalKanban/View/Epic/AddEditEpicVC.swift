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
        resizeTable()
    }

    // MARK: - InputsInterfaceDelegate conformance

    func enableSave() {
        self.saveBtn.isEnabled = true
    }

    func disableSave() {
        self.saveBtn.isEnabled = false
    }

    // MARK: - properties storing UI Components

    lazy var saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnTapped))
    lazy var cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTapped))
    var scrollView: UIScrollView = UIScrollView()
    var contentView = UIView()
    lazy var titleTextField: PaddedTextField = PaddedTextField()
    var editingTable: EpicDetailsEditorMenuVC?
    var taskTable: EpicTasksList?

    // MARK: - other properties

    let persistenceManager: PersistenceManager
    let useState: CreateOrEdit
    var epic: Epic?
    lazy var inputValidation: EpicInputValidationManager = EpicInputValidationManager(delegate: self)
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins
    var taskTableHeight: CGFloat?
    var taskTableHeightConstraint: NSLayoutConstraint?

    // MARK: - initial setup of UI components

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        setupScrollViewAndContentView()
        setupTextField()
        if self.useState == .edit {
            self.editingTable = EpicDetailsEditorMenuVC(persistenceManager: self.persistenceManager, epic: self.epic!, selectionDelegate: self)
            self.taskTable = EpicTasksList(persistenceManager: self.persistenceManager, epic: self.epic!)
            setupTables()
        } else {
            self.title = "create an epic"
            self.navigationItem.setLeftBarButton(cancelBtn, animated: false)
            self.navigationItem.setRightBarButton(saveBtn, animated: false)
            saveBtn.isEnabled = false
            titleTextField.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor).isActive = true
        }
        setupDataStuff()
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
        taskTable!.resizeDelegate = self
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        epic?.title = titleTextField.text!
        persistenceManager.save()
    }

    @objc func saveBtnTapped() {
        createEpic(title: self.titleTextField.text!)
        persistenceManager.save()
        self.goBack()
    }

    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func cancelBtnTapped() {
        self.goBack()
    }

    private func setupDataStuff() {
        titleTextField.epicUpdateDelegate = self.inputValidation
    }

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

    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, epic: Epic? = nil) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.epic = epic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddEditEpicVC: EpicTaskListResizeDelegate {
    func resizeTable() {
        taskTableHeight = taskTable!.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        taskTableHeightConstraint!.constant = taskTableHeight!
        taskTable!.view.layoutIfNeeded()
    }
}
