//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-03-01.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel {
  
  let title: Driver<String>
  
  let sceneCoordinater: SceneCoordinatorType
  let storage: MemoStorageType
  
  init(title: String, sceneCoordinater: SceneCoordinatorType, storage: MemoStorageType){
    self.title = Observable.just(title)
      .asDriver(onErrorJustReturn: "")
    self.sceneCoordinater = sceneCoordinater
    self.storage = storage
  }
  
}
