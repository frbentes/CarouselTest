//
//  CategoryCell.swift
//  TesteZup
//
//  Created by Fredyson Costa Marques Bentes on 31/12/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit

protocol ItemCellInfoDelegate {
    func deleteButtonTapped(indexCat: Int, indexItem: Int)
}

class CategoryCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var txtNewItem: UITextField!
    @IBOutlet var btnAddItem: UIButton!
    @IBOutlet var tblItems: UITableView!
    
    var arrItems: [String] = []
    var indexCategory: Int = 0
    var delegate: ItemCellInfoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblItems.delegate = self
        tblItems.dataSource = self
        txtNewItem.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldEditChanged(_ sender: UITextField) {
        if txtNewItem.text == "" {
            btnAddItem.isEnabled = false
        } else {
            btnAddItem.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = arrItems[indexPath.row]
        
        cell.lblItem.text = item
        cell.btnDeleteItem.tag = indexPath.row
        cell.btnDeleteItem.addTarget(self, action: #selector(deleteItemClicked), for: .touchUpInside)
        
        return cell
    }
    
    func deleteItemClicked(sender: UIButton!) {
        arrItems.remove(at: sender.tag)
        delegate?.deleteButtonTapped(indexCat: indexCategory, indexItem: sender.tag)
        tblItems.reloadData()
    }
    
    func addItem(item: String) {
        arrItems.append(item);
        tblItems.reloadData();
        btnAddItem.isEnabled = false
    }
    
    func deleteItems() {
        arrItems.removeAll()
        tblItems.reloadData()
    }

}
