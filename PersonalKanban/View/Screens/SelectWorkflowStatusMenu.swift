//
//  SelectWorkflowStatusMenu.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

enum WorkflowPosition: Int, CaseIterable {
    case toDo = 0, backlog, finished, archive

    var displayName: String {
        var strings = [ "to-do","backlog","finished","archive"]
        return strings[self.rawValue]
    }

    static var defaultStatus: WorkflowPosition { return .backlog }
}



class SelectWorkflowStatusMenu: UITableViewController {

//    var currentSelection: WorkflowPosition
    private let cellReuseID = "SelectWorkflowStatusMenu.cellReuseID"
    var workflowStatusSelectionDelegate: WorkflowStatusSelectionDelegate
    var options: [WorkflowPosition] = WorkflowPosition.allCases as [WorkflowPosition]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        self.tableView.tableFooterView = UIView(background: .systemGroupedBackground)
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
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        workflowStatusSelectionDelegate.selectStatus(newStatus: options[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    init(workflowStatusSelectionDelegate: WorkflowStatusSelectionDelegate) {
        self.workflowStatusSelectionDelegate = workflowStatusSelectionDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
