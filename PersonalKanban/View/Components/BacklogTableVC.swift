//
//  BacklogTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class BacklogTableVC: UITableViewController {

    let persistenceManager: PersistenceManager

    func getTasks() {
        self.tasks = persistenceManager.getAllTasks()
    }

    // MARK: - SlidingViewsMenu

    weak var sliderDelegate: SlidingViewDelegate?

    private var tasks: [Task] = []

    private let reuseID = "taskListCellReuseID"

    override func viewDidLoad() {
        super.viewDidLoad()
        getTasks()
        self.tasks.forEach({print("task with title: ", $0.title)})
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseID)
        self.tableView.tableFooterView = UITableViewHeaderFooterView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseID, for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }

    // MARK: UITableViewDelegate conformance

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sliderDelegate?.hideMenu()
        print("selected the cell at \(indexPath) for task titled: \(self.tasks[indexPath.row].title)")
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
