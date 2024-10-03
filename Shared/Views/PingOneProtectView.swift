//
//  PingOneProtectView.swift
//  BXFinance
//
//  Created by Eric Anderson on 7/18/23.
//

import SwiftUI
import PingOneSignals

struct PingOneProtectView: View {
    
    private let apiBaseUrl: String
    
    @State var username = ""
    @State var submitted = false
    @State var submitting = false
    @State var riskAssessment: String? = nil
    
    @FocusState private var focusedField: Bool
    
    init(apiBaseUrl: String) {
        self.apiBaseUrl = apiBaseUrl
    }
    
    var body: some View {
        if submitting {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        } else {
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
                    .submitLabel(.go)
                    .focused($focusedField)
                    .onSubmit {
                        submitUsername()
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                focusedField = false
                            }.foregroundColor(.blue)
                        }
                    }
                
                if submitted && username.count < 2 {
                    Text("Username is required as must be at least 2 characters")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], 30)
                }
                
                BXButton(text: "Get Risk Evaluation") {
                    submitUsername()
                }
                .padding(.top, 8)
                .disabled(submitting)
            }
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
        dismissKeyboard()
        submitted = true
        
        if username.count < 2 {
            return
        }
    
        guard let signals = PingOneSignals.sharedInstance() else {
            print("No PingOneSignlas instance available")
            return
        }
        
        submitting = true
        
        signals.getData { data, error in
            if let error {
                print("An error occurred getting signals data \(error)")
                submitting = false
                return
            }
            
            guard let data else {
                print("Signals data is nil")
                submitting = false
                return
            }
            
            Task {
                do {
                    riskAssessment = try await ProtectClient.getRiskEvaluation(username: username, riskData: data, apiBaseUrl: apiBaseUrl)
                    submitting = false
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}

struct PingOneProtectView_Previews: PreviewProvider {
    static var previews: some View {
        PingOneProtectView(apiBaseUrl: "")
    }
}
