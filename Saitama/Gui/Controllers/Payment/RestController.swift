//
//  RestController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

//
//  RestTableViewController.swift
//  Homepwner
//
//  Created by Marcos Hass Wakamatsu on 10/04/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

//class RestTableViewController: UITableViewController {
//    
//    @IBOutlet weak var lblDescricao: UILabel!
//    
//    /** Store that fetches data from rest api.
//     */
//    var store: RestStore!
//    
//    /** Progress indicator positioned on the last row.
//     */
//    var spinner: UIActivityIndicatorView!
//    
//    /** Information used to configure the tableview.
//     */
//    var cellInfo: IBaseCell!
//    
//    /**  Initializer used by subclasses for automatic paging and loading indicator.
//     - parameters:
//     - aDecoder: NSCoder received from UIKit
//     - store: RestStore that retrieves data from webservice
//     - cell: IBaseCell with configuration data and gui mapping
//     */
//    init?(coder aDecoder: NSCoder, restStore: RestStore, cell: IBaseCell) {
//        super.init(coder: aDecoder)
//        self.store = restStore
//        self.cellInfo = cell
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    /** Return the right store (regular/filtered).
//     */
//    var currentStore: RestStore {
//        get {
//            return store
//        }
//    }
//    
//    /** Initialize cell properties found into the IBasecell.
//     */
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Configure the dynamic height of the cells
//        if cellInfo.hasDynamicRowHeight {
//            tableView.rowHeight = UITableViewAutomaticDimension
//            tableView.estimatedRowHeight = cellInfo.dynamicRowHeight
//        }
//        
//        // Remove extra separators from tableview
//        self.tableView.tableFooterView = UIView()
//    }
//    
//    /** Refresh the table view content.
//     */
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//    }
//    
//    /** Load data from the current store.
//     */
//    func reloadData() {
//        self.removeNoDataBanner(self.tableView)
//        
//        currentStore.loadData { (data, response, error) in
//            OperationQueue.main.addOperation({
//                // dismiss the progress indicator and inserts "no data" view
//                self.spinner?.stopAnimating()
//                if self.currentStore.count() == 0 {
//                    self.insertNoDataBanner(self.tableView)
//                }
//                
//                if error != nil {
//                    print("Error occured: \(error.debugDescription)")
//                } else {
//                    self.tableView.reloadData()
//                }
//            })
//        }
//    }
//    
//    func removeNoDataBanner(_ tableView: UITableView) {
//        tableView.backgroundView = nil;
//    }
//    
//    func insertNoDataBanner(_ tableView: UITableView) {
//        let tableWidth = tableView.bounds.size.width
//        let tableHeight = tableView.bounds.size.height
//        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableWidth, height: tableHeight))
//        noDataLabel.text = "No data available"
//        noDataLabel.textColor = UIColor.black
//        noDataLabel.textAlignment = .center
//        
//        self.tableView.backgroundView = noDataLabel
//        self.tableView.separatorStyle = .none
//    }
//    
//    // MARK: UITableViewDataSource
//    
//    /** Calculates total number of rows based on the store's nextlink property.
//     */
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if currentStore.nextLink == nil {
//            return self.store.count()
//        } else {
//            return self.store.count() + 1 // additional row for loading indicator
//        }
//    }
//    
//    /** Returns the regular cell or the activity indicator depending on the row.
//     */
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: UITableViewCell
//        let current = currentStore
//        
//        if indexPath.row == current.count() {
//            cell = tableView.dequeueReusableCell(withIdentifier: cellInfo.loadingRowIdentifier!, for: indexPath)
//            spinner = cell.contentView.viewWithTag(100) as? UIActivityIndicatorView
//            spinner.startAnimating()
//        } else {
//            cell = tableView.dequeueReusableCell(withIdentifier: cellInfo.identifier, for: indexPath)
//            (cell as! IBaseCell).configure(dictionary: self.store.items[indexPath.row])
//        }
//        
//        return cell
//    }
//    
//    // MARK: UITableViewDelegate
//    
//    /** Triggered when the tableview is scrolled, if there is a next link and
//     we're at the last row  the webservice is queried again for more data.
//     */
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let current = currentStore
//        
//        /* If there is a link to next page and we're at least in the last row */
//        if current.nextLink != nil && indexPath.row >= current.count() - 1 {
//            reloadData()
//        }
//    }
//    
//}
//
//extension String {
//    
//    func encodeUTF8() -> String? {
//        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//    }
//    
//}

