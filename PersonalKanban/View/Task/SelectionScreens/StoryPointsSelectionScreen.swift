//
//  StoryPointsSelectionScreen.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/21/20.
//

import UIKit

public protocol StoryPointSelectorDelegate: AnyObject {
    func select(storyPoints: StoryPoints)
}

class StoryPointsSelectionScreen: UITableViewController {

    private let cellReuseID = "StoryPointsSelectionScreen.cellReuseID"
    var options: [StoryPoints] { StoryPoints.allCases }
    private weak var delegate: StoryPointSelectorDelegate?
    private var savedChoice: StoryPoints

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "story points"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView(background: .systemGroupedBackground)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: options.firstIndex(of: savedChoice)!, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        tableView.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
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
        cell.textLabel?.text = options[indexPath.row].string
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.select(storyPoints: options[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - initializers

    init(delegate: StoryPointSelectorDelegate, currentSelection: StoryPoints) {
        self.delegate = delegate
        self.savedChoice = currentSelection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
