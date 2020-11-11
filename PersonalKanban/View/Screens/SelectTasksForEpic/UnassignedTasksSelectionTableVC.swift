//
//  UnassignedTasksSelectionTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/10/20.
//

import UIKit

protocol UnassignedTasksSelectionDelegate: AnyObject {
    func select(_ tasks: [Task])
}

class UnassignedTasksSelectionTableVC: UITableViewController {
//    private lazy var margins = view.safeAreaInsets
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskList = persistenceManager.getUnassignedTasks()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.allowsMultipleSelection = true
        self.navigationItem.setRightBarButton(self.addBtn, animated: false)

        viewSafeAreaInsetsDidChange()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBackground
        view.backgroundColor = .systemGroupedBackground
    }

    
    private let persistenceManager: PersistenceManager
    private var taskList: [Task] = []
    private var selectedList: [IndexPath] = []
    private let epic: Epic
    private let cellReuseID = "UnassignedTasksSelectionTableVC.cellReuseID"
    private lazy var addBtn: UIBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addBtnTapped))
    weak var selectionDelegate: UnassignedTasksSelectionDelegate!

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = taskList[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedList.append(indexPath)
        print("selection \(String(describing: indexPath)) added: array now contains the following")
        selectedList.forEach({print(String(describing: $0))})
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedList = self.selectedList.filter({$0 != indexPath})
        print("selection \(String(describing: indexPath)) removed: array now contains the following")
        selectedList.forEach({print(String(describing: $0))})
    }

    @objc func addBtnTapped() {
        var tasks = selectedList.map({taskList[$0.row]})
        print("tasks.count: \(tasks.count) before saving")
        self.selectionDelegate.select(tasks)
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - initialization

    init(persistenceManager: PersistenceManager, selectionDelegate: UnassignedTasksSelectionDelegate, epic: Epic) {
        self.persistenceManager = persistenceManager
        self.selectionDelegate = selectionDelegate
        self.epic = epic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
