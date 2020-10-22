//
//  EpicDetailsEditorMenuVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class EpicDetailsEditorMenuVC: UITableViewController {

    private let cellReuseID = "EpicDetailsEditorMenuVC.cellReuseID"
    weak var selectionDelegate: EpicDetailsMenuDelegate!

    let options = [ ["add existing tasks",
                     "add new task",
                     "unassign tasks"
                    ],
                    ["archive",
                    "delete all tasks",
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = options[indexPath.section][indexPath.row]
        if indexPath.section == 0 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.textColor = .systemRed
        }
        return cell
    }

    init(selectionDelegate: EpicDetailsMenuDelegate) {
        self.selectionDelegate = selectionDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
