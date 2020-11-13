//
//  ViewOnlyEpicDetailVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class ViewOnlyEpicDetailVC: UIViewController, CoreDataDisplayDelegate {

    // MARK: - CoeeDataDisplayDelegate conformance

    func updateCoreData() {
        self.loadData()
    }

    private let titleText = "Details"
    let persistenceManager: PersistenceManager!
    let epic: Epic!
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    lazy var editBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))

    var scrollView: UIScrollView = UIScrollView()
    var contentView = UIView()

    lazy var titleTextField: PaddedTextField = PaddedTextField()

    lazy var notesTextView: LargeTextView = LargeTextView(text: self.epic.quickNote)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        setupScrollAndContentView()
        setupContentComponents()
        self.loadData()
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
        notesTextView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true


    }

    private func loadData() {
        self.titleTextField.text = epic.title
        self.notesTextView.text = epic.quickNote
    }

    @objc func editBarButtonTapped() {
        self.navigationController?.pushViewController(EditEpicDetailsVC(persistenceManager: persistenceManager, epic: epic, displayDelegate: self), animated: true)
    }

    init(persistenceManager: PersistenceManager, epic: Epic, updateDelegate: CoreDataDisplayDelegate) {
        self.persistenceManager = persistenceManager
        self.epic = epic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
