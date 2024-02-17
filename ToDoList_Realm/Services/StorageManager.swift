//
//  StorageManager.swift
//  ToDoList_Realm
//
//  Created by Антон Баландин on 17.02.24.
//

import Foundation
import RealmSwift

final class StorageManager {
    static let shared = StorageManager()
    
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    // MARK: - Universal
    func fetchData<T>(_ type: T.Type) -> Results<T> where T: RealmFetchable {
        realm.objects(T.self)
    }
    
    func save(_ taskLists: [TaskList]) {
        write {
            realm.add(taskLists)
        }
    }
    
    func edit<T>(_ taskList: T, newValue: String, newNote: String? = nil) {
            write {
                if let objectToEdit = taskList as? TaskList {
                    objectToEdit.title = newValue
                } else if let objectToEdit = taskList as? Task {
                    objectToEdit.title = newValue
                    objectToEdit.note = newNote ?? ""
                }
            }
        }
    
    func delete<T>(_ taskList: T) {
            write {
                if let objectToDelete = taskList as? TaskList {
                    realm.delete(objectToDelete.tasks)
                    realm.delete(objectToDelete)
                } else if let objectToDelete = taskList as? Task {
                    realm.delete(objectToDelete)
                }
            }
        }
    
    func done<T>(_ taskList: T) {
            write {
                if let objectToDone = taskList as? TaskList {
                    objectToDone.tasks.setValue(true, forKey: "isComplete")
                } else if let objectToDone = taskList as? Task {
                    objectToDone.isComplete.toggle()
                }
            }
        }
    
    // MARK: - Task List
    func save(_ taskList: String, completion: (TaskList) -> Void) {
        write {
            let taskList = TaskList(value: [taskList])
            realm.add(taskList)
            completion(taskList)
        }
    }

    // MARK: - Tasks
    func save(_ task: Task, to taskList: TaskList) {
            write {
                taskList.tasks.append(task)
            }
        }
        
        private func write(completion: () -> Void) {
            do {
                try realm.write {
                    completion()
                }
            } catch {
                print(error)
            }
        }
}
