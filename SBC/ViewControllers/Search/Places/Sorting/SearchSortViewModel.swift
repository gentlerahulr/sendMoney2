//
//  PlacesSortViewModel.swift
//  SBC
//

import Foundation

protocol SearchSortViewControllerDelegate: class {
    func sortingChanged(sortItems: [SortItem])
}

class SearchSortViewModel: BaseViewModel {
    
    var sortItems: [SortItem]
    weak var delegate: SearchSortViewControllerDelegate?
    
    init(sortItems: [SortItem]) {
        self.sortItems = sortItems
    }
    
    func selectItemAtIndex(_ index: Int) {
        for index in 0..<sortItems.count {
            sortItems[index].isSelected = false
        }
        sortItems[index].isSelected = true
        delegate?.sortingChanged(sortItems: sortItems)
    }
    
}
