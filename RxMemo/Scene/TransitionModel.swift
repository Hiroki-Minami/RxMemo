//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import Foundation

enum TransitionStyle {
  case root
  case push
  case modal
}

enum TransitionError: Error {
  case navigationControllerMissing
  case cannotPop
  case unknown
}
