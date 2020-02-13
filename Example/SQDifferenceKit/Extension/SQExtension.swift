//
//  SQExtension.swift
//  SQDifferenceKit
//
//  Created by Ivan Mikhailovskii on 11/02/2020.
//  Copyright © 2020 Ivan Mikhailovskii. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static func sq_identifier() -> String {
        return String.init(describing: self)
    }
    
    static func sq_nib() -> UINib {
        return UINib.init(nibName: self.sq_identifier(), bundle: Bundle.init(for: self))
    }
    
    class func instance() -> UIView {
        return UINib(nibName: self.sq_identifier(),
                     bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}

extension UITableView {
    
    func sq_register<T: UITableViewCell>(_ cellClass: T.Type) {
          self.register(T.self.sq_nib(),
                        forCellReuseIdentifier: T.self.sq_identifier())
      }
      
    func sq_dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: T.self.sq_identifier(), for: indexPath) as? T
    }
    
}

extension Array {
    
    mutating func replace(at: Int, element: Element) {
        self.remove(at: at)
        self.insert(element, at: at)
    }
}
