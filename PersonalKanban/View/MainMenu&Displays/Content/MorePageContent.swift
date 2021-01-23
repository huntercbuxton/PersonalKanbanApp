//
//  MorePageContent.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 1/23/21.
//

import UIKit

class MorePageContent: UITableViewController, SlidingContentsVC {

    private let cellReuseID = "MorePageContent.cellReuseID"
    var sliderDelegate: SlidingViewDelegate?
    let persistence: PersistenceManager!
    let options = ["delete all tasks","delete archived tasks","delete finished tasks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseID)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let alert = UIAlertController(title: options[indexPath.row], message: "this action cannot be undone", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in
                self.persistence.deleteAllTasks()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        case 1:
            let alert = UIAlertController(title: options[indexPath.row], message: "this action cannot be undone", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in
                self.persistence.deleteArchivedTasks()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        case 2:
            let alert = UIAlertController(title: options[indexPath.row], message: "this action cannot be undone", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in
                self.persistence.deleteFinishedTasks()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        default: fatalError("the indexPath passed to \(#function) in MorePageContent was invalid ")
        }
    }

    // MARK: - initialization

    init(persistenceManager: PersistenceManager, sliderDelegate: SlidingViewDelegate?) {
        self.persistence = persistenceManager
        self.sliderDelegate = sliderDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
}