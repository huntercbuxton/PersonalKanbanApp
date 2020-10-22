//
//  BacklogTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class BacklogTableVC: UITableViewController, SlidingContentsViewContoller {

    // MARK: - properties

    private let cellReuseID = "BacklogTableVC.cellReuseID"
    weak var sliderDelegate: SlidingViewDelegate?
    private let persistenceManager: PersistenceManager
    private lazy var displayData: [Task] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var fetchedData: [Task] = [] {
        didSet {
            self.displayData = sortData()
        }
    }
    private var updatedData: [Task] {
        get {
            return persistenceManager.getAllTasks()
        } set {
            persistenceManager.save()
            self.fetchedData = persistenceManager.getAllTasks()
            self.tableView.reloadData()
        }
    }

    // MARK: - methods

    func refreshDisplay() {
        print("called \(#function) implementation in BacklogTableVC")
    }

    func updateCoreData() {
        print("called \(#function) implementation in BacklogTableVC")
        self.updatedData = persistenceManager.getAllTasks()
    }

    func loadData() {
        print("called loadData!!!!")
        self.updatedData = persistenceManager.getAllTasks()
    }

    func sortData() -> [Task] {
        return self.fetchedData
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
        return cell
    }

    // MARK: - UITableViewDelegate protocol conformance

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sliderDelegate?.hideMenu()
//        print("selected the cell at \(indexPath) for task titled: \(self.displayData[indexPath.row].title)")
        let editScreen = AddEditTaskVC(persistenceManager: persistenceManager, useState: .edit, task: displayData[indexPath.row], updateDelegate: self)
        self.navigationController?.pushViewController(editScreen, animated: true)
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
