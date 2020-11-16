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

class AddEditTaskVC: UIViewController, TaskEditorOptionsTable2Delegate, InputStateManagerDelegate {

    // MARK: - InputStateManagerDelegate conformance

    func updateState(_ state: InputState) {
        saveBtn.isEnabled = state == .valid
    }


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

    let defaultStatus: WorkflowPosition!
    var selectedToArchive: Bool = false

    func archiveTask() {
        self.propertiesTable.workflowPosition = nil
        selectedToArchive = true
    }

    func unArchiveTask() {
        self.propertiesTable.workflowPosition = task?.workflowStatusEnum ?? self.defaultStatus
        selectedToArchive = false
    }

    // MARK: - properties storing UI Components

    private lazy var saveBtn = UIBarButtonItem(barButtonSystemItem: .save,
                                                              target: self,
                                                              action: #selector(saveBtnTapped))
    private lazy var cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(cancelBtnTapped))
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    var titleAndStickyNote: TitleAndStickyNote!
    private lazy var propertiesTable: TaskDetailsTableVC = TaskDetailsTableVC(coreDataDAO: persistenceManager, task: task, isReadOnly: false)
    private lazy var table2 = TaskEditorOptionsTable2(delegate: self)
    private var taskLog: LogView?

    // MARK: - properties specifying UI style/layout

    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    // MARK: - other properties

    private let useState: CreateOrEdit
    private weak var updateDelegate: CoreDataDisplayDelegate!
    lazy var inputStateManager: InputStateManager = InputStateManager(delegate: self)
    private let persistenceManager: PersistenceManager
    private var task: Task?

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
        }
        self.navigationItem.setRightBarButton(saveBtn, animated: false)
        saveBtn.isEnabled = false

        scrollView.layoutWithGuide(in: view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: scrollView, insets: margins)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -(margins.right*2)).isActive = true

        titleAndStickyNote = TitleAndStickyNote(task: task, titleObserver: self.inputStateManager)
        self.addChild(titleAndStickyNote)
        titleAndStickyNote.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleAndStickyNote.view)
        titleAndStickyNote.view.translatesAutoresizingMaskIntoConstraints = false
        titleAndStickyNote.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleAndStickyNote.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleAndStickyNote.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        self.addChild(propertiesTable)
        propertiesTable.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(propertiesTable.view)
        propertiesTable.view.constrainHEdgesAnchors(contentView, constant: margins.right)
        let newSize = propertiesTable.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        propertiesTable.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        propertiesTable.view.topAnchor.constraint(equalTo: titleAndStickyNote.view.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true

        if useState == .edit {
            self.addChild(table2)
            table2.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(table2.view)
            table2.view.constrainHEdgesAnchors(contentView, constant: margins.right)
            let newSize = table2.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
            table2.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
            table2.view.topAnchor.constraint(equalTo: propertiesTable.view.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
            table2.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom).isActive = true
        } else {
            propertiesTable.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom).isActive = true
        }
    }

    // MARK: - other methods

    @objc func saveBtnTapped() {
        if useState == .create {
            self.task = Task(titleAndStickyNote.titleInput.text!, stickyNote: titleAndStickyNote.stickyNoteInput.text!, folder: TaskFolder.statusDic[self.propertiesTable.workflowPosition!]!)
        } else {
            saveChanges()
        }
        persistenceManager.save()
        self.updateDelegate.updateCoreData()
        navigateToPreviousScreen()
    }

    @objc func cancelBtnTapped() {
        navigateToPreviousScreen()
    }

    private func navigateToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
        updateDelegate.updateCoreData()
    }

    private func saveChanges() {
        guard let task = task else { fatalError("taskMO was nil when executing \(#function)") }
        task.title = self.titleAndStickyNote.titleInput.text!
        task.stickyNote = self.titleAndStickyNote.stickyNoteInput.text
        task.epic = propertiesTable.selectedEpic
        task.storyPointsEnum = propertiesTable.storyPoints
        if selectedToArchive {
            task.isArchived = true
        } else {
            task.workflowStatusEnum = propertiesTable.workflowPosition ?? self.defaultStatus
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
    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, task: Task? = nil, updateDelegate: CoreDataDisplayDelegate, selectedEpic: Epic? = nil) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.task = task
        self.defaultStatus = task?.workflowStatusEnum ?? .inProgress
        self.updateDelegate = updateDelegate
        super.init(nibName: nil, bundle: nil)
        self.propertiesTable.selectedEpic = selectedEpic
    }

    // used when editing an existing task
    init(persistenceManager: PersistenceManager, useState: CreateOrEdit, task: Task? = nil, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.useState = useState
        self.task = task
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
        self.propertiesTable.workflowPosition = self.defaultStatus
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
