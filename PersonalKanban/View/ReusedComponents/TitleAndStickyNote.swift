//
//  TitleAndStickyNote.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/13/20.
//

import UIKit

class TitleAndStickyNote: UIViewController {

    // MARK: - properties

    var task: Task?
    var epic: Epic?
    var titleInput: PaddedTextField!
    var stickyNoteInput: LargeTextView!

    // MARK: - methods

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutInputs()
    }

    private func layoutInputs() {
        let layoutGuide = view.safeAreaLayoutGuide
        titleInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleInput)
        titleInput.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        titleInput.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        titleInput.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        stickyNoteInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stickyNoteInput)
        stickyNoteInput.topAnchor.constraint(equalTo: titleInput.bottomAnchor, constant: SavedLayouts.verticalSpacing).isActive = true
        stickyNoteInput.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        stickyNoteInput.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        stickyNoteInput.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }

    // MARK: - initializers

    init(epic: Epic?, titleObserver: InputsModelManager) {
        self.epic = epic
        self.titleInput = PaddedTextField(placeholder: "title", group: titleObserver, text: epic?.title ?? "")
        self.stickyNoteInput = LargeTextView(placeholder: "notes", group: titleObserver, text: (epic?.quickNote) ?? "")
        super.init(nibName: nil, bundle: nil)
    }

    init(task: Task?, titleObserver: InputsModelManager) {
        self.task = task
        self.titleInput = PaddedTextField(placeholder: "title", group: titleObserver, text: task?.title ?? "")
        self.stickyNoteInput = LargeTextView(placeholder: "notes", group: titleObserver, text: (task?.stickyNote) ?? "")
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
