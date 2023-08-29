//
//  ViewController.swift
//  iOSScreenShotPrevention
//
//  Created by lakshmi-12493 on 29/08/23.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLargeNavigation()
        //Adding secure view to the View Controller's View
        guard let secureView = SecureField().secureContainer else {return}
        secureView.addSubview(tableView)
        tableView.pinEdges()
        self.view.addSubview(secureView)
        secureView.pinEdges()
    }
    
    func setLargeNavigation() {
        self.title = "Screenshot prevention"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World! \(indexPath)"
        return cell
    }
}

class SecureField : UITextField {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.isSecureTextEntry = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var secureContainer: UIView? {
        let secureView = self.subviews.filter({ subview in
            type(of: subview).description().contains("CanvasView")
        }).first
        secureView?.translatesAutoresizingMaskIntoConstraints = false
        secureView?.isUserInteractionEnabled = true //To enable child view's userInteraction in iOS 13
        return secureView
    }
    
    override var canBecomeFirstResponder: Bool {false}
    override func becomeFirstResponder() -> Bool {false}
}

extension UIView {
    
    func pin(_ type: NSLayoutConstraint.Attribute) {
    translatesAutoresizingMaskIntoConstraints = false
    let constraint = NSLayoutConstraint(item: self, attribute: type,
                                        relatedBy: .equal,
                                        toItem: superview, attribute: type,
                                        multiplier: 1, constant: 0)

    constraint.priority = UILayoutPriority.init(999)
    constraint.isActive = true
}
    
    func pinEdges() {
        pin(.top)
        pin(.bottom)
        pin(.leading)
        pin(.trailing)
    }
}
