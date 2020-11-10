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

class AddEditTaskVC: UIViewController, InputsInterfaceDelegate, EditTaskTableDelegate, TaskEditorOptionsTable2Delegate, EpicsSelectorDelegate, WorkflowStatusSelectionDelegate {

    // MARK: - InputsInterfaceDelegate conformance

    func enableSave() {
        self.saveBtn.isEnabled = true
    }

    func disableSave() {
        self.saveBtn.isEnabled = false
    }

    // MARK: - EditTaskTableDelegate conformance

    func goToEpicSelectionScreen() {
        let epicsScreen = ChooseEpicsScreen(persistenceManager: persistenceManager, selectionDelegate: self)
        self.navigationController?.pushViewController(epicsScreen, animated: true)
    }

    func goToStoryPointsSelectionScreen() {
        let storyPointsVC = StoryPointsSelectionScreen(delegate: self, currentSelection: storyPoints)
        self.navigationController?.pushViewController(storyPointsVC, animated: true)
    }

    func goToWorkflowSelectorScreen() {
        let positionScreen = SelectWorkflowStatusMenu(workflowStatusSelectionDelegate: self, currentStatus: workflowStatus)
        self.navigationController?.pushViewController(positionScreen, animated: true)
    }

    // MARK: - TaskEditorOptionsTable2Delegate conformance

