//
//  NotebookViewController+.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit

extension NotebookViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let notesViewController = NotesViewController()
            notesViewController.storage = storage
            notesViewController.notes = storage.allNotes()
            notesViewController.stateCoordinator = stateCoordinator
            navigationController?.pushViewController(notesViewController, animated: true)
        case IndexPath(row: 1, section: 0):
            navigationController?.pushViewController(SharedViewController(), animated: true)
        default:
            let notesViewController = NotesViewController()
            let notebook = storage.notebooks[indexPath.row]
            notesViewController.storage = storage
            notesViewController.notes = storage.notes(in: notebook)
            notesViewController._notebook = notebook
            notesViewController.stateCoordinator = stateCoordinator
            navigationController?.pushViewController(notesViewController, animated: true)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return open ? storage.numberOfNotebooks() : 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Identifier.NOTEBOOKCELL) as! NotebookCell
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            cell.titleLabel?.text = "All Notes"
            cell.notesCountLabel?.text = "\(storage.allNotes().count)"
        case IndexPath(row: 1, section: 0):
            cell.titleLabel?.text = "Shared With Me"
            cell.notesCountLabel?.text = "\(storage.sharedWithMeNotes().count)"
        default:
            let notebook = storage.notebooks[indexPath.row]
            cell.titleLabel?.text = notebook.title
            cell.notesCountLabel?.text = "\(notebook.numberOfNotes())"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 56
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constant.Identifier.NOTEBOOKHEADER) as! NotebookHeader
        header.configure(title: "All Notebooks", section: section, delegate: self)
        return header
    }
}

extension NotebookViewController: NotebookHeaderDelegate {
    func notebookHeaderDidOpen(_ header: NotebookHeader, in section: Int) {
        var insertIndexPaths: [IndexPath] = []
        for row in 0..<storage.numberOfNotebooks() {
            insertIndexPaths.append(IndexPath(row: row, section: section))
        }
        
        open = true
        tableView.beginUpdates()
        tableView.insertRows(at: insertIndexPaths, with: .fade)
        tableView.endUpdates()
    }
    
    func notebookHeaderDidClose(_ header: NotebookHeader, in section: Int) {
        var deleteIndexPaths: [IndexPath] = []
        for row in 0..<tableView.numberOfRows(inSection: section) {
            deleteIndexPaths.append(IndexPath(row: row, section: section))
        }
        
        open = false
        tableView.beginUpdates()
        tableView.deleteRows(at: deleteIndexPaths, with: .fade)
        tableView.endUpdates()
    }
}
