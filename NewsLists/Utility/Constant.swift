//
//  Constant.swift
//  NewsLists
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//
import UIKit
import Foundation

enum CellIdentifier {
    static let cell = "cell"
}

extension UIViewController {
    static var toString: String {
        return String(describing: self)
    }
}
