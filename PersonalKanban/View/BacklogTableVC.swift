//
//  BacklogTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class BacklogTableVC: UITableViewController {

    // MARK: - SlidingViewsMenu

    weak var sliderDelegate: ViewSlidingDelegate!

    var sampleData = ["one", "two", "three", "four", "five"]
    private let reuseID = "taskListCellReuseID"

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return sampleData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseID, for: indexPath)
        cell.textLabel?.text = sampleData[indexPath.row]
        return cell
    }

    // MARK: - initialisation

    // This allows you to initialise your custom UIViewController without a nib or bundle.
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    // This is also necessary when extending the superclass.
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
