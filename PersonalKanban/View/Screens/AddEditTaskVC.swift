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

protocol EditTaskTableDelegate {
    func deleteTask()
    func goToEpicSelectionScreen()
    func goToWorkflowSelectorScreen()
}

protocol WorkflowStatusSelectionDelegate {
    func selectStatus(newStatus: WorkflowPosition)
}

class AddEditTaskVC: UIViewController, InputsInterfaceDelegate, EditTaskTableDelegate, EpicsSelectorDelegate, WorkflowStatusSelectionDelegate {


    // MARK: EditTaskTableDelegate conformance

    func goToEpicSelectionScreen() {
        let epicsScreen = ChooseEpicsScreen(persistenceManager: persistenceManager, selectionDelegate: self)
        self.navigationController?.pushViewController(epicsScreen, animated: true)
    }

    // MARK: EpicsSelectorDelegate conformance

    func select(epic: Epic) {
        self.selectedEpic = epic
        self.table.selectedEpic = selectedEpic
    }

    // MARK: WorkflowStatusSelectionDelegate conformance

    func selectStatus(newStatus: WorkflowPosition) {
        self.selectedStatus = newStatus
        self.table.selectedStatus = selectedStatus
    }

    func goToWorkflowSelectorScreen() {
        let positionScreen = SelectWorkflowStatusMenu(workflowStatusSelectionDelegate: self)
        self.navigationController?.pushViewController(positionScreen, animated: true)

    }

    func deleteTask() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in print("called handler for Cancel action") }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {_ in
            guard let task = self.taskMO else { fatalError("taskMO was nil when executing \(#function)") }
            self.persistenceManager.delete(task: task)
            self.goBack()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    var selectedStatus: WorkflowPosition? {
        didSet {
            //print("didSet called on selectedEpic; the newValue is \(selectedEpic?.title)")
        }
        willSet {
            if newValue != selectedStatus {
                self.saveBarButton.isEnabled = true
            }
        }
    }
    var selectedEpic: Epic? {
        didSet {
            //print("didSet called on selectedEpic; the newValue is \(selectedEpic?.title)")
        }
        willSet {
            if newValue != selectedEpic {
                self.saveBarButton.isEnabled = true
            }
        }
    }

    var updateDelegate: CoreDataDisplayDelegate!
    var inputValidationManager: InputValidationManager!

    let persistenceManager: PersistenceManager

    private let useState: EditScreenUseState
    private var titleText: String { useState == .create ? "Create Task" : "Edit Task" }
    private var titlePlaceholderText: String = "add a title"
    private var taskMO: Task?
    var originalPosition: WorkflowPosition = WorkflowPosition.defaultStatus
    var finalPosition: WorkflowPosition = WorkflowPosition.defaultStatus
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

    lazy var table: TaskEditingTable = TaskEditingTable(useState: self.useState, editingDelegate: self, selectedEpic: self.selectedEpic, workflowStatus: self.selectedStatus)

    lazy var taskLog: LogView =  LogView(dateCreated: taskMO?.dateCreated, dateUpdated: taskMO?.dateUpdated)

    // MARK: instance methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground

        setupUIElements()
//        table.workFlowDisplayUpdate(self.finalPosition)
        setupDataStuff()
    }

    // MARK: InputsInterfaceDelegate conformance

    func enableUse(for: String) {
        self.saveBarButton.isEnabled = true
    }

    func disableUse(for: String) {
        self.saveBarButton.isEnabled = false
    }

    private func createTask(title: String, notes: String, epic: Epic?, status: WorkflowPosition?) {
        let task = Task(context: persistenceManager.context)
        task.title = title
        task.quickNote = notes
        task.epic = epic
        var date = Date()
        task.dateCreated = DateConversion.format(date)
        task.dateUpdated = DateConversion.format(date)
        task.workflowStatus =  Int64(status?.rawValue ?? WorkflowPosition.backlog.rawValue)
        persistenceManager.save()
    }

    private func saveChanges() {
        guard let task = taskMO else { fatalError("taskMO was nil when executing \(#function)") }
        let tempStatus = Int64(self.finalPosition.rawValue)
        print("called \(#function); about to save the workflow update of \(tempStatus)")
        task.title = titleTextField.text
        task.quickNote = notesTextView.text
        task.epic = selectedEpic
        var date = Date()
        task.dateUpdated = DateConversion.format(date)
        task.workflowStatus = tempStatus
        persistenceManager.save()
        self.updateDelegate.updateCoreData()
    }

    @objc func savedBarButtonTapped() {
//        print("useState=\(useState)")
        if useState == .create {
            createTask(title: self.titleTextField.text!, notes: self.notesTextView.text, epic: self.selectedEpic, status: self.selectedStatus)
        } else {
            saveChanges()
        }
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
        self.updateDelegate.updateCoreData()
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
//        self.table.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        self.table.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let newSize = table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        table.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true

        self.addChild(taskLog)
        taskLog.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview((taskLog.view)!)
        taskLog.view.topAnchor.constraint(equalTo: table.view.bottomAnchor, constant: 0.0).isActive = true
        taskLog.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        taskLog.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50.0).isActive = true
        taskLog.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true

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
        self.notesTextView.text = task.quickNote
        if let current = task.epic {
            self.selectedEpic = current
            table.selectedEpic = selectedEpic
        }
        if let pos = WorkflowPosition(rawValue: Int(task.workflowStatus)) {
            self.selectedStatus = pos
            table.selectedStatus = selectedStatus
        }
    }

    // MARK: initialization

    init(persistenceManager: PersistenceManager, useState: EditScreenUseState, task: Task? = nil, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.taskMO = task
        self.updateDelegate = updateDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
