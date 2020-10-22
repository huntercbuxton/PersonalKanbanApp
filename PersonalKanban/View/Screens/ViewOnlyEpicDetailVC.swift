//
//  ViewOnlyEpicDetailVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class ViewOnlyEpicDetailVC: UIViewController, CoreDataDisplayDelegate {

    private let titleText = "Epic Details"
    let persistenceManager: PersistenceManager!
    let epic: Epic!
    private let sectionSpacing: CGFloat = 20.0
    private let margins: CGFloat = 10.0

    lazy var editBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))

    var scrollView: UIScrollView = UIScrollView()
    var contentView = UIView()

    lazy var titleTextField: PaddedTextField = PaddedTextField()

    lazy var notesTextView: LargeTextView = LargeTextView(text: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.title = titleText
        self.navigationItem.setRightBarButton(editBarButton, animated: true)
        self.setupUIElements()
        self.loadData()
    }

    private func setupUIElements() {

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
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: self.margins).isActive = true
        titleTextField.layer.borderWidth = 2.5
        titleTextField.layer.borderColor = UIColor.systemGray5.cgColor
        titleTextField.layer.cornerRadius = 8

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
        notesTextView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: 20.0).isActive = true

    }

    private func loadData() {
        self.titleTextField.text = epic.title
        self.notesTextView.text = epic.quickNote
    }

    @objc func editBarButtonTapped() {
        self.navigationController?.pushViewController(EditEpicDetailsVC(persistenceManager: persistenceManager, epic: epic, displayDelegate: self), animated: true)
    }

    init(persistenceManager: PersistenceManager, epic: Epic, updateDelegate: CoreDataDisplayDelegate) {
        self.epic = epic
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
