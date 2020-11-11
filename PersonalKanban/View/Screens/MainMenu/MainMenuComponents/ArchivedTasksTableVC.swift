//
//  ArchivedTasksTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit

class ArchivedTasksTableVC: UITableViewController, SlidingContentsViewContoller {

    private let persistenceManager: PersistenceManager!
    private let cellReuseID = "ArchivedTasksTableVC.cellReuseID"
    weak var sliderDelegate: SlidingViewDelegate?
    private var data: [Task] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    func refreshDisplay() {
        self.data = persistenceManager.getArchivedTasks()
        tableView.reloadData()
    }

    func loadData() {
        self.data = persistenceManager.getArchivedTasks()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView(background: .systemGroupedBackground)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshDisplay()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = data[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sliderDelegate?.hideMenu()
        let vc = ReadOnlyTaskDetailVC(persistenceManager: persistenceManager, task: data[indexPath.row], updateDelegate: self) //AddEditTaskVC(persistenceManager: persistenceManager, useState: .edit, task: data[indexPath.row], updateDelegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = data[indexPath.row]
            persistenceManager.delete(task: toDelete)
            data.remove(at: indexPath.row)
        }
    }


    // MARK: - initialization

    init(sliderDelegate: MainViewController?, persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
