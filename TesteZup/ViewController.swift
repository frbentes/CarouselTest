//
//  ViewController.swift
//  TesteZup
//
//  Created by Fredyson Costa Marques Bentes on 27/12/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemCellInfoDelegate {

    // Properties
    
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var lblNumCategories: UILabel!
    @IBOutlet var tblCategories: UITableView!
    @IBOutlet var startView: UIView!
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // no empty cells at the end of the table
        tblCategories.tableFooterView = UIView()
        tblCategories.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        startView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.delegate = self
        cell.indexCategory = indexPath.row
        
        let category = categories[indexPath.row]
        cell.lblName.text = category.name
        cell.btnAddItem.tag = indexPath.row
        cell.btnAddItem.addTarget(self, action: #selector(addItemClicked), for: .touchUpInside)
        
        return cell
    }
    
    func addItemClicked(sender: UIButton!) {
        var indexPath: IndexPath!
        if let button = sender {
            if let superview = button.superview {
                if let cell = superview.superview as? CategoryCell {
                    indexPath = tblCategories.indexPath(for: cell) as IndexPath!
                }
            }
        }
        
        if indexPath != nil {
            let cell = tblCategories.cellForRow(at: indexPath) as! CategoryCell
            let category = categories[sender.tag]
            category.items.append(cell.txtNewItem.text!)
            cell.addItem(item: cell.txtNewItem.text!)
            cell.txtNewItem.text = ""
        }
    }
    
    // MARK: - Stepper
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        lblNumCategories.text = value.description
        
        if value > categories.count {
            let newCategory = Category()
            newCategory.name = "Categoria \(value)"
            newCategory.items = []
            categories.append(newCategory)
        } else if value < categories.count {
            let indexPath = IndexPath(row: categories.count - 1, section: 0)
            let cell = tblCategories.cellForRow(at: indexPath) as! CategoryCell
            cell.deleteItems()
            categories.removeLast()
        }
        
        tblCategories.reloadData()
    }
    
    func deleteButtonTapped(indexCat: Int, indexItem: Int) {
        let category = categories[indexCat]
        category.items.remove(at: indexItem)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCarousel" {
            let destViewController = segue.destination as! CarouselViewController
            
            var arrItems: [[String]] = []
            for category in categories {
                if category.items.count > 0 {
                    var items: [String] = []
                    for item in category.items {
                        items.append(item)
                    }
                    items.insert(category.name!, at: 0)
                    arrItems.append(items)
                }
            }
            
            destViewController.items = arrItems
        }
    }
    
}

