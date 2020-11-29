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

public protocol TaskEditorOptionsTable2Delegate: AnyObject {
    func deleteTask()
    func archiveTask()
    func unArchiveTask()
}


class AddEditTaskVC: UIViewController, TaskEditorOptionsTable2Delegate, ManagedInputsStateDelegate {

    // MARK: - TaskEditorOptionsTable2Delegate conformance

    func deleteTask() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in print("called handler for Cancel action") }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {_ in
            guard let task = self.task else { fatalError("taskMO was nil when executing \(#function)") }
            self.persistenceManager.delete(task: task)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func archiveTask() {
        self.inputStateManager.isArchivedUpdate = true
    }
    func unArchiveTask() {
        self.inputStateManager.isArchivedUpdate = false
    }

    // MARK: - InputStateManagerDelegate conformance

    func updateState(_ state: InputState) {
        saveBtn.isEnabled = state == .valid
        if state == .valid {
            self.task?.title = headerInputs.titleInput.text!
            self.task?.stickyNote = headerInputs.stickyNoteInput.text!
        }
    }

    func update(position: WorkflowPosition?, at: Inputs)  {
        workflowOptionsTable.workflowPosition = position
    }

    func update(epic: Epic?, at: Inputs) {
        workflowOptionsTable.epic = epic
    }

    func update(storyPoints: StoryPoints, at: Inputs) {
        workflowOptionsTable.storyPoints = storyPoints
    }


    // MARK: - properties storing UI Components

    private lazy var saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnTapped))
    private lazy var cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTapped))
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private var headerInputs: TitleAndStickyNote!
    private lazy var workflowOptionsTable: TaskDetailsTableVC = TaskDetailsTableVC(coreDataDAO: persistenceManager, task: task, isReadOnly: false)
    private lazy var deleteEtcActionsTable = TaskEditorOptionsTable2(delegate: self)

    // MARK: - other properties

    let defaultFolder: TaskFolder!
    var selectedToArchive: Bool = false
    lazy var inputStateManager: InputStateManager = InputStateManager(persistence: persistenceManager, task: task, stateDelegate: self, defaultFolder: nil)
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins
    private let persistenceManager: PersistenceManager
    private var task: Task?
    private let useState: CreateOrEdit

    // MARK: - initial setup of UI components

    override func viewDidLoad() {
        super.viewDidLoad()

        // used in the first UITest file
        view.accessibilityIdentifier = "taskEditorVCID"
        saveBtn.accessibilityIdentifier = "saveBtn"
        cancelBtn.accessibilityIdentifier = "cancelBtn"

        self.view.backgroundColor = .systemGroupedBackground
        if useState  == .create {
            self.title = "create a task"
            self.navigationItem.setLeftBarButton(cancelBtn, animated: false)
            self.navigationItem.setRightBarButton(saveBtn, animated: false)
            saveBtn.isEnabled = false
        }

        scrollView.layoutWithGuide(in: view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: scrollView, insets: margins)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -(margins.right*2)).isActive = true

        headerInputs = TitleAndStickyNote(task: task, titleObserver: self.inputStateManager)
        self.addChild(headerInputs)
        headerInputs.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerInputs.view)
        headerInputs.view.translatesAutoresizingMaskIntoConstraints = false
        headerInputs.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerInputs.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headerInputs.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        workflowOptionsTable.modelManager = self.inputStateManager
        workflowOptionsTable.workflowPosition = inputStateManager.folderUpdate.status
        self.addChild(workflowOptionsTable)
        workflowOptionsTable.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(workflowOptionsTable.view)
        workflowOptionsTable.view.constrainHEdgesAnchors(contentView, constant: margins.right)
        let newSize = workflowOptionsTable.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        workflowOptionsTable.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        workflowOptionsTable.view.topAnchor.constraint(equalTo: headerInputs.view.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true

        if useState == .edit {
            deleteEtcActionsTable.isArchived = inputStateManager.isArchivedUpdate
            self.addChild(deleteEtcActionsTable)
            deleteEtcActionsTable.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(deleteEtcActionsTable.view)
            deleteEtcActionsTable.view.constrainHEdgesAnchors(contentView, constant: margins.right)
            let newSize = deleteEtcActionsTable.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
            deleteEtcActionsTable.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
            deleteEtcActionsTable.view.topAnchor.constraint(equalTo: workflowOptionsTable.view.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
            deleteEtcActionsTable.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom).isActive = true
        } else {
            workflowOptionsTable.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom).isActive = true
        }
    }

    // MARK: - other methods

    @objc func saveBtnTapped() {
        if useState == .create {
            self.task = Task(title: headerInputs.titleInput.text!, stickyNote: headerInputs.stickyNoteInput.text!, storypoints: inputStateManager.storyPoints, folder: inputStateManager.folderUpdate)
        }
        //persistenceManager.save()
        navigateToPreviousScreen()
    }

    @objc func cancelBtnTapped() {
        navigateToPreviousScreen()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("&&&&&&&&&&&&& called \(#function)")
        if self.task != nil {
            print("4444433333333333 task != nil ")
            saveChanges()
        }
    }

    private func navigateToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
       // updateDelegate.updateCoreData()
    }

    private func saveChanges() {
        guard let task = task else { fatalError("taskMO was nil when executing \(#function)") }
        task.title = self.headerInputs.titleInput.text!
        task.stickyNote = self.headerInputs.stickyNoteInput.text
        task.epic = workflowOptionsTable.epic
        print(" RIGHT WEJEN CALLING \(#function) the storyPoints value was \(inputStateManager.storyPoints)")
        task.storyPointsEnum = inputStateManager.storyPoints
        task.computedFolder = inputStateManager.folderUpdate
        task.dateUpdated = DateConversion.format(Date())
        persistenceManager.save()
    }

//     MARK: - initialization

    // used when creating  anew task for a given epic
    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, updateDelegate: CoreDataDisplayDelegate, selectedEpic: Epic? = nil) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.defaultFolder = TaskFolder()
        super.init(nibName: nil, bundle: nil)
        self.workflowOptionsTable.epic = selectedEpic

    }

    // used when editing an existing task
    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, task: Task, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.task = task
        self.defaultFolder = task.computedFolder
        super.init(nibName: nil, bundle: nil)
    }

    // used when creating a new task
    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, updateDelegate: CoreDataDisplayDelegate, defaultFolder: TaskFolder = TaskFolder()) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.defaultFolder = defaultFolder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
