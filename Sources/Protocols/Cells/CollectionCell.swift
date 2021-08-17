//
//  File.swift
//  
//
//  Created by Semen Kologrivov on 20.02.2021.
//

import UIKit

public protocol CollectionCell: AnyObject {

    var scrollPosition: CGPoint { get set }
    var collectionView: UICollectionView! { get }

    var model: CollectionModelRow? { get set }
    var collectionDelegate: CollectionCellDelegate? { get set }

    @discardableResult
    func bind(
        model: CollectionModelRow,
        delegate: CollectionCellDelegate?
    ) -> Self
}
