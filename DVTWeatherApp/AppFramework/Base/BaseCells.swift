//
//  Untitled.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//

import UIKit

protocol BaseTableCell {
    func getCellType()->TableCellType
}

protocol CellActionListner {
    func onCellAction(actionType : CellAction, position : Int);
}

protocol BaseCollectionCell{
    func getCellType()->CollectionCellType
}

protocol GetCellData {
    func getCellData(data : String);
}
