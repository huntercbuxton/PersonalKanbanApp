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
    private lazy var tableVC1: EpicDetailScreenOneTopTableVC =  EpicDetailScreenOneTopTableVC(delegate: self)
    private lazy var taskListTableVC: EpicTasksList = EpicTasksList(persistenceManager: self.persistenceManager, selectionDelegate: self, epic: self.epic)

    // MARK: - misc instance properties
    
    let persistenceManager: PersistenceManager
    let epic: Epic!
    private var editorState: EditableState = .editDisabled
    var detailsCellTitle: String { self.editorState == EditableState.editDisabled ? "View Details" : "Edit Details" }
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    // MARK: - UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        setupScrollViewAndContentView()
        setupChildVCs()
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

    private func setupChildVCs() {

        self.addChild(self.tableVC1)
        tableVC1.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(tableVC1.view)
        tableVC1.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        tableVC1.view.constrainHEdgesAnchors(contentView)
        var newSize = tableVC1.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        tableVC1.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true

        self.addChild(taskListTableVC)
        taskListTableVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskListTableVC.view)
        taskListTableVC.view.topAnchor.constraint(equalTo: tableVC1.view.bottomAnchor, constant: UIConsts.verticalSpacing).isActive = true
        taskListTableVC.view.constrainHEdgesAnchors(contentView)
        taskListTableVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        newSize = taskListTableVC.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        taskListTableVC.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
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
        self.epic = epic
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
