//
//  TasksListDisplayVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit

protocol TaskTableDataSource {
    var dao: PersistenceManager { get }
    func getData() -> [[Task]]
    func getSectionHeaders() -> [UILabel?]
    func getSectionFooters() -> [UILabel?]
}

extension TaskTableDataSource {
    func getData() -> [[Task]] {
        return [dao.getAllTasks()]
    }
    func getSectionHeaders() -> [UILabel?] {
        return [nil]
    }
    func getSectionFooters() -> [UILabel?] {
        return [nil]
    }
}

class TasksListDisplayVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CoreDataDisplayDelegate, SlidingContentsVC {

    // MARK: - CoreDataDisplayDelegate

    func updateCoreData() {
        persistenceManager.save()
        taskLists = dataSource.getData()
    }

    // MARK: - SlidingContentsVC

    func refreshDisplay() {
        tableView.reloadData()
    }

    weak var sliderDelegate: SlidingViewDelegate?

    // MARK: - other properties

    private let persistenceManager: PersistenceManager
    private let dataSource: TaskTableDataSource
    lazy var taskLists: [[Task]] = [[]]
    lazy var sectionHeaders: [UILabel?] = []
    lazy var sectionFooters: [UILabel?] = []
    lazy var tableView: UITableView = UITableView()
    private let defaultCellReuseID = "TasksListDisplayVC.defaultCellReuseID"

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        taskLists = dataSource.getData()
        sectionHeaders = dataSource.getSectionHeaders()
        sectionFooters = dataSource.getSectionFooters()
        tableViewSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCoreData()
        refreshDisplay()
    }

    // MARK: - other methods

    private func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
                                    tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellReuseID)
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sliderDelegate?.hideMenu()
        let detailVC = ReadOnlyTaskDetailVC(persistenceManager: persistenceManager, task: taskLists[indexPath.section][indexPath.row], updateDelegate: self)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return taskLists.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: defaultCellReuseID)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = taskLists[indexPath.section][indexPath.row].title
        return cell
    }

    // MARK: - initializers

    init(persistenceManager: PersistenceManager, sliderDelegate: SlidingViewDelegate?, dataSource: TaskTableDataSource) {
        self.persistenceManager = persistenceManager
        self.sliderDelegate = sliderDelegate
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
}
