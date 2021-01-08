//
//  ChooseEpicsScreen.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

public protocol EpicsSelectorDelegate: AnyObject {
    func select( epic: Epic)
}

class ChooseEpicsScreen: UITableViewController {

    private let persistenceManager: PersistenceManager
    private let cellReuseID = "ChooseEpicsScreen.cellReuseID"
    lazy var options: [Epic] = []
    var savedChoice: Epic?
    weak var delegate: EpicsSelectorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.options = persistenceManager.getAllEpics()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseID)
        self.tableView.tableFooterView = UITableViewHeaderFooterView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selection = self.savedChoice, let selectedIndex = options.firstIndex(of: selection) {
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            tableView.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseID, for: indexPath)
        cell.textLabel?.text = options[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.select(epic: self.options[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - initialization

    init(persistenceManager: PersistenceManager, selectionDelegate: EpicsSelectorDelegate, currentEpic: Epic?) {
        self.persistenceManager = persistenceManager
        self.delegate = selectionDelegate
        self.savedChoice = currentEpic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
