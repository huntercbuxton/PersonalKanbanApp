//
//  EditEpicDetailsVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

enum EditCompletionStatus {
    case noChange
    case propertyChanges
    case deleted
}

protocol EpicDetailsMenuDelegate: AnyObject {
    func deleteEpic()
    func deleteTasks()
    func unassignTasks()
}

class EditEpicDetailsVC: UIViewController, EpicDetailsMenuDelegate, InputsInterfaceDelegate {

    // MARK: - InputsInterfaceDelegate conformance

    func enableSave() {
        self.saveBtn.isEnabled = true
    }

    func disableSave() {
        self.saveBtn.isEnabled = false
    }

    // MARK: EpicDetailsMenuDelegate conformance

    func deleteEpic() {
        persistenceManager.delete(epic: self.epic)
        self.editStatus = .deleted
    }

    func deleteTasks() {}
    func unassignTasks() {}

    private var editStatus: EditCompletionStatus = .noChange
    private var titleText = "Edit Details"
    private var titlePlaceholderText: String = "add a title"
    private let sectionSpacing: CGFloat = 20.0

    weak var displayDelegate: CoreDataDisplayDelegate!

    let persistenceManager: PersistenceManager!
    private var inputValidationManager: InputValidationManager!
    let epic: Epic!

    lazy var saveBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnTapped))
    lazy var cancelBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTapped))
    var scrollView: UIScrollView = UIScrollView()
    var contentView = UIView()
    lazy var titleTextField: PaddedTextField = PaddedTextField()
    lazy var notesTextView: LargeTextView = LargeTextView(text: self.epic.quickNote ?? "")
    lazy var table: EpicDetailsEditorMenuVC = EpicDetailsEditorMenuVC(selectionDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        self.title = titleText
        self.navigationItem.setLeftBarButton(cancelBtn, animated: false)
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
        setupScrollView()
        setupContentView()
        setupInputFields()
        setupDataStuff()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupContentView() {
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

    private func setupInputFields() {
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
        self.table.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        self.table.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let newSize = table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        table.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
    }

    private func setupDataStuff() {
        self.inputValidationManager = InputValidationManager()
        self.inputValidationManager.delegate = self
        self.titleTextField.inputValidationDelegate = self.inputValidationManager
        prefillInputFields()
    }

    private func prefillInputFields() {
        titleTextField.text = self.epic.title
        notesTextView.text = epic.quickNote
    }

    @objc func saveBtnTapped() {
        saveChanges()
        goBack()
    }

    func saveChanges() {
        self.epic.title = self.titleTextField.text
        self.epic.quickNote = self.notesTextView.text
        persistenceManager.save()
    }

    @objc func cancelBtnTapped() {
        self.editStatus = .noChange
        goBack()
    }

    private func goBack() {
        self.displayDelegate.updateCoreData()
        self.navigationController?.popViewController(animated: true)
        if self.editStatus == .deleted {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func layoutUIElements() {

    }

    init(persistenceManager: PersistenceManager, epic: Epic, displayDelegate: CoreDataDisplayDelegate) {
        self.epic = epic
        self.persistenceManager = persistenceManager
        self.displayDelegate = displayDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