    func deleteTask() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in print("called handler for Cancel action") }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {_ in
            guard let task = self.taskMO else { fatalError("taskMO was nil when executing \(#function)") }
            self.persistenceManager.delete(task: task)
            self.navigateToPreviousScreen()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - EpicsSelectorDelegate conformance

    func selectEpic(_ selection: Epic) {
        selectedEpic = selection
    }

    // MARK: - StoryPointsSelectionDelegate conformance

    func selectStoryPoints(_ selectedValue: StoryPoints) {
        self.storyPoints = selectedValue
    }

    // MARK: - WorkflowStatusSelectionDelegate conformance

    func selectStatus(newStatus: WorkflowPosition) {
        self.workflowStatus = newStatus
    }

    // MARK: - properties storing working updates to the task data which has not been saved.

    var selectedEpic: Epic? {
        willSet {
            if newValue != selectedEpic {
                self.saveBtn.isEnabled = true
            }
        }
        didSet {
            self.table.selectedEpic = selectedEpic
        }
    }
    private lazy var storyPoints = taskMO?.storyPointsEnum ?? .unassigned {
        didSet {
            self.table.storyPoints = storyPoints
        }
    }
    private lazy var workflowStatus: WorkflowPosition = self.taskMO?.workflowStatusEnum ?? .backlog {
        didSet {
            self.table.workflowPosition = workflowStatus
        }
    }

    // MARK: - properties storing UI Components

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
    private lazy var table: TaskEditingTable = TaskEditingTable(useState: self.useState, editingDelegate: self, selectedEpic: self.selectedEpic, workflowStatus: self.workflowStatus, storyPoints: storyPoints)
    private lazy var table2 = TaskEditorOptionsTable2(delegate: self)
    private var taskLog: LogView?

    // MARK: - properties specifying UI style/layout

    private var titleText: String { useState == .create ? "Create Task" : "Edit Task" }
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    // MARK: - other properties

    private let useState: EditScreenUseState
    private weak var updateDelegate: CoreDataDisplayDelegate!
    private var inputValidationManager: InputValidationManager!
    private let persistenceManager: PersistenceManager
    private var taskMO: Task?

    // MARK: - initial setup of UI components

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        setupScrollViewAndContentView()
        setupInputFields()
        setupTable(table)
        table.view.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: UIConsts.verticalSpacing).isActive = true

        if useState == .edit {
            setupTable(table2)
            table2.view.topAnchor.constraint(equalTo: table.view.bottomAnchor, constant: UIConsts.verticalSpacing).isActive = true
            setupLog()
        } else {
            table.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom).isActive = true
        }
        setupDataStuff()
    }

    private func setupNavBar() {
        self.title = self.titleText
        self.navigationItem.setRightBarButton(saveBtn, animated: false)
        if self.useState == .create { saveBtn.isEnabled = false }
        self.navigationItem.setLeftBarButton(cancelBtn, animated: false)
    }

    private func setupScrollViewAndContentView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: scrollView, insets: margins)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -(margins.left + margins.right)).isActive = true
    }

    private func setupInputFields() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        titleTextField.layer.borderWidth = UIConsts.textInputBorderWidth
        titleTextField.layer.borderColor = UIConsts.textInputBorderColor
        titleTextField.layer.cornerRadius = UIConsts.textInputCornerRadius
        titleTextField.placeholder = UIConsts.titleFieldPlaceholderText

        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesTextView)
        notesTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: UIConsts.verticalSpacing).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        notesTextView.heightAnchor.constraint(equalToConstant: UIConsts.defaultTextViewHeight).isActive = true
        notesTextView.layer.borderWidth = UIConsts.textInputBorderWidth
        notesTextView.layer.borderColor = UIConsts.textInputBorderColor
        notesTextView.layer.cornerRadius = UIConsts.textInputCornerRadius
    }

    private func setupTable(_ tableVC: UITableViewController) {
        self.addChild(tableVC)
        tableVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableVC.view)
        tableVC.view.constrainHEdgesAnchors(contentView)
        let newSize = tableVC.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        tableVC.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
    }

    private func setupLog() {
        guard let task = self.taskMO else { fatalError("taskMO was nil in edit mode (called in \(#function)") }
        guard let d1 = task.dateCreated, let d2 = task.dateUpdated else { fatalError("in \(#function) the dates retrieved from taskMO were nil") }
        self.taskLog = LogView(dateCreated: d1, dateUpdated: d2)
        self.addChild(taskLog!)
        taskLog?.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview((taskLog!.view)!)
        taskLog?.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        taskLog?.view.topAnchor.constraint(equalTo: table2.view.bottomAnchor, constant: UIConsts.verticalSpacing).isActive = true
        taskLog?.view.constrainHEdgesAnchors(contentView)
        taskLog?.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
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
        if let current = task.epic {
            self.selectedEpic = current
            table.selectedEpic = selectedEpic
        }
    }

    // MARK: - other methods

    @objc func saveBtnTapped() {
        if useState == .create {
            createTask(title: self.titleTextField.text!, notes: self.notesTextView.text, epic: self.selectedEpic, status: self.workflowStatus)
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

    private func createTask(title: String, notes: String, epic: Epic?, status: WorkflowPosition?) {
        let task = Task(context: persistenceManager.context)
        task.title = title
        task.quickNote = notes
        task.epic = epic
        task.storyPointsEnum = storyPoints
        task.workflowStatusEnum = workflowStatus
        let date = Date()
        task.dateCreated = DateConversion.format(date)
        task.dateUpdated = DateConversion.format(date)
        persistenceManager.save()
        self.updateDelegate.updateCoreData()
    }

    private func saveChanges() {
        guard let task = taskMO else { fatalError("taskMO was nil when executing \(#function)") }
        task.title = titleTextField.text
        task.quickNote = notesTextView.text
        task.epic = selectedEpic
        task.storyPointsEnum = storyPoints
        task.workflowStatusEnum = workflowStatus
        task.dateUpdated = DateConversion.format(Date())
        persistenceManager.save()
        self.updateDelegate.updateCoreData()
    }

//     MARK: - initialization

    // used when editing an existing task
    init(persistenceManager: PersistenceManager, useState: EditScreenUseState, task: Task? = nil, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.taskMO = task
        self.updateDelegate = updateDelegate
        super.init(nibName: nil, bundle: nil)
    }

    // used when creating a new task
    init(persistenceManager: PersistenceManager, useState: EditScreenUseState, updateDelegate: CoreDataDisplayDelegate, defaultPosition: WorkflowPosition = .backlog) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.updateDelegate = updateDelegate
        super.init(nibName: nil, bundle: nil)
        self.workflowStatus = defaultPosition
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
