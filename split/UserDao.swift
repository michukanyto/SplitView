//
//  UserDao.swift
//  split
//
//  Created by english on 2019-06-17.
//  Copyright © 2019 english. All rights reserved.
//

import UIKit
import CoreData

class UserDao {
    let appDelegate: AppDelegate!
    
    init(withAppDelegate appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func getManagedContext() -> NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    
    func getUsers(withAttributeName attributeName: String, andAttributeValue attributeValue: String) -> [User]? {
        if let context = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "\(attributeName)= %@", attributeValue)
            do {
                return try context.fetch(fetchRequest) as? [User]
            } catch {
                print("[ERROR] Cannot fetch from CoreData!")
                return nil
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return nil
        }
    }
    
    func getUser(withUsername username: String) -> User? {
        if let users = getUsers(withAttributeName: "username", andAttributeValue: username) {
            if users.count > 1 {
                print("[WARNING] More than one user is registered with username=\(username)!")
            }
            return users.first
        } else {
            print("[ERROR] User with username=\(username) does not exist!")
            return nil
        }
    }
    
    func getAllUsers() -> [User]? {
        if let context = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                return try context.fetch(fetchRequest) as? [User]
            } catch {
                print("[ERROR] Cannot fetch from CoreData!")
                return nil
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return nil
        }
    }
    
    func saveUser(withUserCreateForm userCreateForm: UserCreateForm) -> Bool {
        if let existing = getUser(withUsername: userCreateForm.username) {
            print("[ERROR] User with username=\(existing.username ?? "NA") already exists!")
            return false
        }
        if let context = getManagedContext() {
            let user = User(context: context)
            user.username = userCreateForm.username
            do {
                try context.save()
                return true
            } catch {
                print("[ERROR] Cannot save to CoreData!")
                return false
            }
        } else {
            print("[ERROR] Cannot communicate with CoreData!")
            return false
        }
    }
    
    func removeUser(withUsername username: String) -> Bool {
        if let existing = getUser(withUsername: username) {
            if let context = getManagedContext() {
                context.delete(existing)
                return true
            } else {
                print("[ERROR] Cannot communicate with CoreData!")
                return false
            }
        } else {
            print("[ERROR] User with username=\(username) does not exist!")
            return false
        }
    }
}
