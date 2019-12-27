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
    unowned var storage: Storage
    
    init(_ storage: Storage) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
        storage.addDelegate(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override var isEditing: Bool {
        didSet {
            handleEditing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    @objc func didPullToRefreshing(refreshControl: UIRefreshControl) {
        print("Refreshing...")
        storage.loadNotebooks()
    }
    
    @objc func didTapSetting() {
        
    }
    
    @objc func didTapAdd() {
        displayInputAlert(title: "Title of notebook", msg: nil) { (title) in
            guard !title.isEmpty else {
                self.displayAlert(title: "Title should not be empty", msg: nil, action: nil)
                return
            }

            self.storage.addNotebook(title: title) { index in
                self.tableView.insertRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
            }
        }
    }
    
    @objc func didLoadAllNotebooks(no: Notification) {
//        DispatchQueue.main.async {
//            if let error = no.userInfo?["error"] as? String {
//                self.displayAlert(title: "Load notebooks failed", msg: error, actionTitle: "Retry", action: {
//                    self.storage.load()
//                    self.displayWaitingView(msg: "Initializing...")
//                })
//            } else {
//                self.dismissWaitingView()
//                self.tableView.reloadData()
//                self.refreshControl?.endRefreshing()
//            }
//        }
    }
    
    @objc func didAddNotebook(no: Notification) {
//        DispatchQueue.main.async {
//            self.dismissWaitingView()
//            if let notebook = no.userInfo?[Constant.UserInfoKey.notebook] as? Notebook, let index = self.storage.indexOf(notebook: notebook) {
//                if self.open {
//                    self.tableView.insertRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
//                }
//            } else if let error = no.userInfo?["error"] as? String {
//                self.displayAutoDismissAlert(msg: "Add notebook failed")
//            }
//        }
    }
    
    @objc func didAddNote(no: Notification) {
//        self.dismissWaitingView()
//        guard let note = no.userInfo?[Constant.UserInfoKey.note] as? Note,
//            let index = storage.indexOf(notebook: note.notebook) else { return }
//        DispatchQueue.main.async {
//            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
//            if self.open {
//                self.tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .none)
//            }
//        }
    }
    
    @objc func didRemoveNote(no: Notification) {
//        self.dismissWaitingView()
//        guard let note = no.userInfo?[Constant.UserInfoKey.note] as? Note,
//            let index = storage.indexOf(notebook: note.notebook) else { return }
//        DispatchQueue.main.async {
//            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
//            if self.open {
//                self.tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .none)
//            }
//        }
    }
    
    @objc func didRemoveNotebook(no: Notification) {
//        self.dismissWaitingView()
//        guard let notebook = no.userInfo?[Constant.UserInfoKey.notebook] as? Notebook else { return }
//
//        DispatchQueue.main.async {
//            if let error = no.userInfo?["error"] as? String {
//                self.displayAlert(title: "Delete error", msg: error.description)
//            } else {
//                if let index = no.userInfo?["index"] as? Int {
//                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
//                }
//            }
//        }
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
    
    private func handleEditing() {
        print("123")
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
//        let editItem1 = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(didTapEdit))
        let editItem = editButtonItem
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
        NotificationCenter.default.addObserver(self, selector: #selector(didLoadAllNotebooks), name: .didLoadAllNotebooks, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddNotebook), name: .didAddNotebook, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddNote), name: .didAddNote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveNote), name: .didRemoveNote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveNotebook), name: .didRemoveNotebook, object: nil)
    }
    
    deinit {
        storage.removeDelegate(self)
    }
}

extension NotebookViewController: StorageDelegate {
    func storageDidLoadAllNotes(storage: Storage, success: Bool, error: AiTmedError?) {
        DispatchQueue.main.async {
            if !success {
                self.displayAlert(title: "Error", msg: error.debugDescription)
                return
            }
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    func storageDidLoadNotebooks(storage: Storage, success: Bool, error: AiTmedError?) {
        DispatchQueue.main.async {
            if !success {
                self.displayAlert(title: "Error", msg: error.debugDescription)
                return
            }
            
            if self.tableView.refreshControl?.isRefreshing == true {
                self.tableView.refreshControl?.endRefreshing()
            }
            self.tableView.reloadData()
        }
    }
    
    func storageDidAddNotebook(storage: Storage, succcess: Bool, error: AiTmedError?, notebook: Notebook?) {
        if !succcess {
            self
        }
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
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            for subview in keyWindow.subviews where subview is WaitingView {
                subview.removeFromSuperview()
            }
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
    
    func displayAlert(title: String?, msg: String?, hasCancel: Bool = false, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: actionTitle ?? "OK", style: .default) { (_) in
            action?()
        }
        alert.addAction(ok)
        if hasCancel {
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
        }
        
        present(alert, animated: true, completion: nil)
    }
}
