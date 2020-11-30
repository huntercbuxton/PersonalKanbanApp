//
//  TaskDetailsTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit

class TaskDetailsTableVC: UITableViewController {

    private let isReadOnly: Bool
    private let persistenceManager: PersistenceManager
    private let cellReuseID = "TaskDetailsTableVC.cellReuseID"
    var modelManager: InputsModelManager?

    var task: Task? {
        didSet {
            self.epic = task?.epic
            self.storyPoints = task?.storyPointsEnum ?? .unassigned
            self.workflowPosition = task?.workflowStatusEnum
            tableView.reloadData()
        }
    }

    var epic: Epic? {
        didSet {
            self.titles[0] = epicCellTitle
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }

    var storyPoints: StoryPoints = .unassigned {
        didSet {
            self.titles[1] = storyPointsCellTitle
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
        }
    }

    var workflowPosition: WorkflowPosition? {
        didSet {
            self.titles[2] = workflowPositionCellTitle
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
        }
    }

    var epicCellTitle: String { "Epic: \(epic?.title! ?? "none" ) " }
    var storyPointsCellTitle: String { "story points: \(storyPoints.string)" }
    var workflowPositionCellTitle: String { "workflow position: \(workflowPosition?.string ?? "none")" }
    lazy var titles: [String] = [ epicCellTitle, storyPointsCellTitle, workflowPositionCellTitle ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        self.workflowPosition = modelManager?.register(groupID: Inputs.position)
        if self.epic == nil { self.epic = modelManager?.register(groupID: .epic) }
        self.storyPoints = modelManager?.register(groupID: .storypoints) ?? StoryPoints()
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
        if !isReadOnly { cell.accessoryType = .disclosureIndicator }
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .none
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isReadOnly else { return }
        switch indexPath.row {
        case 0: self.navigationController?.pushViewController(ChooseEpicsScreen(persistenceManager: self.persistenceManager, selectionDelegate: modelManager!), animated: true)
        case 1: self.navigationController?.pushViewController(StoryPointsSelectionScreen(delegate: modelManager!, currentSelection: self.storyPoints), animated: true)
        case 2: navigationController?.pushViewController(SelectWorkflowStatusMenu(workflowStatusSelectionDelegate: modelManager!, currentStatus: workflowPosition), animated: true)
        default: assertionFailure("the call of function \(#function) had argument IndexPath = \(String(describing: indexPath)). there should be no cell at that path")
        }
    }

    init(coreDataDAO: PersistenceManager, isReadOnly: Bool) {
        self.persistenceManager = coreDataDAO
        self.isReadOnly = isReadOnly
        super.init(nibName: nil, bundle: nil)
    }

    init(coreDataDAO: PersistenceManager, task: Task?, isReadOnly: Bool) {
        self.persistenceManager = coreDataDAO
        self.task = task
        epic = self.task?.epic
        storyPoints = self.task?.storyPointsEnum ?? .unassigned
        workflowPosition = self.task?.workflowStatusEnum
        self.isReadOnly = isReadOnly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
