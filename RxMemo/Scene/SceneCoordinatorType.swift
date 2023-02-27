//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
  
  @discardableResult
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
  
  @discardableResult
  func close(animated: Bool) -> Completable
}
