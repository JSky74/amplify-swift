//
// Copyright 2018-2019 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSS3
import Amplify
import AWSMobileClient

public class AWSS3StorageService: AWSS3StorageServiceBehaviour {

    var transferUtility: AWSS3TransferUtilityBehavior!
    var preSignedURLBuilder: AWSS3PreSignedURLBuilderBehavior!
    var awsS3: AWSS3Behavior!
    var identifier: String!
    var bucket: String!

    public init() {

    }

    func configure(region: AWSRegionType,
                   bucket: String,
                   cognitoCredentialsProvider: AWSCognitoCredentialsProvider,
                   identifier: String) throws {
        let serviceConfigurationOptional = AWSServiceConfiguration(region: region,
                                                                   credentialsProvider: cognitoCredentialsProvider)

        guard let serviceConfiguration = serviceConfigurationOptional else {
            throw PluginError.pluginConfigurationError("T##ErrorDescription", "T##RecoverySuggestion")
        }

        AWSS3TransferUtility.register(with: serviceConfiguration, forKey: identifier)
        AWSS3PreSignedURLBuilder.register(with: serviceConfiguration, forKey: identifier)
        AWSS3.register(with: serviceConfiguration, forKey: identifier)

        let transferUtilityOptional = AWSS3TransferUtility.s3TransferUtility(forKey: identifier)
        guard let transferUtility = transferUtilityOptional else {
            throw PluginError.pluginConfigurationError("fail to create transferUtiltiy", "failed")
        }

        let preSignedURLBuilder = AWSS3PreSignedURLBuilderImpl(
            AWSS3PreSignedURLBuilder.s3PreSignedURLBuilder(forKey: identifier))
        let awsS3 = AWSS3Impl(AWSS3.s3(forKey: identifier))

        configure(transferUtility: AWSS3TransferUtilityImpl(transferUtility),
                  preSignedURLBuilder: preSignedURLBuilder,
                  awsS3: awsS3,
                  bucket: bucket,
                  identifier: identifier)
    }

    func configure(transferUtility: AWSS3TransferUtilityBehavior,
                   preSignedURLBuilder: AWSS3PreSignedURLBuilderBehavior,
                   awsS3: AWSS3Behavior,
                   bucket: String,
                   identifier: String) {
        self.transferUtility = transferUtility
        self.preSignedURLBuilder = preSignedURLBuilder
        self.awsS3 = awsS3
        self.bucket = bucket
        self.identifier = identifier
    }

    func reset() {
        AWSS3TransferUtility.remove(forKey: identifier)
        transferUtility = nil
        AWSS3PreSignedURLBuilder.remove(forKey: identifier)
        preSignedURLBuilder = nil
        AWSS3.remove(forKey: identifier)
        awsS3 = nil
        bucket = nil
        identifier = nil
    }

    func getEscapeHatch() -> AWSS3 {
        return awsS3.getS3()
    }
}
