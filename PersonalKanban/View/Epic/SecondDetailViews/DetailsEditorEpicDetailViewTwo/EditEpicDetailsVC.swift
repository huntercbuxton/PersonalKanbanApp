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

class EditEpicDetailsVC: UIViewController, EpicDetailsMenuDelegate {

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
    lazy var table: EpicDetailsEditorMenuVC = EpicDetailsEditorMenuVC(persistenceManager: self.persistenceManager, epic: self.epic, selectionDelegate: self)
    private lazy var margins: UIEdgeInsets = contentView.layoutMargins

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        setupNavBar()
        scrollView.layoutWithGuide(in: view)
        contentView.layoutAsContentView(for: scrollView)
        setupInputFields()
        setupDataStuff()
    }

    private func setupNavBar() {
        self.title = titleText
        self.navigationItem.setLeftBarButton(cancelBtn, animated: false)
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
    }

    private func setupInputFields() {

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  margins.right).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -margins.right).isActive = true
        titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        titleTextField.placeholder = titlePlaceholderText

        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesTextView)
        notesTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: sectionSpacing).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  margins.right).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -margins.right).isActive = true

        self.addChild(table)
        self.table.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(table.view)
        self.table.view.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: sectionSpacing).isActive = true
        table.view.constrainHEdgesAnchors(contentView, constant: margins.right)
        table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let newSize = table.view.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        table.view.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true

        self.table.view.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -SavedLayouts.shortVerticalSpacing).isActive = true
    }

    private func setupDataStuff() {
        self.inputValidationManager = InputValidationManager()
//        self.inputValidationManager.delegate = self
//        self.titleTextField.inputValidationDelegate = self.inputValidationManager
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
