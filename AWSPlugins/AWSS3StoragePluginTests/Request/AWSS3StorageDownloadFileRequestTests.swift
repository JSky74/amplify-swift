//
// Copyright 2018-2019 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import AWSS3StoragePlugin

class AWSS3StorageDownloadFileRequestTests: XCTestCase {

    let testTargetIdentityId = "TestTargetIdentityId"
    let testKey = "TestKey"
    let testPluginOptions: Any? = [:]
    let testURL = URL(fileURLWithPath: "path")

    func testValidateSuccess() {
        let request = AWSS3StorageDownloadFileRequest(accessLevel: .protected,
                                                      targetIdentityId: testTargetIdentityId,
                                                      key: testKey,
                                                      local: testURL,
                                                      pluginOptions: testPluginOptions)

        let storageErrorOptional = request.validate()

        XCTAssertNil(storageErrorOptional)
    }

    func testValidateEmptyTargetIdentityIdError() {
        let request = AWSS3StorageDownloadFileRequest(accessLevel: .protected,
                                                      targetIdentityId: "",
                                                      key: testKey,
                                                      local: testURL,
                                                      pluginOptions: testPluginOptions)

        let storageErrorOptional = request.validate()

        guard let error = storageErrorOptional else {
            XCTFail("Missing StorageDownloadFile")
            return
        }

        guard case .validation(let field, let description, let recovery) = error else {
            XCTFail("Error does not match validation error")
            return
        }

        XCTAssertEqual(field, StorageErrorConstants.identityIdIsEmpty.field)
        XCTAssertEqual(description, StorageErrorConstants.identityIdIsEmpty.errorDescription)
        XCTAssertEqual(recovery, StorageErrorConstants.identityIdIsEmpty.recoverySuggestion)
    }

    func testValidateTargetIdentityIdWithPrivateAccessLevelError() {
        let request = AWSS3StorageDownloadFileRequest(accessLevel: .private,
                                                      targetIdentityId: testTargetIdentityId,
                                                      key: testKey,
                                                      local: testURL,
                                                      pluginOptions: testPluginOptions)

        let storageErrorOptional = request.validate()

        guard let error = storageErrorOptional else {
            XCTFail("Missing StorageDownloadFile")
            return
        }

        guard case .validation(let field, let description, let recovery) = error else {
            XCTFail("Error does not match validation error")
            return
        }

        XCTAssertEqual(field, StorageErrorConstants.invalidAccessLevelWithTarget.field)
        XCTAssertEqual(description, StorageErrorConstants.invalidAccessLevelWithTarget.errorDescription)
        XCTAssertEqual(recovery, StorageErrorConstants.invalidAccessLevelWithTarget.recoverySuggestion)
    }

    func testValidateKeyIsEmptyError() {
        let request = AWSS3StorageDownloadFileRequest(accessLevel: .protected,
                                                      targetIdentityId: testTargetIdentityId,
                                                      key: "",
                                                      local: testURL,
                                                      pluginOptions: testPluginOptions)

        let storageErrorOptional = request.validate()

        guard let error = storageErrorOptional else {
            XCTFail("Missing StorageDownloadFile")
            return
        }

        guard case .validation(let field, let description, let recovery) = error else {
            XCTFail("Error does not match validation error")
            return
        }

        XCTAssertEqual(field, StorageErrorConstants.keyIsEmpty.field)
        XCTAssertEqual(description, StorageErrorConstants.keyIsEmpty.errorDescription)
        XCTAssertEqual(recovery, StorageErrorConstants.keyIsEmpty.recoverySuggestion)
    }
}
