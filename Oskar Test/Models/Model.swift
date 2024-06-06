//
//  Model.swift
//  Oskar Test
//
//  Created by Senthil on 07/06/2024.
//

import UIKit

struct Flow: Decodable {
    let id: String
    let ui: UI
}

struct SignupResponse: Decodable {
    let id: String
    let status: String
}

struct SigninResponse: Decodable {
    let id: String
    let status: String
}

struct UI: Decodable {
    let action: String
    let method: String
    let nodes: [Node]
}

struct Node: Decodable {
    let type: String
    let attributes: Attributes
    let meta: Meta
}

struct Attributes: Decodable {
    let name: String
    let type: String
    let value: String?
    var required: Bool?
}

struct Meta: Decodable {
    let label: Label?
    struct Label: Decodable {
        let text: String
    }
}


struct FormSection: Identifiable {
    let id = UUID()
    let key: Key
    let header: String?
    let footer: String?
    var items: [FormItem]
}

struct FormItem: Identifiable {
    let id = UUID()
    let key: Key
    let kind: Kind
    var stringVal: String = ""
    var boolVal: Bool = false
}

extension FormItem {
    enum Kind {
        case text(config: TextConfig)
        case button(config: ButtonConfig, action: (ButtonConfig.Action) -> Void)
        case toggle(config: ToggleConfig)
        case secureText(config: TextConfig)
    }
}

extension FormItem.Kind {
    struct TextConfig {
        let title: String
        let keyboardInputType: UIKeyboardType
        let textContentType: UITextContentType
    }
    struct ButtonConfig {
        let title: String
        let triggerAction: Action
    }
    struct ToggleConfig {
        let title: String
    }
}

extension FormSection {
    enum Key: String {
        case signup
        case login
        
        func title() -> String {
            switch self {
            case .login:
                return "Login"
            case .signup:
                return "SignUp"
            }
        }
    }
}

extension FormItem {
    enum Key: String {
        case submit
        case checkBox
        case username
        case password
    }
}

extension FormItem.Kind.ButtonConfig {
    enum Action {
        case submit
    }
}
