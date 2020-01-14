//
//  ViewController.swift
//  UserDefaults
//
//  Created by Hamzah Malik on 01/12/2020.
//  Copyright (c) 2020 Hamzah Malik. All rights reserved.
//

import UIKit
import UserDefaultsPlusPlus

// Describes a to-do item. Conforms to PlistStorable so that we can save it
struct TodoListItem: PlistStorable {
    
    let name: String
    let added: Date
    var completed: Bool
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var toggleCompletedButton: UIBarButtonItem!
    @IBOutlet private weak var table: UITableView!
    
    private var items = [TodoListItem]()
    private var showCompleted = true
    
    private var dateFormatter: DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mm"
        
        loadItems()
        
        table.dataSource = self
        table.delegate = self
    }
    
    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            if let text = alert.textFields?.first?.text {
                self?.addItem(withName: text)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func addItem(withName name: String) {
        let item = TodoListItem(name: name, added: Date(), completed: false)
        items.append(item)
        reloadAndSave()
    }
    
    private func reloadAndSave() {
        table.reloadData()
        toggleCompletedButton.title = showCompleted ? "Hide Completed" : "Show Completed"
        saveItems()
    }
    
    @IBAction func toggleCompleted(_ sender: Any) {
        showCompleted.toggle()
        reloadAndSave()
    }
    
}

// MARK: - Persistence

struct Storage {
    //Initialise the keys we'll use to store data
    static let todoList = UserDefault<[TodoListItem]>(key: "todo_list")
    static let showCompleted = UserDefault<Bool>(key: "show_completed")
}

extension ViewController {
    
    private func saveItems() {
        Storage.todoList.persist(items)
        Storage.showCompleted.persist(showCompleted)
    }
    
    private func loadItems() {
        items = Storage.todoList.get(or: [])
        showCompleted = Storage.showCompleted.get(or: true)
    }
    
}

// MARK: - Table
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Returns a list of items which should be visible in the table (according to the show completed filter) with their original index in the array
    private func visibleItems() -> [(index: Int, item: TodoListItem)] {
        let enumeratedItems = items.enumerated().map({ ($0, $1) })
        return showCompleted ? enumeratedItems : enumeratedItems.filter({ !$0.1.completed })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let item = visibleItems()[indexPath.row]
        cell.textLabel?.text = item.item.name
        cell.detailTextLabel?.text = dateFormatter.string(from: item.1.added)
        cell.accessoryType = item.item.completed ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = visibleItems()[indexPath.row].index
        items[index].completed.toggle()
        reloadAndSave()
    }
    
}
