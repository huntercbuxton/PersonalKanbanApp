//
//  DatePicker.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/22/20.
//

import UIKit

protocol DatePickerDelegate: AnyObject {
    func pickDate(_ selectedDate: Date)
}

class DatePicker: UIViewController {

    private var date: Date?
    weak var delegate: DatePickerDelegate?
    private let titleText = "due date"
    private var picker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleText
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnTapped))

        view.backgroundColor = .systemBackground
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        picker.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: 0).isActive = true
    }

    @objc func saveBtnTapped() {
        print("called \(#function)")
        let date = DateConversion.format(picker.date)
        delegate!.pickDate(date)
        self.navigationController!.popViewController(animated: true)
    }

    init(date: Date?, delegate: DatePickerDelegate) {
        self.date = date
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
