//
//  PingOneProtectView.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/18/23.
//

import SwiftUI
import PingOneSignals

struct PingOneProtectView: View {
    
    @ObservedObject var homeModel: FinanceHomeViewModel
    @State var username = ""
    @State var submitted = false
    @State var submitting = false
    @State var riskAssessment: String? = nil
    
    init(homeModel: FinanceHomeViewModel) {
        self.homeModel = homeModel
    }
    
    var body: some View {
        if let riskAssessment {
            ScrollView {
                Text("Risk Assessment Response: \(riskAssessment)").background(.white)
            }

            BXButton(text: "Clear Assessment") {
                resetView()
            }
            .padding(.bottom, 50)
        } else {
            TextField("BXFinance Username", text: $username)
                .textInputAutocapitalization(.never)
                .tint(.primaryColor)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 30)
                .padding(.top, 50)
                .submitLabel(.done)
                .onSubmit {
                    submitUsername()
                }
            
            if submitted && username.count < 2 {
                Text("Username is required as must be at least 2 characters")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 30)
            }

            BXButton(text: "Get Risk Evaluation") {
                // Dismiss the keyboard now else it will wait until the TextField is removed resulting in an unsighly animation
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                submitUsername()
            }
            .padding(.top, 8)
            .disabled(submitting)
        }

        Spacer()
    }
    
    func getResultLabel(resultName: String, result: String, score: Int) -> Text {
        return Text("\(resultName): \(result), Score: \(score)").foregroundColor(.white)
    }
    
    func resetView() {
        self.riskAssessment = nil
        self.submitted = false
        self.submitting = false
        self.username = ""
    }
    
    func submitUsername() {
        submitted = true
        
        if username.count < 2 {
            return
        }
    
        guard let signals = PingOneSignals.sharedInstance() else {
            print("No PingOneSignlas instance available")
            return
        }
        
        signals.getData { data, error in
            if let error {
                print("An error occurred getting signals data \(error)")
                return
            }
            
            guard let data else {
                print("Signals data is nil")
                return
            }
            
            Task {
                do {
                    riskAssessment = try await NetworkCalls.getRiskEvaluation(username: username, riskData: data)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}

struct PingOneProtectView_Previews: PreviewProvider {
    static var previews: some View {
        PingOneProtectView(homeModel: FinanceHomeViewModel.shared)
    }
}
