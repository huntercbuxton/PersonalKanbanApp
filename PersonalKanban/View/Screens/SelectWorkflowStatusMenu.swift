//
//  SelectWorkflowStatusMenu.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

enum WorkflowPosition: Int, CaseIterable {
    case inProgress = 0, toDo, backlog, finished

    var displayName: String {
        let strings = ["in progress","to do","backlog","finished"]
        return strings[self.rawValue]
    }

    static var defaultStatus: WorkflowPosition { return .backlog }
}

protocol WorkflowStatusSelectionDelegate: AnyObject {
    func selectStatus(newStatus: WorkflowPosition)
}

class SelectWorkflowStatusMenu: UITableViewController {

    private let cellReuseID = "SelectWorkflowStatusMenu.cellReuseID"
    private weak var workflowStatusSelectionDelegate: WorkflowStatusSelectionDelegate?
    private var options: [WorkflowPosition] = WorkflowPosition.allCases as [WorkflowPosition]
    private var currentStatus: WorkflowPosition

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView(background: .systemGroupedBackground)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = options[indexPath.row].displayName
        if options[indexPath.row] == currentStatus {
            cell.isSelected = true
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        workflowStatusSelectionDelegate?.selectStatus(newStatus: options[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    init(workflowStatusSelectionDelegate: WorkflowStatusSelectionDelegate, currentStatus: WorkflowPosition) {
        self.currentStatus = currentStatus
        self.workflowStatusSelectionDelegate = workflowStatusSelectionDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
