//
//  AiTmed.swift
//  Prynote3
//
//  Created by tongyi on 12/13/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

class APIService {
    static func loadNotebooks(completion: @escaping ([Notebook]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion([Notebook.mock(), Notebook.mock(), Notebook.mock()])
        }
    }
    
    static func addNotebook(title: String, completion: @escaping (Notebook) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(Notebook(title: title))
        }
    }
}
