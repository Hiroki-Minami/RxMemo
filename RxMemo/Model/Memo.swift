//
//  Memo.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import Foundation

struct Memo: Equatable {
  var content: String
  var insertDate: Date
  var identity: String
  
  init(content: String, insertDate: Date = Date()) {
    self.content = content
    self.insertDate = insertDate
    self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
  }
  
  init(original: Memo, updateContent: String) {
    self = original
    self.content = updateContent
  }
}
