//
//  ViewController.swift
//  toDOey
//
//  Created by Ho3in on 3/1/19.
//  Copyright © 2019 Ho3in. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray : [Item] = [Item]()
    
    let defaults = UserDefaults.standard                //UserDefaults constant
    
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let tempItem = itemArray[indexPath.row]
        cell.accessoryType = tempItem.done == true ? .checkmark : .none     // Ternary Operator
        
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done      // Change done current value to opisite value using !
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDOey Item", message: "Alert Message", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (myAction) in
            
            //what will happen once the user clicks the add Item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)                                    // add item to Array
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")        // Save Array to UserDefaults
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .singleLine
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {      //retrive user defaults to Array on startup
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

