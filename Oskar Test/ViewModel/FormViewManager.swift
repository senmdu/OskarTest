//
//  FormViewManager.swift
//  Oskar Test
//
//  Created by Senthil on 07/06/2024.
//

import Foundation

import Foundation

enum FormState {
    case na
    case valid
    case invalid
}

protocol FormViewManagerImplementation: ObservableObject {
    var sections: [FormSection] { get set }
    var state: FormState { get set }
    func loadData()
}

final class FormViewManager: FormViewManagerImplementation {
   
    @Published var sections: [FormSection] = []
    @Published var state: FormState = .na
    
    let flow: FormSection.Key
    
    init(flow: FormSection.Key) {
        self.flow = flow
    }
    
    func loadData() {
        Task {
            do {
                let flow = try await flow == .login ? NetworkService.shared.initiateSignin() : NetworkService.shared.initiateSignup()
                await self.renderFields(nodes: flow.ui.nodes)
            } catch {
                print("Failed to fetch signup fields: \(error)")
            }
        }
    }
    
    func renderFields(nodes: [Node]) async {
        var formItems = [FormItem]()
        for node in nodes where node.attributes.type != "hidden" {
          switch node.type {
            case "input":
              if node.attributes.type == "submit" {
                  let submitItem = FormItem.Kind.button(config: .init(title:
                                   node.meta.label?.text ?? node.attributes.name,
                                   triggerAction: .submit),
                                   action: { [weak self] action in
                                                    self?.validate()
                                    })
                  let submitFormItem = FormItem(key: .submit,
                                       kind: submitItem)
                formItems.append(submitFormItem)
              }else  {
                  let title = node.meta.label?.text ?? node.attributes.name
                  let textConfig = FormItem.Kind.TextConfig(title: title,
                  keyboardInputType: .default,
                                            textContentType: node.attributes.type == "email" ? .emailAddress : node.attributes.type == "password" ? .password : .name)
      
                  let inputItem = FormItem(key: node.attributes.type == "password" ? .password : node.attributes.type == "checkbox" ? .checkBox : .username,
                                           kind: node.attributes.type == "password" ? .secureText(config: textConfig) :  node.attributes.type == "checkbox" ? .toggle(config: .init(title: title)): .text(config: textConfig),
                                stringVal: "")
                  formItems.append(inputItem)
                  
              }
                    default:
                        break
                    }
                }
        let section = FormSection(key: flow,
                                  header: flow == .login ? "Login Details" : "Signup Details",
                                             footer: flow == .login ? "Please enter your credentials" : "Please enter in your signup details",
                                             items: formItems)
        await MainActor.run {
            self.sections = [
                section
            ]
        }
       
    }
}

private extension FormViewManager {
    
    func validate() {
        guard let generalSection = sections
            .first(where: { $0.key == .signup })?
            .items.filter({ !($0.key == .submit  || $0.key == .checkBox) }) else {
            return
        }
        
        let formIsEmpty = generalSection.first(where: { $0.stringVal.isEmpty }) == nil
        self.state = formIsEmpty ? .valid : .invalid
    }
}
