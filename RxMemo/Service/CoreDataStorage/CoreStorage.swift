//
//  CoreStorage.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-03-03.
//

import UIKit
import RxSwift
import RxCoreData
import CoreData

class CoreStorage: MemoStorageType {
  
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  func createMemo(content: String) -> RxSwift.Observable<Memo> {
    let memo = Memo(context: context)
    memo.content = content
    let insertDate = Date()
    memo.insertDate = insertDate
    memo.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    
    do {
      try context.save()
      return Observable.just(memo)
    } catch {
      return Observable.error(error)
    }
  }
  
  func memoList() -> Observable<[Memo]> {
    let request = Memo.fetchRequest()
    let sort = NSSortDescriptor(key: "identity", ascending: true)
    request.sortDescriptors = [sort]
    return context.rx.entities(fetchRequest: request)
      .asObservable()
  }
  
  func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
    let updated = Memo(context: context)
    updated.content = content
    updated.insertDate = memo.insertDate
    updated.identity = memo.identity
    
    do {
      context.delete(memo)
      try context.save()
      return Observable.just(updated)
    } catch {
      return Observable.error(error)
    }
  }
  
  func delete(memo: Memo) -> RxSwift.Observable<Memo> {
    do {
      context.delete(memo)
      try context.save()
      return Observable.just(memo)
    } catch {
      return Observable.error(error)
    }
  }
}
