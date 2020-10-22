//
//  TaskEditingTable.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import UIKit

protocol EditTaskTableDelegate: StoryPointsSelectionDelegate {
    func goToEpicSelectionScreen()
    func goToWorkflowSelectorScreen()
}

class TaskEditingTable: UITableViewController {

    // MARK: - properties storing data about the working updates to the task being edited

    var selectedEpic: Epic? {
        didSet {
            self.options[0] = epicCellTitle
        }
    }
    var storyPoints: StoryPoints {
        didSet {
            options[1] = storyPointsCellTitle
        }
    }
    var workflowPosition: WorkflowPosition {
        didSet {
            options[2] = workflowPositionCellTitle
        }
    }
    var epicCellTitle: String { "Epics: \(self.selectedEpic?.title ?? "none" ) " }
    var storyPointsCellTitle: String { "story points: \(storyPoints.displayTitle)" }
    var workflowPositionCellTitle: String { "WorkflowStatus: \(self.workflowPosition.displayName)" }

    // MARK: - other properties

    private let useState: EditScreenUseState
    private weak var editingDelegate: EditTaskTableDelegate?
    private let reuseID = "TaskEditingTableCellReuseID"
    lazy var options: [String] = [epicCellTitle, storyPointsCellTitle, workflowPositionCellTitle, "due date"] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseID)
        tableView.isScrollEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseID)
        cell.textLabel?.text = options[indexPath.row]

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
        switch indexPath.row {
        case 0:
            self.editingDelegate?.goToEpicSelectionScreen()
        case 1:
            self.editingDelegate?.goToStoryPointsSelectionScreen()
        case 2:
            self.editingDelegate?.goToWorkflowSelectorScreen()
        case 3:
            print("this selection is not yet implemented")
        default:
            fatalError("this index path \(String(describing: indexPath)) should not exist; you did something wrong in \(#file), \(#function)")
        }
    }

    // MARK: - initializers

    init(useState: EditScreenUseState, editingDelegate: EditTaskTableDelegate, selectedEpic: Epic? = nil, workflowStatus: WorkflowPosition, storyPoints: StoryPoints) {
        self.useState = useState
        self.editingDelegate = editingDelegate
        self.selectedEpic = selectedEpic
        self.storyPoints = storyPoints
        self.workflowPosition = workflowStatus
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
