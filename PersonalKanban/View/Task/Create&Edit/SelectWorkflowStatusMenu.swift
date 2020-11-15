//
//  SelectWorkflowStatusMenu.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

//protocol WorkflowStatusSelectionDelegate: AnyObject {
//    func selectStatus(newStatus: WorkflowPosition)
//}

protocol WorkflowStatusSelectorDelegate: AnyObject {
    func select(workflowStatus: WorkflowPosition)
}

class SelectWorkflowStatusMenu: UITableViewController {

    private let cellReuseID = "SelectWorkflowStatusMenu.cellReuseID"
    private weak var delegate: WorkflowStatusSelectorDelegate?
    private var options: [WorkflowPosition] = WorkflowPosition.allCases as [WorkflowPosition]
    private var currentStatus: WorkflowPosition?
//    var saveBtn: UIBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnTapped))
//
//    @objc func saveBtnTapped() {
//        print("called \(#function)")
//        self.navigationController!.popViewController(animated: true)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "select status"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView(background: .systemGroupedBackground)
//        self.navigationItem.setRightBarButton(saveBtn, animated: true)
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
        if let status = currentStatus {
            if status == options[indexPath.row] {
                cell.isSelected = true
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.select(workflowStatus: options[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    init(workflowStatusSelectionDelegate: WorkflowStatusSelectorDelegate, currentStatus: WorkflowPosition?) {
        self.currentStatus = currentStatus
        self.delegate = workflowStatusSelectionDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}