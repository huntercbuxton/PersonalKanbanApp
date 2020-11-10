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

class EpicDetailViewFirstScreen: UIViewController, EpicViewDetailsOptionTableDelegate, EpicTasksListSelectionDelegate, CoreDataDisplayDelegate {

    // MARK: - EpicViewDetailsOptionTableDelegate conformance

    func goToDetailsScreen() {
        if editorState == .editDisabled {
            let detailsView = ViewOnlyEpicDetailVC(persistenceManager: persistenceManager, epic: self.epic, updateDelegate: self)
            self.navigationController?.pushViewController(detailsView, animated: true)
        } else {
            let detailsView = EditEpicDetailsVC(persistenceManager: persistenceManager, epic: self.epic, displayDelegate: self)
            self.navigationController?.pushViewController(detailsView, animated: true)
        }
    }

    // MARK: - EpicTasksListSelectionDelegate conformance

    func select(task: Task) {
//        print("called \(#function) in EpicDetailViewFirstScreen with argument of task with title \(task.title)")
//        self.navigationController?.pushViewController()
    }

    // MARK: - properties storing UI Components

    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var editBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))
    private lazy var doneEditingBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditingBarButtonTapped))
//    private lazy var detailsButtonTableVC: EpicViewDetailsTableVC = EpicViewDetailsTableVC(delegate: self)
    weak var epicsTable: EpicsTableVC!
    private lazy var tableVC1: EpicDetailScreenOneTopTableVC =  EpicDetailScreenOneTopTableVC(delegate: self)
    private lazy var taskTableLabel = UILabel()
    private lazy var taskListTableVC: EpicTasksList = EpicTasksList(persistenceManager: self.persistenceManager, selectionDelegate: self, epic: self.epic)

    // MARK: - misc instance properties
    
    let persistenceManager: PersistenceManager
    let epic: Epic!
    private var editorState: EditableState = .editDisabled
    private var detailsCellTitle: String { self.editorState == EditableState.editDisabled ? "View Details" : "Edit Details" }
    private let taskTableLabelText = "Tasks Lists"
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    // MARK: - UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavItems()
        setupScrollViewAndContentView()
        setupContentComponents()
    }

    // this is what updates the displayed tasks of the epics if they've been deleted since last time we saw this table
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskListTableVC.reloadDisplay()
    }
    

    private func setupNavItems() {
        title = self.epic.title
        self.navigationItem.setRightBarButton(self.editBarButton, animated: true)
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

    private func setupContentComponents() {

        self.addChild(self.tableVC1)
        tableVC1.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(tableVC1.view)
        tableVC1.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableVC1.view.constrainHEdgesAnchors(contentView)
        var newSize = tableVC1.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        tableVC1.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true

        taskTableLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskTableLabel)
        taskTableLabel.text = taskTableLabelText
        taskTableLabel.textAlignment = .center
        taskTableLabel.font = UIConsts.sectionLabelFont
        taskTableLabel.topAnchor.constraint(equalTo: tableVC1.view.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        taskTableLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        taskTableLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        taskTableLabel.heightAnchor.constraint(equalToConstant: SavedLayouts.sectionLabelHeight).isActive = true

        self.addChild(taskListTableVC)
        taskListTableVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskListTableVC.view)
        taskListTableVC.view.topAnchor.constraint(equalTo: taskTableLabel.bottomAnchor, constant: SavedLayouts.shortVerticalSpacing).isActive = true
        taskListTableVC.view.constrainHEdgesAnchors(contentView)
        var newSize1 = taskListTableVC.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        taskListTableVC.view.heightAnchor.constraint(equalToConstant: newSize1.height).isActive = true

        taskListTableVC.view.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -SavedLayouts.shortVerticalSpacing).isActive = true
    }

    // MARK: - misc instance methods

    @objc func editBarButtonTapped() {
        self.editorState = .editEnabled
        self.tableVC1.updateEditorState(self.editorState)
        self.taskListTableVC.updateEditorState(self.editorState)
        self.navigationItem.setRightBarButton(self.doneEditingBarButton, animated: true)
    }

    @objc func doneEditingBarButtonTapped() {
        self.editorState = .editDisabled
        self.tableVC1.updateEditorState(self.editorState)
        self.taskListTableVC.updateEditorState(self.editorState)
        self.navigationItem.setRightBarButton(self.editBarButton, animated: true)
    }

    // MARK: - initialization

    init(persistenceManager: PersistenceManager, epic: Epic) {
        self.persistenceManager = persistenceManager
        self.epic = epic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
