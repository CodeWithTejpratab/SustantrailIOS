//
//  OnboardingViewModel.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 10/13/26.
//

import Foundation
internal import Combine

final class OnboardingViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    
    var onUsernameChange: (String) -> Void = { _ in }
    var onPasswordChange: (String) -> Void = { _ in }
    var onSignUpClick: () -> Void = { }
    var onClick: () -> Void = { }
    
}
