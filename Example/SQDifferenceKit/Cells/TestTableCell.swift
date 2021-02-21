//
//  TestTableCell.swift
//  SQDifferenceKit_Example
//
//  Created by Ivan Mikhailovskii on 13/02/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SQDifferenceKit

class TestTableCell: UITableViewCell {

    @IBOutlet weak var testLabel: UILabel!
    
    var model: ModelRow!
    
    func bind(model: TestModelRow) {
        self.model = model
        self.testLabel.text = model.text
    }
}
