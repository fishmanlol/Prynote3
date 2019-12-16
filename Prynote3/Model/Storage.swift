//
//  Storage.swift
//  Prynote3
//
//  Created by tongyi on 12/13/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

class Storage {
    var notebooks: [Notebook] = []
    var isLoadingNotebook = false
    var isLoadingNotes = false
    
    func load() {
        isLoadingNotebook = true
        isLoadingNotes = true
        APIService.loadNotebooks { (notebooks) in
            self.isLoadingNotebook = false
            self.notebooks = notebooks
            self.ensureExistDefaultNotebook {
                self.sortByDate()
                NotificationCenter.default.post(name: .didLoadAllNotebooks, object: self)
                let group = DispatchGroup()
                notebooks.forEach({ (notebook) in
                    group.enter()
                    notebook.load {
                        group.leave()
                    }
                })
                
                group.notify(queue: DispatchQueue.main, execute: {
                    self.isLoadingNotes = false
                    NotificationCenter.default.post(name: .didLoadAllNotes, object: self)
                })
            }
        }
    }
    
    func ensureExistDefaultNotebook(completion: @escaping () -> Void) {
        if !notebooks.contains(where: { $0.title == "Notes" }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.addDefaultNotebook()
                self.sortByDate()
                completion()
            }
        } else {
            self.sortByDate()
        }
    }
    
    func addDefaultNotebook() {
        self.notebooks.append(Notebook(title: "Notes"))
    }
    
    func allNotes() -> [Note] {
        return notebooks.flatMap({ $0.notes })
    }
    
    func sharedWithMeNotes() -> [Note] {
        return []
    }
    
    func notes(in notebook: Notebook) -> [Note] {
        return notebook.notes
    }
    
    func numberOfNotebooks() -> Int {
        return notebooks.count
    }
    
    func addNotebook(title: String) {
        APIService.addNotebook(title: title) { (notebook) in
            self.notebooks.append(notebook)
            self.sortByDate()
            NotificationCenter.default.post(name: .didAddNotebook, object: self, userInfo: [Constant.UserInfoKey.notebook: notebook])
        }
    }
    
    func isDuplicateTitle(_ title: String) -> Bool {
        return notebooks.contains{ $0.title == title }
    }
    
    func indexOf(notebook: Notebook) -> Int? {
        return notebooks.firstIndex(of: notebook)
    }
    
    func defaultNotebook() -> Notebook {
        return notebooks.first(where: { $0.title == "Notes" })!
    }
    
    func sortByDate() {
        guard !notebooks.isEmpty else { return }
        if let defaultNotebookIndex = notebooks.firstIndex(where: { $0.title == "Notes" }) {
            (notebooks[0], notebooks[defaultNotebookIndex]) = (notebooks[defaultNotebookIndex], notebooks[0])
        }
        notebooks[1..<notebooks.count].sort(by: { $0.date > $1.date })
    }
}

extension Notebook: Equatable {
    static func ==(lhs: Notebook, rhs: Notebook) -> Bool {
        return lhs.id == rhs.id
    }
}
