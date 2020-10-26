//
//  SelectWorkflowStatusMenu.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

protocol WorkflowStatusSelectionDelegate: AnyObject {
    func selectStatus(newStatus: WorkflowPosition)
}

class SelectWorkflowStatusMenu: UITableViewController {

    private let cellReuseID = "SelectWorkflowStatusMenu.cellReuseID"
    private weak var workflowStatusSelectionDelegate: WorkflowStatusSelectionDelegate?
    private var options: [WorkflowPosition] = WorkflowPosition.allCases as [WorkflowPosition]
    private var currentStatus: WorkflowPosition
    var saveDate: UIBarButtonItem =  UIBarButtonItem(title: "SaveDate", style: .plain, target: nil, action: #selector(SelectWorkflowStatusMenu.saveDateTapped))// UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(SelectWorkflowStatusMenu.saveDateTapped))
    @objc func saveDateTapped() {
        print("called \(#function)")
//        delegate!.pickDate(picker.date)
        self.navigationController!.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "select status"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView(background: .systemGroupedBackground)
        self.navigationItem.setRightBarButton(saveDate, animated: true)
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
