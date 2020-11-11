//
//  BacklogTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class TasksTable: UITableViewController, SlidingContentsViewContoller {

    // MARK: - properties
    private var sortValue: WorkflowPosition
    private let cellReuseID = "BacklogTableVC.cellReuseID"
    weak var sliderDelegate: SlidingViewDelegate?
    private let persistenceManager: PersistenceManager

    private lazy var displayData: [Task] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    private var updatedData: [Task] {
        get {
            return persistenceManager.sort()
        } set {
            persistenceManager.save()
            self.displayData = persistenceManager.sort(match: sortValue)
        }
    }

    // MARK: - methods

    func updateCoreData() {
        print("called \(#function) implementation in BacklogTableVC")
        self.updatedData = persistenceManager.sort(match: sortValue)
    }

    func loadData() {
        print("called loadData!!!!")
        self.updatedData = persistenceManager.sort(match: sortValue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseID)
        self.tableView.tableFooterView = UITableViewHeaderFooterView()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseID, for: indexPath)
        cell.textLabel?.text = displayData[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate protocol conformance

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sliderDelegate?.hideMenu()
        let editScreen = AddEditTaskVC(persistenceManager: persistenceManager, useState: .edit, task: displayData[indexPath.row], updateDelegate: self)
        self.navigationController?.pushViewController(editScreen, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = displayData[indexPath.row]
            persistenceManager.delete(task: toDelete)
            displayData.remove(at: indexPath.row)
        }
    }

    // MARK: - initialization

    init(sliderDelegate: MainViewController?, persistenceManager: PersistenceManager, sortValue: WorkflowPosition = .inProgress) {
        self.persistenceManager = persistenceManager
        self.sortValue = sortValue
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
