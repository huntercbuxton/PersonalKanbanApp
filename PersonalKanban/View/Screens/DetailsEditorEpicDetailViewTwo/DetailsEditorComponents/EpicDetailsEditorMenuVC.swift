//
//  EpicDetailsEditorMenuVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class EpicDetailsEditorMenuVC: UITableViewController {

    private let persistenceManager: PersistenceManager
    private var epic: Epic!
    private let cellReuseID = "EpicDetailsEditorMenuVC.cellReuseID"
    weak var selectionDelegate: EpicDetailsMenuDelegate!


    let options = [ ["add existing tasks",
                     "add new task",
                     "unassign tasks"
                    ],
                    ["delete all tasks",
                    "delete epic"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
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
            print("not yet implemented")
        default:
            switch indexPath.row {
            case 0:
                let alert =  UIAlertController(title: "You are about to delete all tasks in this epic", message: "are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete Tasks", style: .destructive, handler: {
                    _ in
                    let tasks = self.epic.tasksList
                    tasks.forEach({self.persistenceManager.delete(task: $0)})
                }))
                present(alert, animated: true, completion: nil)
            case 1:
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
