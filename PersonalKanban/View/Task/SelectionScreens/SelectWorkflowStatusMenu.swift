//
//  SelectWorkflowStatusMenu.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

public protocol WorkflowStatusSelectorDelegate: AnyObject {
    func select(workflowStatus: WorkflowPosition)
}

class SelectWorkflowStatusMenu: UITableViewController {

    private let cellReuseID = "SelectWorkflowStatusMenu.cellReuseID"
    private weak var delegate: WorkflowStatusSelectorDelegate?
    private var options: [WorkflowPosition] { WorkflowPosition.allCases }
    private var savedChoice: WorkflowPosition = .typeDefault

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "workflow status"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView(background: .systemGroupedBackground)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: options.firstIndex(of: savedChoice)!, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        tableView.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
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
        cell.textLabel?.text = options[indexPath.row].menuPage!.title
        if savedChoice == options[indexPath.row] { cell.isSelected = true }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.select(workflowStatus: options[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    init(workflowStatusSelectionDelegate: WorkflowStatusSelectorDelegate, currentStatus: WorkflowPosition) {
        self.savedChoice = currentStatus
        self.delegate = workflowStatusSelectionDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
