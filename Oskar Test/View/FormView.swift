//
//  FormView.swift
//  Oskar Test
//
//  Created by Senthil on 07/06/2024.
//

import SwiftUI

struct FormView<Manager: FormViewManagerImplementation>: View {
    
    @State private var hasError: Bool = false
    
    let title: String
    @ObservedObject var manager: Manager
    let succesfullyFilledIn: (_ data: [FormSection]) -> Void
    
    init(title: String = "",
         manager: Manager,
         succesfullyFilledIn: @escaping ([FormSection]) -> Void) {
        self.title = title
        self.manager = manager
        self.succesfullyFilledIn = succesfullyFilledIn
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                ForEach($manager.sections) { $section in
                    
                    Section {
                        
                        ForEach($section.items) { $item in
                            
                            switch item.kind {
                            case .text(let config):
                                TextField(config.title,
                                          text: $item.stringVal)
                                .textContentType(config.textContentType)
                                .keyboardType(config.keyboardInputType)
                            case .button(let config, let action):
                                Button {
                                    action(config.triggerAction)
                                } label: {
                                    Text(config.title)
                                }
                            case .toggle(let config):
                                Toggle(config.title, isOn: $item.boolVal)
                            case .secureText(let config):
                                SecureField(config.title,
                                          text: $item.stringVal)
                                .textContentType(config.textContentType)
                                .keyboardType(config.keyboardInputType)
                            }
                        }
                        
                    } header: {
                        
                        if let headerTxt = section.header {
                            Text(headerTxt)
                        }
                        
                    } footer: {
                        
                        if let footerTxt = section.footer {
                            Text(footerTxt)
                        }
                    }
                }
                
            }
            .navigationTitle(title)
            .navigationBarHidden(title.isEmpty)
        }
        .onAppear(perform: manager.loadData)
        .onChange(of: manager.state) { state in
            switch state {
            case .invalid:
                hasError = true
            case .valid:
                succesfullyFilledIn(manager.sections)
            default: break
            }
        }
        .alert("Something went wrong",
               isPresented: $hasError) {
            Button(role: .cancel) {
                manager.state = .na
            } label: {
                Text("Cancel")
            }
            
        } message: {
            Text("There seems to be some missing fields")
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(manager: FormViewManager(flow: .login)) { _ in }
    }
}
