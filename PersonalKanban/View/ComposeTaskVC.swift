//
//  ComposeTaskVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class ComposeTaskVC: UIViewController {

    var inputValidationManager: InputValidationManager!

    lazy var saveBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                              target: self,
                                                              action: #selector(savedBarButtonTapped))

    lazy var cancelBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(cancelBarButtonTapped))

    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top//.fill
        stackView.distribution = .equalCentering//.equalSpacing
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .darkGray
        return stackView
    }()

    lazy var titleTexttField: PaddedTextField = PaddedTextField()

    lazy var notesTextView: LargeTextView = LargeTextView(text: "Test Text Here")
    @objc func savedBarButtonTapped() {
        self.dismiss(animated: true, completion: {})
            print("savedButtonTapped was executed")
    }

    @objc func cancelBarButtonTapped() {
        self.dismiss(animated: true, completion: {})
        print("cancelBarButtonTapped was completed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUIElements()
        setupDataStuff()

        let vHeight: CGFloat = view.frame.size.height - view.layoutMargins.bottom * 2
    /* print(String(describing: vHeight), "is the vHeight from view.frame.size.height -
         view.layoutMargins.top - view.layoutMargins.bottom") */
        notesTextView.topAnchor.constraint(equalTo: titleTexttField.bottomAnchor, constant: 15.0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: vHeight).isActive = true
    }

    // MARK: - initialisation

    private func setupUIElements() {
        self.title = "Create Task"
        self.navigationItem.setRightBarButton(saveBarButton, animated: false)
        saveBarButton.isEnabled = false
        self.navigationItem.setLeftBarButton(cancelBarButton, animated: false)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.setupLayout(in: self.view)
    }

    private func setupDataStuff() {
        self.titleTexttField.setupLayout(in: stackView)
        notesTextView.setupLayout(in: stackView)
        self.inputValidationManager = InputValidationManager()
        self.inputValidationManager!.delegate = self
        self.titleTexttField.inputValidationDelegate = self.inputValidationManager
        self.notesTextView.inputValidationDelegate = self.inputValidationManager
    }
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

// MARK: - InputsInterfaceDelegate

extension ComposeTaskVC: InputsInterfaceDelegate {
//    func showAlert() -> String { }
    func enableUse(for: String) {
        self.saveBarButton.isEnabled = true
    }

    func disableUse(for: String) {
        self.saveBarButton.isEnabled = false
    }
}

fileprivate extension UIStackView {

    func setupLayout(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        isBaselineRelativeArrangement = true
    }
}
