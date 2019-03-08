//
//  ViewController.swift
//  toDOey
//
//  Created by Ho3in on 3/1/19.
//  Copyright © 2019 Ho3in. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray : [Item] = [Item]()
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  // Container
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let tempItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = tempItem.title
        
        cell.accessoryType = tempItem.done == true ? .checkmark : .none     // Ternary Operator
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])          // context is Temporary so needs to call saveItem()
//        itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done      // Change done current value to opisite value using-->! inside Array
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDOey Item", message: "Alert Message", preferredStyle: .alert)   //alert declaration
        let action = UIAlertAction(title: "Add Item", style: .default) { (myAction) in                                  // action declaration
            
            //what will happen once the user clicks the add Item button on our UIAlert
            
            let newItem = Item(context: self.appContext)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)                                    // add item to Array
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item..."
            textField = alertTextField
        }
        
        alert.addAction(action)                                                     //using action
        present(alert, animated: true, completion: nil)                             //using alert
        
    }
    
    
    func saveItems() {
    
        do {
            try appContext.save()
        } catch {
            print("Error during saving item, \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            print("0000")
            
        } else {
            request.predicate = categoryPredicate
            print("1111")
        }
        
        
        do{
            itemArray = try appContext.fetch(request)
        } catch {
                print("Error during fetching item to array, \(error)")
            }
        tableView.reloadData()
    }


    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .singleLine
        
        print("LOCATION: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}





//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
        loadItems(with: request, predicate: predicate)
        
        tableView.reloadData()
        
    }
   
    
    //MARK: - Search Bar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

