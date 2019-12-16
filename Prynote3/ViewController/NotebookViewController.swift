//
//  NotebookViewController.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit
import SnapKit

class NotebookViewController: UITableViewController {
    var open = true
    var stateCoordinator: StateCoordinator?
    let storage = Storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        storage.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if storage.isLoadingNotebook {
            displayWaitingView(msg: "Initializing...")
        }
    }
    
    @objc func didPullToRefreshing(refreshControl: UIRefreshControl) {
        print("Refreshing...")
        storage.load()
    }
    
    @objc func didTapSetting() {
        
    }
    
    @objc func didTapEdit() {
        
    }
    
    @objc func didTapAdd() {
        displayInputAlert(title: "Title of notebook", msg: nil) { (title) in
            guard !title.isEmpty else {
                self.displayAlert(title: "Title should not be empty", msg: nil, action: nil)
                return
            }
            
            guard !self.storage.isDuplicateTitle(title) else {
                self.displayAlert(title: "Duplicate title", msg: "Please choose a different name", action: {
                    self.didTapAdd()
                })
                return
            }
            
            self.displayWaitingView(msg: "Creating notebook...")
            self.storage.addNotebook(title: title)
        }
    }
    
    @objc func didLoadAllNotebooks(no: Notification) {
        DispatchQueue.main.async {
            self.dismissWaitingView()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func didAddNotebook(no: Notification) {
        DispatchQueue.main.async {
            self.dismissWaitingView()
            if let notebook = no.userInfo?[Constant.UserInfoKey.notebook] as? Notebook, let index = self.storage.indexOf(notebook: notebook) {
                if self.open {
                    self.tableView.insertRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
                }
            } else {
                self.tableView.reloadData()
            }
        }
    }
    

    
    private func pullToRefreshing() {
        DispatchQueue.main.async {
            let y = self.tableView.contentOffset.y - 1
            let offset = CGPoint(x: self.tableView.contentOffset.x, y: y)
            self.tableView.setContentOffset(offset, animated: true)
            self.refreshControl?.beginRefreshing()
            self.refreshControl?.sendActions(for: .valueChanged)
        }
    }
    
    private func setUp() {
        //add background view
        let backgroundView = UIImageView(image: R.image.paper_light())
        backgroundView.contentMode = .scaleToFill
        
        //tableview
        tableView.register(UINib(resource: R.nib.notebookCell), forCellReuseIdentifier: Constant.Identifier.NOTEBOOKCELL)
        tableView.register(UINib(resource: R.nib.notebookHeader), forHeaderFooterViewReuseIdentifier: Constant.Identifier.NOTEBOOKHEADER)
        tableView.separatorStyle = .none
        tableView.backgroundView = backgroundView
        print(tableView.contentInset)
        
        //navigation item
        navigationItem.title = "Notebooks"
        let userItem = UIBarButtonItem(image: R.image.user(), style: .plain, target: self, action: #selector(didTapSetting))
        let editItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(didTapEdit))
        navigationItem.setLeftBarButton(userItem, animated: false)
        navigationItem.setRightBarButton(editItem, animated: false)
        
        //toolbar item
        let addItem = UIBarButtonItem(title: "New Notebook", style: .done, target: self, action: #selector(didTapAdd))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setToolbarItems([spaceItem, spaceItem, spaceItem, spaceItem, addItem], animated: false)
        
        //refreshing
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constant.Strings.refreshingText)
        refreshControl.addTarget(self, action: #selector(didPullToRefreshing), for: .valueChanged)
        self.refreshControl = refreshControl
        
        //observers
        NotificationCenter.default.addObserver(self, selector: #selector(didLoadAllNotebooks), name: .didLoadAllNotebooks, object: storage)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddNotebook), name: .didAddNotebook, object: storage)
    }
}

extension UIViewController {
    func displayWaitingView(msg: String) {
        let waitingView = WaitingView(msg: msg)
        waitingView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        keyWindow.addSubview(waitingView)
        waitingView.snp.makeConstraints { (make) in
            make.edges.equalTo(keyWindow)
        }
    }
    
    func dismissWaitingView() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        for subview in keyWindow.subviews where subview is WaitingView {
            subview.removeFromSuperview()
        }
    }
    
    func displayInputAlert(title: String?, msg: String?, action: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter here"
            textField.textAlignment = .center
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            if let text = alert.textFields?[0].text {
                action(text)
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func displayAlert(title: String?, msg: String?, action: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            action?()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
