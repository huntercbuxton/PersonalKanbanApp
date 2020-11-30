//
//  EpicDetailsEditorMenuVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

protocol EpicDetailsMenuDelegate: AnyObject {
    func updateTasks()
}

class EpicDetailsEditorMenuVC: UITableViewController, UnassignedTasksSelectionDelegate, CoreDataDisplayDelegate, EpicTaskListDisplayDelegate {

    // MARK: - EpicTaskListDisplayDelegate conformance

    func displayAddedTask(task: Task) {
        epic.addToTasks(task)
        persistenceManager.save()
        self.selectionDelegate.updateTasks()
    }

    // MARK: - CoreDataDisplayDelegate conformance

    func updateCoreData() {
        print("called \(#function) but no action has been implemented here yet")
    }

    // MARK: - UnassignedTasksSelectionDelegate conformance

    func select(_ tasks: [Task]) {
        tasks.forEach({self.epic.addToTasks($0)})
        persistenceManager.save()
        self.selectionDelegate.updateTasks()
    }

    private let persistenceManager: PersistenceManager
    private let cellReuseID = "EpicDetailsEditorMenuVC.cellReuseID"
    private var epic: Epic!
    weak var selectionDelegate: EpicDetailsMenuDelegate!
    let options = [ ["add existing tasks",
                     "add new task"
                    ],
                    [
                        "unassign tasks",
                        "delete all tasks",
                    "delete epic"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        self.tableView.tableFooterView = UIView(background: .systemGroupedBackground)
        view.backgroundColor = .systemGroupedBackground
        tableView.isScrollEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = options[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(UnassignedTasksSelectionTableVC(persistenceManager: self.persistenceManager, selectionDelegate: self, epic: self.epic), animated: true)
            case 1:
                let vc = AddEditTaskVC(persistenceManager: persistenceManager, updateDelegate: self, selectedEpic: self.epic, displayAddedTaskDelegate: self)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                assertionFailure("\(#function) argument was an invalid/unexpected index path with value \(String(describing: indexPath))")
            }
        default:
            switch indexPath.row {
            case 0:
                let alert = UIAlertController(title: "unassign all tasks from this epic", message: "do you want to continue? This action cannot be undone", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Unassign Tasks", style: .destructive, handler: {
                    _ in
                    let tasks = self.epic.tasksList
                    tasks.forEach({$0.epic = nil})
                    self.persistenceManager.save()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            case 1:
                let alert =  UIAlertController(title: "You are about to delete all tasks in this epic", message: "are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete Tasks", style: .destructive, handler: {
                    _ in
                    let tasks = self.epic.tasksList
                    tasks.forEach({self.persistenceManager.delete(task: $0)})
                }))
                present(alert, animated: true, completion: nil)
            case 2:
                let alert =  UIAlertController(title: "Delete Epic", message: "this will also delete all the tasks in the epic. Do you want to continue", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete Epic", style: .destructive, handler: {
                    _ in
                    self.persistenceManager.delete(epic: self.epic)
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil)
            default:
                assertionFailure("\(#function) argument was an invalid/unexpected index path with value \(String(describing: indexPath))")
            }
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UILabel()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SavedLayouts.defaultTableHeaderHeight
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? SavedLayouts.defaultTableHeaderHeight : 0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 1 ? UILabel() : nil
    }

//    private func mkSectionHeaderView() -> UILabel {
//        let label = UILabel()
////        label.styleForSectionHeader()
//        return label
//    }

    init(persistenceManager: PersistenceManager, epic: Epic, selectionDelegate: EpicDetailsMenuDelegate) {
        self.persistenceManager = persistenceManager
        self.epic = epic
        self.selectionDelegate = selectionDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
