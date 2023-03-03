//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

//import Foundation
//import RxSwift
//
//class MemoryStorage: MemoStorageType {
//  private var memos: [Memo] = [
//    Memo(content: "Hello MVVM"),
//    Memo(content: "Hello RxSwift", insertDate: Date().addingTimeInterval(-20))
//  ]
//
//  private lazy var store = BehaviorSubject<[Memo]>(value: memos)
//
//  func createMemo(content: String) -> RxSwift.Observable<Memo> {
//    let memo = Memo(content: content)
//    memos.append(memo)
//    store.onNext(memos)
//    return Observable.just(memo)
//  }
//
//  func memoList() -> RxSwift.Observable<[Memo]> {
//    return store
//  }
//
//  func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
//    let updated = Memo(original: memo, updateContent: content)
//
//    if let index = memos.firstIndex(where: {$0 == memo}) {
//      memos.remove(at: index)
//      memos.insert(updated, at: index)
//    }
//    store.onNext(memos)
//    return Observable.just(updated)
//  }
//
//  func delete(memo: Memo) -> RxSwift.Observable<Memo> {
//    if let index = memos.firstIndex(where: {$0 == memo}) {
//      memos.remove(at: index)
//    }
//    store.onNext(memos)
//    return Observable.just(memo)
//  }
//
//
//}
