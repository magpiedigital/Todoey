//
//  ViewController.swift
//  Todoey
//
//  Created by Hamish Johnson on 2018-01-04.
//  Copyright © 2018 Hamish Johnson. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var toDoItems: Results<Item>?
    var selectedCategory : Category?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    // MARK - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
//                    item.done = !item.done
                }
            } catch {
                print("Error updating checkmark \(error)")
            }
        }
        
        tableView.reloadData()
        
    }
    
    
    
    // MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving context, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

}

// MARK: - Search bar delegate methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            print("cancelled")
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

