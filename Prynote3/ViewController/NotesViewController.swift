//
//  NotesViewController.swift
//  Prynote3
//
//  Created by tongyi on 12/14/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class NotesViewController: UITableViewController {
    var storage: Storage!
    var _notebook: Notebook?
    var notebook: Notebook { return _notebook ?? storage.defaultNotebook() }
    var notes: [Note] = []
    var stateCoordinator: StateCoordinator?
    
    private lazy var spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private lazy var noteCountItem: UIBarButtonItem = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return UIBarButtonItem(customView: label)
    }()
    private lazy var newNoteItem = UIBarButtonItem(image: R.image.write(), style: .plain, target: self, action: #selector(didTapNewNotesButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    @objc func didTapNewNotesButton() {
        
    }
    
    @objc func didLoadAllNotes(no: Notification) {
        dismissWaitingView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func didLoadAllNotesInNotebook(no: Notification) {
        dismissWaitingView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setUp() {
        updateToolbar()
        
        //tableview
        tableView.register(UINib(resource: R.nib.noteCell), forCellReuseIdentifier: Constant.Identifier.NOTECELL)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: R.image.paper_light())
        tableView.allowsMultipleSelection = false
        
        //navigation
        navigationItem.title = _notebook?.title ?? "All Notes"
        
        //Observers
        NotificationCenter.default
            .addObserver(self, selector: #selector(didLoadAllNotes), name: .didLoadAllNotes, object: storage)
        NotificationCenter.default.addObserver(self, selector: #selector(didLoadAllNotesInNotebook), name: .didLoadAllNotesInNotebook, object: _notebook)
    }
    
    private func updateToolbar() {
        if let split = splitViewController {
            if !split.isCollapsed, split.viewControllers.count > 1,
               let nav = split.viewControllers[1] as? UINavigationController,
                nav.topViewController is EditorViewController {//hide add button
                toolbarItems = [spaceItem, noteCountItem, spaceItem]
            } else {
                toolbarItems = [spaceItem, noteCountItem, newNoteItem]
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        updateToolbar()
    }
}

extension NotesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let waitingView = WaitingView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        if _notebook == nil {//all notes
            if storage.isLoadingNotes {
                waitingView.setMsg("Loading...")
            } else {
                waitingView.setMsg("No Notes")
                waitingView.stopAnimating()
            }
        } else {//single notebook
            if _notebook!.isLoading {
                waitingView.setMsg("Loading")
            } else {
                waitingView.setMsg("No Notes")
                waitingView.stopAnimating()
            }
        }
        
        return waitingView
    }
}
