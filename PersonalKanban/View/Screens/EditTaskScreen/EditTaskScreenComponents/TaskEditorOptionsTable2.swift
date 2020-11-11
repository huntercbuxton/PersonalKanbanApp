//
//  TaskEditorOptionsTable2.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/22/20.
//

import UIKit

protocol TaskEditorOptionsTable2Delegate: AnyObject {
    func deleteTask()
    func archiveTask()
}

class TaskEditorOptionsTable2: UITableViewController {

    // MARK: - properties

    private let cellReuseID = "TaskEditorOptionsTable2.cellReuseID"
    private let options = ["archive", "delete"]
    private weak var delegate: TaskEditorOptionsTable2Delegate?

    var isArchived: Bool = false {
        didSet {
            delegate?.archiveTask()
        }
    }

    // MARK: - methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.textAlignment = .center
        if indexPath.row == 1 {
            cell.textLabel?.textColor = .systemRed
        }
        return cell
    }

    // MARK: - UITableViewDelegate conformance

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.isArchived = true
            print("not yet implemented actions for indexPath: \(indexPath)")
        case 1:
            self.delegate?.deleteTask()
        default:
            fatalError("this index path \(String(describing: indexPath)) should not exist; you did something wrong in \(#file), \(#function)")
        }
    }

    // MARK: - initializers

    init(delegate: TaskEditorOptionsTable2Delegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
