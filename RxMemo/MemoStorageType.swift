//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import Foundation
import RxSwift

protocol MemoStorageType {
  
  @discardableResult
  func createMemo(content: String) -> Observable<Memo>
  
  @discardableResult
  func memoList() -> Observable<[Memo]>
  
  @discardableResult
  func update(memo: Memo, content: String) -> Observable<Memo>
  
  @discardableResult
  func delete(memo: Memo) -> Observable<Memo> 
}
