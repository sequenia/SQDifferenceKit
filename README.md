# SQDifferenceKit

[![CI Status](https://img.shields.io/travis/lab-devoloper/SQDifferenceKit.svg?style=flat)](https://travis-ci.org/lab-devoloper/SQDifferenceKit)
[![Version](https://img.shields.io/cocoapods/v/SQDifferenceKit.svg?style=flat)](https://cocoapods.org/pods/SQDifferenceKit)
[![License](https://img.shields.io/cocoapods/l/SQDifferenceKit.svg?style=flat)](https://cocoapods.org/pods/SQDifferenceKit)
[![Platform](https://img.shields.io/cocoapods/p/SQDifferenceKit.svg?style=flat)](https://cocoapods.org/pods/SQDifferenceKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SQDifferenceKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/sequenia/SQDifferenceKit.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'SQDifferenceKit', :git => 'https://github.com/sequenia/SQDifferenceKit.git'
```

## Usage

### ViewController

```swift
import SQDifferenceKit
import DifferenceKit
```

add properties

```swift
    private(set) var data = [Section]()
    var dataInput = [Section]()
```

and add methods

```swift
    func appendOrReplaceSection(_ section: Section) {
        if let index = self.dataInput.firstIndex(where: { $0.differenceIdentifier == section.differenceIdentifier }) {
            self.dataInput[index] = section
            return
        }

        self.dataInput.append(section)
    }
    
    func reloadAnimated() {
        self.dataInput = self.dataInput.sorted(by: { $0.model.position.position() < $1.model.position.position() })
        let changeset = StagedChangeset(source: self.data, target: self.dataInput)
        
        self.tableView.reload(using: changeset, with: .automatic, setData: { (data) in
            self.data = data.map { (section) -> Section in
                let tempsection = section.model.copy()
                let elemets = section.elements.map { $0.copy() }
                return Section(model: tempsection, elements: elemets)
            }
        })
    }
```
usage method `appendOrReplaceSection(_ section: Section)` for update model cell or add new model and call `reloadAnimated()`.

#### Init section

```swift
Section(model: ModelSection(id: String, position: PositionSection), elements: [ModelRow(id: String)])
```

`PositionSection` protocol usage for sort section

##### Example PositionSection

```swift
enum Screen: Int, PositionSection {
    case section
    case section2
    case section3

    func position() -> Int {
        return self.rawValue
    }
}


self.appendOrReplaceSection( Section(model: ModelSection(id: String, position: Screen.section.position()), elements: [ModelRow(id: String)]) )

```

### ModelRow

```swift
import SQDifferenceKit
```

`override func isContentEqual(to source: ModelRow) -> Bool` use for update cell, if method return `true` cell will not be updated

`override func copy() -> ModelRow` copy all properties, otherwise object will be empty

Similarly usage `ModelHeader` and `ModelFooter`

## Author

Sequenia, ivan.michaylovsky@sequenia.com

## License

SQDifferenceKit is available under the MIT license. See the LICENSE file for more info.
