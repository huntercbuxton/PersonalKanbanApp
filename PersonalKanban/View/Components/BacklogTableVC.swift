//
//  BacklogTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit



class BacklogTableVC: UITableViewController, SlidingContentsViewContoller {

    weak var sliderDelegate: SlidingViewDelegate?

    func refreshDisplay() {
        print("called \(#function) implementation in BacklogTableVC")
    }

    func updateCoreData() {
        print("called \(#function) implementation in BacklogTableVC")
        self.updatedData = persistenceManager.getAllTasks()
    }

    // MARK: Data management

    let persistenceManager: PersistenceManager

    func loadData() {
        print("called loadData!!!!")
        self.updatedData = persistenceManager.getAllTasks()
    }

    // MARK: - SlidingViewsMenu


    lazy var displayData: [Task] = [] {
        didSet {
            print("in the displayedData property observer in \(#file), \(#line)")
            self.tableView.reloadData()
        }
    }

    private var fetchedData: [Task] = [] {
        didSet {
            print("in the fetchedData property observer in \(#file), \(#line)")
            self.displayData = sortData()
        }
    }

    private var updatedData: [Task] {
        get {
            print("in the displayedData GET property observer in \(#file), \(#line)")
            return persistenceManager.getAllTasks()
        } set {
            print("in the displayedData SET property observer in \(#file), \(#line)")
            updateData(in: newValue)
            persistenceManager.save()
            self.fetchedData = persistenceManager.getAllTasks()
            self.tableView.reloadData()
        }
    }

    func sortData() -> [Task] {
        return self.fetchedData
    }

    func updateData(in tasks: [Task]) {

    }

    private let reuseID = "taskListCellReuseID"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.displayData.forEach({print("task with title: ", $0.title)})
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
        return displayData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseID, for: indexPath)
        cell.textLabel?.text = displayData[indexPath.row].title
        return cell
    }

    // MARK: UITableViewDelegate conformance

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sliderDelegate?.hideMenu()
        print("selected the cell at \(indexPath) for task titled: \(self.displayData[indexPath.row].title)")
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
