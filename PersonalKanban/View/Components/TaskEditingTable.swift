//
//  TaskEditingTable.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import UIKit



class TaskEditingTable: UITableViewController {

    private let useState: EditScreenUseState
    private let editingDelegate: EditTaskTableDelegate

    var selectedEpic: Epic? {
        didSet {
            self.menuOptions[0][2] = epicCellTitle
        }
    }
    var selectedStatus: WorkflowPosition? {
        didSet {
            self.menuOptions[0][3] = workflowStatusTitle
        }
    }

    var workflowStatusTitle: String { "WorkflowStatus: \(self.selectedStatus?.displayName)" }
    var epicCellTitle: String { "Epics: \(self.selectedEpic?.title ?? "none" ) " }
    lazy var section1Titles = ["story points","due date"]
    lazy var section2Titles = ["mark complete","copy","archive","delete"]
    lazy var menuOptions: [[String]] = setupTitle() {
        didSet {
            print("called menuOptions observer didSet")
            self.tableView.reloadData()
        }
    }

    func setupTitle() -> [[String]] {
        var temp = [section1Titles + [epicCellTitle,workflowStatusTitle]]
        if self.useState == .edit {
            temp.append(section2Titles)
        }
        return temp
    }

    private let reuseID = "TaskEditingTableCellReuseID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
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
       // print("selected index path of \(String(describing: indexPath)) for option \(self.menuOptions[indexPath.section][indexPath.row])")
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 2:
                self.editingDelegate.goToEpicSelectionScreen()
            case 3:
                self.editingDelegate.goToWorkflowSelectorScreen()
            default:
                fatalError("this index path \(String(describing: indexPath)) should not exist; you did something wrong in \(#file), \(#function)")
            }
        case 1:
            switch indexPath.row {
            case 3:
              //  print("selected the 'delete path' option in \(#function)")
                self.editingDelegate.deleteTask()
            default:
                fatalError("this index path \(String(describing: indexPath)) should not exist; you did something wrong in \(#file), \(#function)")
            }
        default:
            fatalError("this index path \(String(describing: indexPath)) should not exist; you did something wrong in \(#file), \(#function)")
        }
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

    init(useState: EditScreenUseState, editingDelegate: EditTaskTableDelegate, selectedEpic: Epic? = nil, workflowStatus: WorkflowPosition?) {
        self.useState = useState
        self.editingDelegate = editingDelegate
        self.selectedEpic = selectedEpic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    convenience init(background color: UIColor) {
        self.init()
        self.backgroundColor = color
    }
}
