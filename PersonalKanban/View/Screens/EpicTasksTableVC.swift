//
//  EpicTasksTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

enum EditableState {
    case on, off
}

class EpicTasksTableVC: UITableViewController, CoreDataDisplayDelegate {

    let persistenceManager: PersistenceManager
    let epic: Epic!
    var tasks: [[Task]] = [[],[],[],[]]

    private var viewState: EditableState = .off {
        didSet {
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }
    var detailsCellTitle: String { self.viewState == EditableState.off ? "View Details" : "Edit Details" }

    private let cellReuseID = "EpicTasksTableVC.cellReuseID"
    lazy var editBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))
    lazy var doneEditingBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditingBarButtonTapped))
    func loadData() {
        print("LOAD DATA STARTING")
        countSubArraySizes()
        self.tasks[1] = self.epic.tasksList
        print("LOAD DATA FINISHED")
        countSubArraySizes()
    }

    private func countSubArraySizes() {
        print("these are the sized of the subarrays of tasks:")
        tasks.forEach({ print(".count:", $0.count) })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.navigationItem.title = ""
        self.navigationItem.setRightBarButton(self.editBarButton, animated: true)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        self.tableView.tableFooterView = UIView(background: .systemGroupedBackground)
        self.view.backgroundColor = .systemGroupedBackground
        countSubArraySizes()
    }

    @objc func editBarButtonTapped() {
        self.viewState = .on
        self.navigationItem.setRightBarButton(self.doneEditingBarButton, animated: true)
        self.tableView.setEditing(true, animated: true)
    }

    @objc func doneEditingBarButtonTapped() {
        self.viewState = .off
        self.navigationItem.setRightBarButton(self.editBarButton, animated: true)
        self.tableView.setEditing(false, animated: true)
    }

    func pushToDetailScreen() {
        if viewState == .off {
            let detailsView = ViewOnlyEpicDetailVC(persistenceManager: persistenceManager, epic: self.epic, updateDelegate: self)
            self.navigationController?.pushViewController(detailsView, animated: true)
        } else {

        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return tasks[section].count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("calling cellForRow for indexPath: \(String(describing: indexPath))")
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseID)
            cell.textLabel?.text = self.detailsCellTitle
                cell.textLabel?.textAlignment = .center
            cell.accessoryType = .disclosureIndicator
            cell.contentView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseID)
            cell.textLabel?.text = tasks[indexPath.section][indexPath.row].title
            cell.detailTextLabel?.text = tasks[indexPath.section][indexPath.row].quickNote ?? ""
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    private func setupSectionFooterWith(titleIfEmpty: String, titleIfNotEmpty: String, for section: Int) -> UILabel {
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        label.backgroundColor = .systemGroupedBackground
        label.textAlignment = .center

        // font styles to mimic the default for a UITableView Header
        // https://ianmcdowell.net/blog/uitableview-default-fonts/
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.textColor = UIColor(red: 0.42, green: 0.42, blue: 0.44, alpha: 1.0)
        label.text = tasks[section + 1].isEmpty ? titleIfEmpty : titleIfNotEmpty
        return label
    }
    private func setupLabelForEmptySectionHeader() -> UILabel {
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        label.backgroundColor = .white
        label.textAlignment = .center

        // font styles to mimic the default for a UITableView Header
        // https://ianmcdowell.net/blog/uitableview-default-fonts/
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.textColor = UIColor(red: 0.42, green: 0.42, blue: 0.44, alpha: 1.0)
        return label
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return setupSectionFooterWith(titleIfEmpty: "You have no current tasks for this epic", titleIfNotEmpty: "current tasks", for: section)
        case 1:
            return setupSectionFooterWith(titleIfEmpty: "You have no tasks in the backlog for this epic", titleIfNotEmpty: "backlog tasks", for: section)
        case 2:
            return setupSectionFooterWith(titleIfEmpty: "you have no completed tasks for this epic", titleIfNotEmpty: "completed tasks", for: section)
        default:
            return UIView(background: .systemGroupedBackground)
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = UIView(background: .systemGroupedBackground)
            view.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
            return view
        default:
            return setupLabelForEmptySectionHeader()

        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10.0
        } else if tasks[section].isEmpty {
            return 10.0
        } else {
            return 0.0
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("that was the delete editing style at index path \(String(describing: indexPath))")
            deleteTask(at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.pushToDetailScreen()
        }
    }

    func deleteTask(at indexPath: IndexPath) {
        let task = tasks[indexPath.section][indexPath.row]
        persistenceManager.delete(task: task)
        tasks[indexPath.section].remove(at: indexPath.row)
//        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    init(persistenceManager: PersistenceManager, epic: Epic) {
        self.epic = epic
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
