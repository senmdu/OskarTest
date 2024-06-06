//
//  ContentView.swift
//  Oskar Test
//
//  Created by Senthil on 06/06/2024.
//

import SwiftUI

struct MainView: View {
    @State private var formType: FormSection.Key = .login
    @State private var sheetToogle  = false

    @StateObject private var signupForm = FormViewManager(flow: .signup)
    @StateObject private var loginForm = FormViewManager(flow: .login)
    

    var body: some View {
        VStack {
            let forms: [FormSection.Key] = [.login,.signup]
            ForEach(forms, id: \.self) {  formType in
                Button(formType.title()) {
                    self.formType = formType
                    sheetToogle.toggle()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .sheet(isPresented: $sheetToogle) {
                FormView(title: formType.title(),
                         manager: formType == .login ? loginForm : signupForm) { data in
                    dump(data)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
