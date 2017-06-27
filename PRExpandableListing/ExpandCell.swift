//
//  ExpandCell.swift
//  NavigationSetup
//
//  Created by Priyam Dutta on 15/04/17.
//  Copyright © 2017 Priyam Dutta. All rights reserved.
//

import UIKit

class ExpandCell: UITableViewCell {
    
    @IBOutlet private var labelName: UILabel!
    @IBOutlet private var labelAddress: UILabel!
    @IBOutlet private var imageShow: UIImageView!
    @IBOutlet var buttonAdd: UIButton!
    
    // Extend Outlets
    @IBOutlet fileprivate var textMore: UITextField!
    @IBOutlet var buttonDone: UIButton!
    @IBOutlet var buttonExtendAdd: UIButton!
    
    var selectedAction: ((_ action: String)->())!
    var textHandler: ((_ text: String)->())!
    
    var dataSource: AnyObject? {
        didSet {
            if self.reuseIdentifier == String(describing: ExpandCell.self) + "Extend" {
                setExtendedDataSource(dataSource!)
            }else{
                labelName.text = dataSource!["name"] as? String
                labelAddress.text = dataSource!["place"] as? String
                imageShow.layer.cornerRadius = imageShow.frame.height/2.0
                buttonAdd.layer.cornerRadius = buttonAdd.frame.height/2.0
                buttonAdd.isHidden = false
                buttonAdd.addTarget(self, action: #selector(actionExpandCell(_:)), for: .touchUpInside)
            }
        }
    }
    
    @IBAction private func actionExpandCell(_ sender: UIButton) {
        if selectedAction != nil {
            selectedAction("Expand")
            sender.isHidden = true
        }
    }
}

typealias ExtendedCell = ExpandCell
extension ExtendedCell: UITextFieldDelegate {
    
    fileprivate func setExtendedDataSource(_ data: AnyObject) {
        buttonExtendAdd.addTarget(self, action: #selector(actionAddExtendCell(_:)), for: .touchUpInside)
        buttonDone.addTarget(self, action: #selector(actionDone(_:)), for: .touchUpInside)
        buttonExtendAdd.backgroundColor = data["isAddButton"] as! Bool ? .green : .red
        buttonExtendAdd.setTitle(data["isAddButton"] as! Bool ? "+" : "-", for: .normal)
        buttonExtendAdd.tag = data["isAddButton"] as! Bool ? 101 : 102
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textHandler != nil {
            textHandler(textField.text! + string)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction private func actionAddExtendCell(_ sender: UIButton) {
        if selectedAction != nil {
            buttonDone.isHidden = true
            selectedAction(sender.tag == 101 ? "Extend" : "Shrink")
        }
    }
    
    @IBAction private func actionDone(_ sender: UIButton) {
        if selectedAction != nil {
            selectedAction("Done")
        }
    }
}
