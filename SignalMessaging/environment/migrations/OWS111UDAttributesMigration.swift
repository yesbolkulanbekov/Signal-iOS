//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

import Foundation
import SignalServiceKit

@objc
public class OWS111UDAttributesMigration: OWSDatabaseMigration {

    // MARK: - Singletons

    private var networkManager: TSNetworkManager {
        return SSKEnvironment.shared.networkManager
    }

    // MARK: -

    // increment a similar constant for each migration.
    @objc
    class func migrationId() -> String {
        return "111"
    }

    override public func runUp(completion: @escaping OWSDatabaseMigrationCompletion) {
        Logger.debug("")
        BenchAsync(title: "UD Attributes Migration") { completeBenchmark in
            self.doMigration {
                completeBenchmark()
                completion()
            }
        }
    }

    private func doMigration(completion: @escaping OWSDatabaseMigrationCompletion) {
        return SignalServiceRestClient().updateAcountAttributes().then(execute: { _ in
            self.dbReadWriteConnection().readWrite { transaction in
                self.save(with: transaction)
            }
        })
            .always {
            completion()
        }.retainUntilComplete()
    }
}