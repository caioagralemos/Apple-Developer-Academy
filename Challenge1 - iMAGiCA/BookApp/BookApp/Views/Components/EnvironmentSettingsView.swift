//
//  ModalView.swift
//  BookApp
//
//  Created by Alessandro Cacace on 21/10/25.
//

import Foundation
import SwiftUI

struct EnvironmentSettingsView: View {
     @Environment(\.dismiss) var dismiss // Allows dismissing the sheet
    
    @StateObject  var viewModel : EnvironmentViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State var temporaryEnvironment : EnvironmentModel
    @Binding var currentenvironment : EnvironmentModel

    var body: some View {
        // Use NavigationView for a title bar inside the modal
        NavigationView {
            
            ZStack{
                
                Color(.second)
                    .ignoresSafeArea()
                
                VStack {
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                        ForEach(viewModel.environments) { environment in
                            
                            EnvironmentButtonView(environment: environment, action: {
                                
                                viewModel.selectEnvironment( environment)
                                temporaryEnvironment = environment
                                
                            })
                            
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    

                    Spacer()
                    
                    
                }
                .navigationTitle("Environments")
                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Text("Environments")
//                            .font(.custom("EB Garamond", size: 50)) // personalize aqui
//                            .foregroundColor(.main)
//                            .fontWeight(.medium)
//                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            currentenvironment = temporaryEnvironment
                            dismiss()
                        }
                    }
                }
                
            }
            
        }
    }
}

#Preview {
   
  //  SettingsView(viewModel: EnvironmentViewModel.init(), environment: .constant(<#T##value: EnvironmentModel##EnvironmentModel#>))
}
