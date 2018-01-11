//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Hamish Johnson on 2018-01-09.
//  Copyright © 2018 Hamish Johnson. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var categories: Results<Category>?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    // MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    // MARK: - Didselectrow
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation

    @IBAction func addBarButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (UITextField) in
            textField = UITextField
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Category()
            newItem.name = textField.text!
            
            self.saveCategory(category: newItem)
            
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory(category: Category) {
    
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
}
