//
//  TaskDetailsTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit

class TaskDetailsTableVC: UITableViewController {

    private let cellReuseID = "TaskDetailsTableVC.cellReuseID"
    private let persistanceManager: PersistenceManager
    var task: Task!
    var epicCellTitle: String { "Epic: \(self.task.epic?.title ?? "none" ) " }
    var storyPointsCellTitle: String { "story points: \(task.storyPointsEnum.displayTitle)" }
    var workflowPositionCellTitle: String { "workflow position: \(self.task.workflowStatusEnum?.displayName ?? "none")" }

    var titles: [String]  {
        return [epicCellTitle, storyPointsCellTitle, workflowPositionCellTitle]
    }

    func update(_ task: Task) {
        self.task.epic = task.epic
        self.task.storyPointsEnum = task.storyPointsEnum
        self.task.workflowStatusEnum = task.workflowStatusEnum
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .none
    }

    init(persistenceManager: PersistenceManager, task: Task) {
        self.persistanceManager = persistenceManager
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
