//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

struct ASFAppInfo: ASFAppInfoBehavior {

    var name: String? {
        Bundle.main.bundleIdentifier
    }

    var targetSDK: String {
#if os(iOS) || os(watchOS) || os(tvOS)
        return Bundle.main.infoDictionary?["MinimumOSVersion"] as? String ?? "Unknown"
#elseif os(macOS)
        return Bundle.main.infoDictionary?["LSMinimumSystemVersion"] as? String ?? "Unknown"
#else
        return "Unknown"
#endif
    }

    var version: String {
        let bundle = Bundle.main
        let buildVersion = bundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) ?? ""
        let bundleVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? ""
        return "\(bundleVersion)-\(buildVersion)"
    }

}
