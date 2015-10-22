//
//  LoginControllerSpec.swift
//  Halfway
//
//  Created by Kevin Arifin on 10/21/15.
//  Copyright © 2015 mitas.ray. All rights reserved.
//

import Quick
import Nimble
@testable import Halfway

class LoginControllerSpec: QuickSpec {
    override func spec() {
        var loginController: LoginController!
        beforeEach {
            loginController = LoginController()
        }
    }
}
