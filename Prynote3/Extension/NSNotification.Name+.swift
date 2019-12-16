//
//  NSNotification.Name+.swift
//  SplitViewControllerDemo
//
//  Created by tongyi on 12/3/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static var didLoadAllNotebooks = NSNotification.Name("didUpdateStorage")
    static var didLoadAllNotes = NSNotification.Name("didLoadAllNotes")
    static var didLoadAllNotesInNotebook = NSNotification.Name("disLoadAllNotesInNotebook")
    static var didAddNote = NSNotification.Name("didAddNote")
    static var didRemoveNote = NSNotification.Name("didRemoveNote")
    static var didUpdateNote = NSNotification.Name("didUpdateNote")
    static var didSplitViewControllerExpand = NSNotification.Name("didSplitViewControllerExpand")
    static var didAddNotebook = NSNotification.Name(rawValue: "didAddNotebook")
}
