//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import UIKit

public protocol CollectionCell: class {

    var scrollPosition: CGPoint { get set }
    var collectionView: UICollectionView! { get }

    var model: CollectionModelRow? { get set }
    var collectionDelegate: CollectionCellDelegate? { get set }

    func bind(model: CollectionModelRow,
              delegate: CollectionCellDelegate?)
}

public extension CollectionCell {
    
    var scrollPosition: CGPoint {
        get {
            self.collectionView.contentOffset
        }
        set {
            self.collectionView.setContentOffset(newValue, animated: false)
        }
    }
}
