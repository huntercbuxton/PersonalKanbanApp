//
//  ComposeTaskVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

enum CreateOrEdit {
    case create
    case edit
}

class AddEditTaskVC: UIViewController, InputsInterfaceDelegate, TaskEditorOptionsTable2Delegate {

    // MARK: - InputsInterfaceDelegate conformance

    func enableSave() {
        self.saveBtn.isEnabled = true
    }

    func disableSave() {
        self.saveBtn.isEnabled = false
    }

    // MARK: - TaskEditorOptionsTable2Delegate conformance

    func deleteTask() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in print("called handler for Cancel action") }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {_ in
            guard let task = self.taskMO else { fatalError("taskMO was nil when executing \(#function)") }
            self.persistenceManager.delete(task: task)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    let defaultStatus: WorkflowPosition!
    var selectedToArchive: Bool = false

    func archiveTask() {
        self.table.workflowPosition = nil
        selectedToArchive = true
    }

    func unArchiveTask() {
        self.table.workflowPosition = taskMO?.workflowStatusEnum ?? self.defaultStatus
        selectedToArchive = false
    }

    // MARK: - properties storing UI Components

   // weak var archiveChangeDelegate: ArchiveChangeDisplayDelegate?
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var saveBtn = UIBarButtonItem(barButtonSystemItem: .save,
                                                              target: self,
                                                              action: #selector(saveBtnTapped))
    private lazy var cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(cancelBtnTapped))
    private lazy var titleTextField: PaddedTextField = PaddedTextField()
    private lazy var notesTextView: LargeTextView = LargeTextView(text: "")
    private lazy var table: TaskDetailsTableVC = TaskDetailsTableVC(coreDataDAO: persistenceManager, task: taskMO, isReadOnly: false)
    // TaskEditingTable(useState: self.useState, editingDelegate: self, selectedEpic: self.selectedEpic, workflowStatus: self.workflowStatus, storyPoints: storyPoints)
    private lazy var table2 = TaskEditorOptionsTable2(delegate: self)
    private var taskLog: LogView?

    // MARK: - properties specifying UI style/layout

    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    // MARK: - other properties

    private let useState: CreateOrEdit
    private weak var updateDelegate: CoreDataDisplayDelegate!
    private var inputValidationManager: InputValidationManager!
    private let persistenceManager: PersistenceManager
    private var taskMO: Task?

    // MARK: - initial setup of UI components

    override func viewDidLoad() {
        super.viewDidLoad()
        // used in the first UITest file
        view.accessibilityIdentifier = "taskEditorVCID"
        saveBtn.accessibilityIdentifier = "saveBtn"
        cancelBtn.accessibilityIdentifier = "cancelBtn"
        titleTextField.accessibilityIdentifier = "titleTextField"

        self.view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        setupScrollViewAndContentView()
        setupInputFields()
        setupTable(table)
        table.view.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true

        if useState == .edit {
            setupTable(table2)
            table2.view.topAnchor.constraint(equalTo: table.view.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
            table2.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom).isActive = true
        } else {
            table.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom).isActive = true
        }

        setupDataStuff()
    }

    private func setupNavBar() {
        if useState  == .create {
            self.title = "create a task"
        }
        self.navigationItem.setRightBarButton(saveBtn, animated: false)
        saveBtn.isEnabled = false
        self.navigationItem.setLeftBarButton(cancelBtn, animated: false)
    }

    private func setupScrollViewAndContentView() {
        scrollView.layoutWithGuide(in: view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: scrollView, insets: margins)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -(margins.right*2)).isActive = true
    }

    private func setupInputFields() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margins.right).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margins.right).isActive = true
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        titleTextField.placeholder = UIConsts.titleFieldPlaceholderText

        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesTextView)
        notesTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margins.right).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margins.right).isActive = true
    }

    private func setupTable(_ tableVC: UITableViewController) {
        self.addChild(tableVC)
        tableVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableVC.view)
        tableVC.view.constrainHEdgesAnchors(contentView, constant: margins.right)
        let newSize = tableVC.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        tableVC.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
    }

    private func setupDataStuff() {
        self.inputValidationManager = InputValidationManager()
        self.inputValidationManager.delegate = self
        self.titleTextField.inputValidationDelegate = self.inputValidationManager
        if self.useState == .edit { prefillInputFields() }
    }

    private func prefillInputFields() {
        guard let task = taskMO else { fatalError("taskMO was nil when executing \(#function)") }
        self.titleTextField.text = task.title
        self.notesTextView.text = task.quickNote
        if let markAsArchived = taskMO?.isArchived {
            if markAsArchived {
                self.table2.isArchived = true
            }
        }
    }

    // MARK: - other methods

    @objc func saveBtnTapped() {
        if useState == .create {
            createTask(title: self.titleTextField.text!, notes: self.notesTextView.text)
        } else {
            saveChanges()
        }
        navigateToPreviousScreen()
    }

    @objc func cancelBtnTapped() {
        navigateToPreviousScreen()
    }

    private func navigateToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
        updateDelegate.updateCoreData()
    }

    private func createTask(title: String, notes: String) {
        let task = Task(context: persistenceManager.context)
        task.title = title
        task.quickNote = notes
        task.epic = table.selectedEpic
        task.storyPointsEnum = table.storyPoints
        let date = Date()
        task.dateCreated = DateConversion.format(date)
        task.dateUpdated = DateConversion.format(date)
        if selectedToArchive {
            task.isArchived = true
        } else {
            task.workflowStatusEnum = table.workflowPosition ?? self.defaultStatus
        }
        persistenceManager.save()
        self.updateDelegate.updateCoreData()
    }

    private func saveChanges() {
        guard let task = taskMO else { fatalError("taskMO was nil when executing \(#function)") }
        task.title = titleTextField.text
        task.quickNote = notesTextView.text
        task.epic = table.selectedEpic
        task.storyPointsEnum = table.storyPoints
        if selectedToArchive {
            task.isArchived = true
        } else {
            task.workflowStatusEnum = table.workflowPosition ?? self.defaultStatus
        }
        task.dateUpdated = DateConversion.format(Date())
        if table2.isArchived {
            task.isArchived = true
        }
        persistenceManager.save()
        self.updateDelegate.updateCoreData()
    }

//     MARK: - initialization

    // used when creating  anew task for a given epic
    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, task: Task? = nil, updateDelegate: CoreDataDisplayDelegate, selectedEpic: Epic) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.taskMO = task
        self.defaultStatus = task?.workflowStatusEnum ?? .inProgress
        self.updateDelegate = updateDelegate
        super.init(nibName: nil, bundle: nil)
        self.table.selectedEpic = selectedEpic
    }

    // used when editing an existing task
    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, task: Task? = nil, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.taskMO = task
        self.defaultStatus = task!.workflowStatusEnum ?? .inProgress
        self.updateDelegate = updateDelegate
        super.init(nibName: nil, bundle: nil)
    }

    // used when creating a new task
    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, updateDelegate: CoreDataDisplayDelegate, defaultPosition: WorkflowPosition = .backlog) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.defaultStatus = defaultPosition
        self.updateDelegate = updateDelegate
        super.init(nibName: nil, bundle: nil)
        self.table.workflowPosition = self.defaultStatus
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
