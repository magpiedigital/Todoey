//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Hamish Johnson on 2018-01-09.
//  Copyright © 2018 Hamish Johnson. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    // MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Didselectrow
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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
            let text = textField.text!
            
            let newItem = Category(context: self.context)
            newItem.name = text
            self.categoryArray.append(newItem)
            
            self.saveCategory()
            
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory() {
    
        do {
            try self.context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}
