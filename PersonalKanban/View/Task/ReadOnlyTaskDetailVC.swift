//
//  ReadOnlyTaskDetailVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit

protocol ArchiveChangeDisplayDelegate: AnyObject {
    func changedArchivePropertyTo(_ isArchived: Bool)
}

class ReadOnlyTaskDetailVC: UIViewController, CoreDataDisplayDelegate, ArchiveChangeDisplayDelegate {

    // MARK: - ArchiveChangeDelegate conformance

    func changedArchivePropertyTo(_ isArchived: Bool) {
        if isArchived == false {
            removeArchiveLabel()
        } else {
            reAddArchiveLabel()
        }
    }

    // MARK: - CoeeDataDisplayDelegate conformance

    func updateCoreData() {
        self.loadData()
    }

    let persistenceManager: PersistenceManager!
    let task: Task!
    let defaultWPosition: WorkflowPosition!
    lazy var titleText = task.title


    lazy var editBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))

    var scrollView: UIScrollView = UIScrollView()
    var contentView = UIView()

    lazy var titleTextField: PaddedTextField = PaddedTextField()

    lazy var notesTextView: LargeTextView = LargeTextView(text: self.task.quickNote)

    lazy var table: TaskDetailsTableVC = TaskDetailsTableVC(coreDataDAO: self.persistenceManager, task: self.task, isReadOnly: true)

    lazy var archiveLabel: UILabel = UILabel()
    var tableBottomAnchor: NSLayoutConstraint?
    var archiveLabelConstraints: [NSLayoutConstraint] = []
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        setupScrollAndContentView()
        setupContentComponents()
        setupTable()

        if self.task.isArchived {
            self.setupArchiveLabel()
        } else {
            tableBottomAnchor = table.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: SavedLayouts.verticalSpacing)
            NSLayoutConstraint.activate([tableBottomAnchor!])
        }
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    private func removeArchiveLabel() {
        archiveLabel.removeFromSuperview()
        NSLayoutConstraint.deactivate(archiveLabelConstraints)
        if tableBottomAnchor == nil {
            tableBottomAnchor = table.view.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor)
        }
        tableBottomAnchor!.isActive = true
    }

    private func setupNavBar() {
        self.title = titleText
        self.navigationItem.setRightBarButton(editBarButton, animated: true)
    }

    private func setupScrollAndContentView() {
        scrollView.layoutWithGuide(in: view)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: scrollView, insets: margins)
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -(margins.right*2)).isActive = true
    }


    private func setupContentComponents() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margins.right).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margins.right).isActive = true
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SavedLayouts.verticalSpacing).isActive = true

        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesTextView)
        notesTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margins.right).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margins.right).isActive = true

    }

    private func setupTable() {
        self.addChild(table)
        table.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(table.view)
        table.view.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        table.view.constrainHEdgesAnchors(contentView, constant: margins.right)
        let newSize = table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        table.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
    }

    private func setupArchiveLabel() {
        archiveLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(archiveLabel)
        let topConstraint = archiveLabel.topAnchor.constraint(equalTo: table.view.bottomAnchor, constant: SavedLayouts.verticalSpacing)
        archiveLabelConstraints.append(topConstraint)
        let trailingConstraint = archiveLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margins.right)
        archiveLabelConstraints.append(trailingConstraint)
        let bottomConstraint = archiveLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        archiveLabelConstraints.append(bottomConstraint)
        let leadingConstraint = archiveLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margins.right)
        archiveLabelConstraints.append(leadingConstraint)
        let heightConstraint = archiveLabel.heightAnchor.constraint(equalToConstant: 70.0)
        archiveLabelConstraints.append(heightConstraint)
        NSLayoutConstraint.activate(archiveLabelConstraints)
        archiveLabel.text = "this task has been archived"
        archiveLabel.textAlignment = .center
        archiveLabel.textColor = .systemRed
        archiveLabel.backgroundColor = .systemBackground
    }

    private func reAddArchiveLabel() {
        tableBottomAnchor?.isActive = false
        NSLayoutConstraint.deactivate(archiveLabelConstraints)
        archiveLabelConstraints = []
        setupArchiveLabel()
    }

    private func loadData() {
        self.titleTextField.text = task.title
        self.notesTextView.text = task.quickNote
//        self.table.update(self.task)
        table.task = task
    }

    @objc func editBarButtonTapped() {
        let vc = AddEditTaskVC(persistenceManager: persistenceManager, useState: .edit, task: task, updateDelegate: self)
        vc.archiveChangeDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    init(persistenceManager: PersistenceManager, task: Task, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.task = task
        self.defaultWPosition = task.workflowStatusEnum
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
