//
//  CCBaseTVC.swift
//  DVTWeatherApp
//
//  Created by Yawar Khan on 26/10/25.
//  Copyright © 2025 DVT.
//

import UIKit

class CCBaseTVC: UITableViewCell {
    
    weak var actionDelegate: CCCellActionDelegate?
    var cellPos: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // Setup UI defaults
    func setupCellUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configure(with data: Any, at pos: Int) {
        self.cellPos = pos
    }
    
    // Notify delegate of cell action
    func triggerAction(_ type: CCCellAction) {
        actionDelegate?.onCellAction(actionType: type, position: cellPos)
    }
    
    
    func addTapGesture(to views: UIView..., action: Selector) {
        for v in views {
            v.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: action)
            v.addGestureRecognizer(tap)
        }
    }
}
