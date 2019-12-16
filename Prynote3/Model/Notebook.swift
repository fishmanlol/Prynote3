//
//  Notebook.swift
//  Prynote3
//
//  Created by tongyi on 12/13/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

class Notebook {
    var id: UUID = UUID()
    var title: String
    var notes: [Note] = []
    var isLoading = false
    var date = Date()
    
    init(title: String) {
        self.title = title
    }
    
    func load(completion: @escaping () -> Void) {
        isLoading = true
        let group = DispatchGroup()
        notes.forEach { (note) in
            group.enter()
            note.load(completion: {
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.main) {
            self.isLoading = false
            completion()
            NotificationCenter.default.post(name: .didLoadAllNotesInNotebook, object: self)
        }
    }
    
    static func mock() -> Notebook {
        let notebook = Notebook(title: "Notebook\(Int.random(in: 1...10))")
        notebook.notes = [Note.mock(), Note.mock(), Note.mock()]
        return notebook
    }
    
    func numberOfNotes() -> Int {
        return notes.count
    }
}
