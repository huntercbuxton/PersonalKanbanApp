//
//  ReadOnlyTaskDetailVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit

class ReadOnlyTaskDetailVC: UIViewController, CoreDataDisplayDelegate {

    // MARK: - CoeeDataDisplayDelegate conformance

    func updateCoreData() {
        self.loadData()
    }

    let persistenceManager: PersistenceManager!
    let task: Task!
    private let margins: CGFloat = 10.0
    lazy var titleText = task.title


    lazy var editBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))

    var scrollView: UIScrollView = UIScrollView()
    var contentView = UIView()

    lazy var titleTextField: PaddedTextField = PaddedTextField()

    lazy var notesTextView: LargeTextView = LargeTextView(text: self.task.quickNote)

    lazy var table: TaskDetailsTableVC = TaskDetailsTableVC(persistenceManager: self.persistenceManager, task: self.task)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        setupScrollAndContentView()
        setupContentComponents()
        self.loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    private func setupNavBar() {
        self.title = titleText
        self.navigationItem.setRightBarButton(editBarButton, animated: true)
    }

    private func setupScrollAndContentView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
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
    }


    private func setupContentComponents() {

        let widthConst: CGFloat = contentView.layoutMargins.right

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthConst).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthConst).isActive = true
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: self.margins).isActive = true

        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesTextView)
        notesTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthConst).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthConst).isActive = true
//        notesTextView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: 20).isActive = true

        addChild(table)
        table.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(table.view)
        table.view.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        table.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthConst).isActive = true
        table.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthConst).isActive = true
        let newSize = table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        table.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        table.view.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true

    }

    private func loadData() {
        print("called \(#function) on the read-only view!")
        self.titleTextField.text = task.title
        self.notesTextView.text = task.quickNote
        self.table.update(self.task)
    }

    @objc func editBarButtonTapped() {
        let vc = AddEditTaskVC(persistenceManager: persistenceManager, useState: .edit, task: task, updateDelegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    init(persistenceManager: PersistenceManager, task: Task, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
