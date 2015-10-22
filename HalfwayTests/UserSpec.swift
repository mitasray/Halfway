//
//  UserSpec.swift
//  Halfway
//
//  Created by Kevin Arifin on 10/21/15.
//  Copyright © 2015 mitas.ray. All rights reserved.
//

import Quick
import Nimble
@testable import Halfway

class UserSpec: QuickSpec {
    override func spec() {
        describe("columns") {
            let user_attributes = [
                "id": 15,
                "username": "user",
                "email": "foo@bar.com",
                "latitude": 100.5,
                "longitude": 10.5,
            ]
            let user = User(value: user_attributes)
            
            it("is initialized with the correct value") {
                expect(user.id).to(equal(15))
                expect(user.username).to(equal("user"))
                expect(user.email).to(equal("foo@bar.com"))
                expect(user.latitude).to(equal(100.5))
                expect(user.longitude).to(equal(10.5))
            }
        }
    }
}
