//
//  CCBaseTableVC.swift
//  DVTWeatherApp
//
//  Created by Yawar Khan on 26/10/25.
//  Copyright © 2025 DVT.
//

import UIKit

protocol CCCellActionDelegate: AnyObject {
    func onCellAction(actionType: CCCellAction, position: Int)
}

enum CCCellAction {
    case itemSelected
    case itemDeleted
    case itemRefreshed
    case customAction(String)
}

protocol CCBaseTableCellProtocol {
    func displayData(model: Any)
    func getCellType() -> CCTableCellType
}

enum CCTableCellType {
    case weatherForecast
    case weatherDetail
    case noData
    case loading
}

class CCBaseTableVC: CCBaseVC, CCCellActionDelegate {

    var tableViewRef: UITableView?
    var list: [CCBaseTableCell] = []
    private var refreshCtrl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    private func setupTable() {
        guard let tbl = getTableView() else {
            return
        }

        tableViewRef = tbl
        tbl.delegate = self
        tbl.dataSource = self
        tbl.separatorStyle = .singleLine
        tbl.separatorColor = .separator
        tbl.backgroundColor = .clear

        if shouldAddPullToRefresh() {
            setupRefreshControl()
        }
    }
    
    func getTableView() -> UITableView? {
        return nil
    }

    func shouldAddPullToRefresh() -> Bool {
        return false
    }
    
    func getCellView(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cellModel: CCBaseTableCell = list[indexPath.row]
        let nibName: String = getCellNibName(cellType: cellModel.getCellType())

        var cell = tableView.dequeueReusableCell(withIdentifier: nibName)
        if cell == nil {
            let nib = UINib(nibName: nibName, bundle: Bundle.main)
            tableView.register(nib, forCellReuseIdentifier: nibName)
            cell = tableView.dequeueReusableCell(withIdentifier: nibName)
        }

        cell?.selectionStyle = .none
        cell?.backgroundColor = .clear
        return cell!
    }

    func getCellNibName(cellType: TableCellType) -> String {
        switch cellType {
        case .WEATHER_FORECAST:
            return "CCWeatherForecastTVC"
        default:
            print("⚠️ Error: table nib name not set for \(cellType)")
            return ""
        }
    }

    func getCellHeight(cellType: TableCellType, model: CCBaseTableCell) -> CGFloat {
        switch cellType {
        case .WEATHER_FORECAST:
            return 120
        default:
            return UITableView.automaticDimension
        }
    }
    
    private func setupRefreshControl() {
        refreshCtrl = UIRefreshControl()
        refreshCtrl?.tintColor = getLoaderColor()
        refreshCtrl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableViewRef?.refreshControl = refreshCtrl
    }
    
    @objc private func handleRefresh() {
        onPullToRefresh()
    }
    
    func onPullToRefresh() {
        endRefreshing()
    }
    
    func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshCtrl?.endRefreshing()
        }
    }
    
    func reloadTableData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableViewRef?.reloadData()
        }
    }
    
    func reloadRow(at index: Int, with animation: UITableView.RowAnimation = .fade) {
        guard index >= 0 && index < list.count else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let tbl = self.tableViewRef else { return }
            let indexPath = IndexPath(row: index, section: 0)
            if tbl.numberOfRows(inSection: 0) > index {
                tbl.reloadRows(at: [indexPath], with: animation)
            } else {
                self.reloadTableData()
            }
        }
    }

    func insertRow(at index: Int, with animation: UITableView.RowAnimation = .automatic) {
        guard index >= 0 && index <= list.count else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            let indexPath = IndexPath(row: index, section: 0)
            self?.tableViewRef?.insertRows(at: [indexPath], with: animation)
        }
    }

    func deleteRow(at index: Int, with animation: UITableView.RowAnimation = .automatic) {
        guard index >= 0 && index < list.count else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            let indexPath = IndexPath(row: index, section: 0)
            self?.tableViewRef?.deleteRows(at: [indexPath], with: animation)
        }
    }
    
    func showEmptyState(message: String) {
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        tableViewRef?.backgroundView = label
    }
    
    func removeEmptyState() {
        tableViewRef?.backgroundView = nil
    }

    func onCellSelected(at indexPath: IndexPath) { }

    func onCellAction(actionType: CCCellAction, position: Int) {
        // Override in subclass if needed
    }

    func refreshTable() {
        reloadTableData()
        tableViewRef?.tableFooterView = UIView()
    }
}

extension CCBaseTableVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCellView(indexPath: indexPath, tableView: tableView) as! CCBaseTVC
        let model = list[indexPath.row]

        cell.cellPos = indexPath.row
        cell.configure(with: model, at: indexPath.row)
        cell.actionDelegate = self

        return cell
    }

    func getEmptyStateMessage() -> String {
        return "No data found."
    }
}

extension CCBaseTableVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel: CCBaseTableCell = list[indexPath.row]
        return getCellHeight(cellType: cellModel.getCellType(), model: cellModel)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel: CCBaseTableCell = list[indexPath.row]
        return getCellHeight(cellType: cellModel.getCellType(), model: cellModel)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onCellSelected(at: indexPath)
    }
}

extension CCBaseTableVC {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        DispatchQueue.main.async { [weak self] in
            self?.tableViewRef?.reloadData()
        }
    }
}
