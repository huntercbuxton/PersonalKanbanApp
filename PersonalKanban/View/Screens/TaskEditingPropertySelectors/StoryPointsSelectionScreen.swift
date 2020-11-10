//
//  StoryPointsSelectionScreen.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/21/20.
//

import UIKit

protocol StoryPointsSelectionDelegate: AnyObject {
    func goToStoryPointsSelectionScreen()
    func selectStoryPoints(_ selectedValue: StoryPoints)
}

class StoryPointsSelectionScreen: UITableViewController {

    private let cellReuseID = "StoryPointsSelectionScreen.cellReuseID"
    private let options: [StoryPoints] = StoryPoints.allCases.filter({ $0 != .unassigned })
    private weak var delegate: StoryPointsSelectionDelegate?
    private var currentSelection: StoryPoints

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView(background: .systemGroupedBackground)
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
        cell.textLabel?.text = options[indexPath.row].displayTitle
        if options[indexPath.row] != .unassigned {
            cell.isSelected = true
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectStoryPoints(options[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - initializers

    init(delegate: StoryPointsSelectionDelegate, currentSelection: StoryPoints) {
        self.delegate = delegate
        self.currentSelection = currentSelection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
