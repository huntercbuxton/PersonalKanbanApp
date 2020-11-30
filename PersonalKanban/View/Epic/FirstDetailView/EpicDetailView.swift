//
//  EpicTasksTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

enum EditableState {
    case editEnabled, editDisabled
}

class EpicDetailView: UIViewController, ManagedInputsStateDelegate {

    // MARK: - InputStateManagerDelegate

    func updateState(_ state: InputState) {
        saveBtn.isEnabled = state == .valid
    }

    // MARK: - properties storing UI Components

    private lazy var saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnTapped))
    private lazy var cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTapped))
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
//    var titleAndStickyNote: TitleAndStickyNote!
    private lazy var taskTableLabel = UILabel()
    private lazy var taskListTableVC: EpicTasksList = EpicTasksList(persistenceManager: self.persistenceManager, epic: self.epic)

    // MARK: - misc instance properties

    var heightConstraint: NSLayoutConstraint?
    private let useState: CreateOrEdit
    let persistenceManager: PersistenceManager
    let epic: Epic!
//    lazy var inputValidation: EpicInputValidationManager = EpicInputValidationManager(delegate: self)
    private let taskTableLabelText = "Tasks:"
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    // MARK: - UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        if useState  == .create {
            self.title = "create an epic"
            self.navigationItem.setLeftBarButton(cancelBtn, animated: false)
        }
        self.navigationItem.setRightBarButton(saveBtn, animated: false)
        saveBtn.isEnabled = false

        scrollView.layoutWithGuide(in: view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: scrollView, insets: margins)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -(margins.left + margins.right)).isActive = true

//        titleAndStickyNote = TitleAndStickyNote(epic: epic, titleObserver: self.inputValidation)
//        self.addChild(titleAndStickyNote)
//        titleAndStickyNote.view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(titleAndStickyNote.view)
//        titleAndStickyNote.view.translatesAutoresizingMaskIntoConstraints = false
//        titleAndStickyNote.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        titleAndStickyNote.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        titleAndStickyNote.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        taskTableLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskTableLabel)
        taskTableLabel.text = taskTableLabelText
        taskTableLabel.textAlignment = .center
        taskTableLabel.font = UIConsts.sectionLabelFont
//        taskTableLabel.topAnchor.constraint(equalTo: titleAndStickyNote.view.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        taskTableLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        taskTableLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        taskTableLabel.heightAnchor.constraint(equalToConstant: SavedLayouts.sectionLabelHeight).isActive = true

        self.addChild(taskListTableVC)
        taskListTableVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskListTableVC.view)
        taskListTableVC.view.topAnchor.constraint(equalTo: taskTableLabel.bottomAnchor, constant: SavedLayouts.shortVerticalSpacing).isActive = true
        taskListTableVC.view.constrainHEdgesAnchors(contentView)

        taskListTableVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SavedLayouts.shortVerticalSpacing).isActive = true
        let newSize1 = taskListTableVC.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))

        self.heightConstraint = self.taskListTableVC.view.heightAnchor.constraint(equalToConstant: newSize1.height)
        heightConstraint?.isActive = true
    }

    // this is what updates the displayed tasks of the epics if they've been deleted since last time we saw this table
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskListTableVC.reloadDisplay()
        adjustHeightConstraint()
    }

    // MARK: - misc instance methods

    @objc func saveBtnTapped() {
        if useState == .create {
//            createEpic(title: self.titleAndStickyNote.titleInput.text!, notes: titleAndStickyNote.stickyNoteInput.text)
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
//        updateDelegate.updateCoreData()
    }

    private func createEpic(title: String, notes: String) {
        let epic = Epic(context: persistenceManager.context)
        epic.title = title
        epic.quickNote = notes
        persistenceManager.save()
    }

    private func saveChanges() {
        guard let epic = epic else { fatalError("epic was nil when executing \(#function)") }
//        epic.title = titleAndStickyNote.titleInput.text!
//        epic.quickNote = titleAndStickyNote.stickyNoteInput.text
        persistenceManager.save()
//        self.updateDelegate.updateCoreData()
    }

    private func adjustHeightConstraint() {
        let newSize1 = taskListTableVC.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        self.heightConstraint?.constant = newSize1.height
        self.taskListTableVC.view.layoutIfNeeded()
    }

    // MARK: - initialization

    init(persistenceManager: PersistenceManager, epic: Epic, useState: CreateOrEdit) {
        self.persistenceManager = persistenceManager
        self.epic = epic
        self.useState = useState
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
