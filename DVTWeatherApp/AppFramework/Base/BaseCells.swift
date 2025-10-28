//
//  Untitled.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 27/10/25.
//

import UIKit

protocol CCBaseTableCell {
    func getCellType()->TableCellType
}

protocol CCCellActionListner {
    func onCellAction(actionType : CellAction, position : Int);
}

protocol CCGetCellData {
    func getCellData(data : String);
}
