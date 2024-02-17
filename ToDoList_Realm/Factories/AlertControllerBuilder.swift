//
//  AlertControllerBuilder.swift
//  ToDoList_Realm
//
//  Created by Антон Баландин on 17.02.24.
//

import UIKit


/**
 Для создания `UIAlertController` с разными полями в зависимости от контекста редактирования (список задач или отдельная задача) можно использовать паттерн проектирования "Строитель" (Builder pattern). Этот паттерн позволяет создавать сложные объекты с помощью последовательного вызова методов строителя, предоставляя гибкость в конфигурировании объекта.
 */
final class AlertControllerBuilder {
    private let alertController: UIAlertController
    
    /**
         Инициализирует экземпляр `AlertControllerBuilder` с указанным заголовком и сообщением.
         
         - Parameters:
           - title: Заголовок предупреждения.
           - message: Текст сообщения предупреждения.
         */
    init(title: String, message: String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    /**
         Создает текстовое поле с указанным текстом и плейсхолдером.
         
         - Parameters:
            - placeholder: Определяет плейсхолдер для текстового поля
            - text: Определяет текст для отображения в текстовом поле
         - Returns: Ссылка на текущий экземпляр `AlertControllerBuilder` для цепочки вызовов.
         */
    func setTextField(withPlaceholder placeholder: String, andText text: String?) -> AlertControllerBuilder {
        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = text
        }
        return self
    }
    
    /**
         Добавляет действие в `UIAlertController`.
         
         - Parameters:
           - title: Заголовок действия.
           - style: Стиль действия.
           - handler: Замыкание, вызываемое при выборе действия. Принимает заголовок задачи и заголовок заметки в качестве параметров.
         - Returns: Ссылка на текущий экземпляр `AlertControllerBuilder` для цепочки вызовов.
         */
    @discardableResult
    func addAction(title: String, style: UIAlertAction.Style, handler: ((String, String) -> Void)? = nil) -> AlertControllerBuilder {
            let action = UIAlertAction(title: title, style: style) { [weak alertController] _ in
                guard let title = alertController?.textFields?.first?.text else { return }
                guard !title.isEmpty else { return }
                let note = alertController?.textFields?.last?.text
                handler?(title, note ?? "")
            }
            alertController.addAction(action)
            return self
        }
    
    /**
         Создает и возвращает экземпляр `UIAlertController`, созданный на основе установленных параметров и действий.
         
         - Returns: Экземпляр `UIAlertController`.
         */
    func build() -> UIAlertController {
        alertController
    }
}

