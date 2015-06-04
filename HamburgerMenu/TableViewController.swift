//
//  TableViewController.swift
//  HamburgerMenu
//
//  Created by Happiest Minds on 27/05/15.
//  Copyright (c) 2015 Coder. All rights reserved.
//

import UIKit

protocol TableViewControllerDelegate: class {
    func didSelect(row: Int)
}

class TableViewController: UITableViewController {

    weak var selectionDelegate: TableViewControllerDelegate?
    
    let data: QuestionGroup = QuestionGroup.testData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.totalRows()-1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.questionGroup = data[indexPath.row]
        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if selectionDelegate != nil {
            selectionDelegate!.didSelect(indexPath.row)
        }
    
    }

}
