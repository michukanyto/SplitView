//
//  TableViewController.swift
//  split
//
//  Created by english on 2019-06-17.
//  Copyright © 2019 english. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var users: [User]!

    override func viewDidLoad() {
        super.viewDidLoad()
        users = userDao?.getAllUsers()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") {
            cell.textLabel?.text = users[indexPath.row].username!
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? ViewController {
            viewController.labelText = users[indexPath.row].username
            splitViewController?.showDetailViewController(viewController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { action, index in
            if(userDao?.removeUser(withUsername: self.users[index.row].username!))! {
                self.users.remove(at: index.row)
                self.tableView.deleteRows(at: [index], with: .automatic)
            }
        }
        remove.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        let edit = UITableViewRowAction(style: .normal, title: "Edit") {action, index in
            print("Implement later!")
        }
        edit.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return [remove, edit]
    }
}
