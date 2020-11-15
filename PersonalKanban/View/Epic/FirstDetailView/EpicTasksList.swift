//
//  EpicTasksList.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/10/20.
//

import UIKit

protocol EpicTasksListSelectionDelegate: AnyObject {
    func select(task: Task)
}

protocol EditorStateControllable {
    func updateEditorState(_ newState: EditableState)
}

class EpicTasksList: UITableViewController, EditorStateControllable {

    // MARK: - EditorStateControllable conformance

    func updateEditorState(_ newState: EditableState) {
        let isEditing = newState == .editEnabled
        self.setEditing(isEditing, animated: true)
    }

    private let persistenceManager: PersistenceManager!
    private let cellReuseID = "EpicTasksList.cellReuseID"
    private let epic: Epic!
    private lazy var taskLists: [[Task]] = []
    private var editorState: EditableState = .editDisabled

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isScrollEnabled = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        taskLists = persistenceManager.sortEpicTasks(for: epic)
        self.tableView.tableFooterView = UIView(background: .systemGroupedBackground)
        view.backgroundColor = .systemGroupedBackground
        self.view.clipsToBounds = true
    }

    private func loadData() {
        taskLists = persistenceManager.sortEpicTasks(for: epic)
//        self.view.backgroundColor = UIConsts.defaultBackgroundColor
    }

    func reloadDisplay() {
        taskLists = persistenceManager.sortEpicTasks(for: epic)
        print("called reloadDisplay()")
        print("taskList contains the following sized arrays:")
        taskLists.forEach({print($0.count)})
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskLists.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = taskLists[indexPath.section][indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = taskLists[indexPath.section][indexPath.row]
            persistenceManager.delete(task: toDelete)
            self.taskLists[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return mkSectionHeaderViewWith(titleIfEmpty: "You have no backlog tasks for this epic", titleIfNotEmpty: "backlog tasks", for: section)
        case 1:
            return mkSectionHeaderViewWith(titleIfEmpty: "You have no 'to-do' tasks for this epic", titleIfNotEmpty: "to-do tasks", for: section)
        case 2:
            return mkSectionHeaderViewWith(titleIfEmpty: "you have no 'in-progress' tasks for this epic", titleIfNotEmpty: "tasks in-progress", for: section)
        case 3:
            return mkSectionHeaderViewWith(titleIfEmpty: "you have no finished tasks for this epic", titleIfNotEmpty: "finished tasks", for: section)
        default:
            return mkSectionHeaderViewWith(titleIfEmpty: "   ", titleIfNotEmpty: "   ", for: section)
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(background: .systemGroupedBackground)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SavedLayouts.defaultTableHeaderHeight
    }

    private func mkSectionHeaderViewWith(titleIfEmpty: String, titleIfNotEmpty: String, for section: Int) -> UILabel {
        let labelText = taskLists[section].isEmpty ? titleIfEmpty : titleIfNotEmpty
        return UILabel(text: labelText)
    }

    // MARK: - initialization

    init(persistenceManager: PersistenceManager,epic: Epic) {
        self.persistenceManager = persistenceManager
        self.epic = epic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}