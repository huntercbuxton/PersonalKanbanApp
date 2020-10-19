//
//  TaskEditingTable.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import UIKit

class TaskEditingTable: UITableViewController {

    let menuOptions = [["story points","due date","epic"],
                       ["mark complete","copy","archive","delete"]
    ]

    private let reuseID = "TaskEditingTableCellReuseID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseID)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return menuOptions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseID, for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseID)
        cell.textLabel?.text = menuOptions[indexPath.section][indexPath.row]

        if indexPath.section == 0 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.textAlignment = .center
            if indexPath.row == 3 {
                cell.textLabel?.textColor = .systemRed
            }
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row for option \(self.menuOptions[indexPath.section][indexPath.row])")
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(background: .systemGroupedBackground)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(background: .systemGroupedBackground)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return " "
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
       return " "
    }

}

extension UIView {
    convenience init(background color: UIColor) {
        self.init()
        self.backgroundColor = color
    }
}
