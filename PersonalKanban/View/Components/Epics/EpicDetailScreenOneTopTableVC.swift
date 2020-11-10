//
//  EpicViewDetailsTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/9/20.
//

import UIKit

protocol EpicViewDetailsOptionTableDelegate: AnyObject {
    func goToDetailsScreen()
}

class EpicDetailScreenOneTopTableVC: UITableViewController, EditorStateControllable {

    // MARK: - EditorStateControllable conformance

    func updateEditorState(_ newState: EditableState) {
        self.editorState = newState
        tableView.reloadData()
    }

    private var editorState: EditableState = .editDisabled
    private let selectionDelegate: EpicViewDetailsOptionTableDelegate!
    private let cellReuseID = "EpicViewDetailsTableVC.cellReuseID"
    var options: [String] { [self.editorState == .editDisabled ? "View Details" : "Edit Details"] }

    override func viewDidLoad() {
        super.viewDidLoad()
        let footerView = UITableViewHeaderFooterView()
        footerView.backgroundColor = .systemGroupedBackground
        tableView.tableFooterView = footerView
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
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = options[indexPath.row]
        cell.contentView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectionDelegate.goToDetailsScreen()
    }

    // MARK: - initialization

    init(delegate: EpicViewDetailsOptionTableDelegate) {
        self.selectionDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

}
