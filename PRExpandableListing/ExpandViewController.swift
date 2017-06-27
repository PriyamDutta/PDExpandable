//
//  ExpandViewController.swift
//  NavigationSetup
//
//  Created by Priyam Dutta on 15/04/17.
//  Copyright © 2017 Priyam Dutta. All rights reserved.
//

import UIKit

class ExpandViewController: UITableViewController {

    fileprivate var mainArray = [AnyObject]()
    fileprivate var extendCellCollection = [String]()
    fileprivate var numberOfCellsExtended = 0
    fileprivate var selectedSecton = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        
        // Array Preparetion
        for index in 0...5 {
            let demoDict = ["name" : "John Delam \(index)", "place" : "House No: 76, L.A. 57th Street Downtown, U.S.A"]
            mainArray.append(demoDict as AnyObject)
        }
        selectedSecton = mainArray.count + 3
    }
    
    //MARK:- UITableViewDelegate & UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mainArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == selectedSecton {
            return extendCellCollection.count + 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ExpandCell()
        if indexPath.section == selectedSecton {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpandCell.self)) as! ExpandCell
                cell.dataSource = mainArray[indexPath.section]
                cell.buttonAdd.isHidden = true
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpandCell.self) + "Extend") as! ExpandCell
                let addButton: Bool = indexPath.row == 1 ? true : false
                cell.dataSource = ["isAddButton" : addButton] as [String: Any] as AnyObject?
                cell.buttonDone.isHidden = indexPath.row == numberOfCellsExtended ? false : true
            }
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpandCell.self)) as! ExpandCell
            cell.dataSource = mainArray[indexPath.section]
            cell.buttonAdd.isHidden = false
        }
        weak var weakSelf = self
        cell.selectedAction = { (action) in
            weakSelf?.handleRowOperations(indexPath as NSIndexPath, action: action)
        }
        cell.textHandler = { (text) in
            debugPrint(text)
            weakSelf?.extendCellCollection[indexPath.row - 1] = text
            debugPrint(self.extendCellCollection)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != selectedSecton {
            let dataModel = DataModel()
            dataModel.addOnArray = []
            dataModel.dataDict = mainArray[indexPath.section] as! [String : String]
        }
    }
}

typealias Operation = ExpandViewController
extension Operation {

    fileprivate func handleRowOperations(_ indexPath: NSIndexPath, action: String) {
        weak var weakSelf = self
        switch action {
        case "Expand":
            extendCellCollection.removeAll()
            tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                weakSelf?.selectedSecton = indexPath.section
                weakSelf?.numberOfCellsExtended = 1
                weakSelf?.extendCellCollection.append("\(indexPath.row)")
                weakSelf?.tableView.beginUpdates()
                weakSelf?.tableView.insertRows(at: [IndexPath(row:  indexPath.row + 1, section: indexPath.section)], with: .bottom)
                weakSelf?.tableView.endUpdates()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: {
                weakSelf?.tableView.reloadData()
            })
        case "Extend":
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                weakSelf?.numberOfCellsExtended += 1
                weakSelf?.extendCellCollection.insert("\(self.numberOfCellsExtended)", at: indexPath.row)
                weakSelf?.tableView.beginUpdates()
                weakSelf?.tableView.insertRows(at: [IndexPath(row:  indexPath.row + 1, section: indexPath.section)], with: .bottom)
                weakSelf?.tableView.endUpdates()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: {
                weakSelf?.tableView.reloadData()
            })
        case "Shrink":
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                weakSelf?.numberOfCellsExtended -= 1
                weakSelf?.extendCellCollection.remove(at: indexPath.row-1)
                weakSelf?.tableView.beginUpdates()
                weakSelf?.tableView.deleteRows(at: [IndexPath(row:  indexPath.row, section: indexPath.section)], with: .top)
                weakSelf?.tableView.endUpdates()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: {
                weakSelf?.tableView.reloadData()
            })
        case "Done":
            let dataModel = DataModel()
            dataModel.addOnArray = (weakSelf?.extendCellCollection)!
            dataModel.dataDict = mainArray[selectedSecton] as! [String : String]
        default:
            break
        }
    }
}

// Object Model
class DataModel: NSObject {
    var dataDict = [String : String]()
    var addOnArray = [String]()
    override init() {
        super.init()
    }
    
}

