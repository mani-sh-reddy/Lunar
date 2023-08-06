// MIT License
//
// Copyright (c) 2023 Lee Kah Seng
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

final class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}

    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString: Any] as CFDictionary

        // Add data in query to keychain
        let status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as [CFString: Any] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
    }

    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true,
        ] as [CFString: Any] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        return result as? Data
    }

    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString: Any] as CFDictionary

        // Delete item from keychain
        SecItemDelete(query)
    }

    func clearKeychain() {
        // Create a dictionary to specify the items to delete (in this case, we delete all items)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
        ]

        // Delete the items
        let status = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess {
            print("Keychain cleared successfully.")
        } else {
            print("Error occurred while clearing the keychain: \(status)")
        }
    }

    func generateDebugString(service: String) -> String {
        let query = [
            kSecAttrService: service,
            kSecMatchLimit: kSecMatchLimitAll,
            kSecReturnAttributes: true,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData as String: true,
        ] as [AnyHashable: Any] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

//        print("KEYCHAIN DEBUG RESULT \(String(describing: result))")
        return result.debugDescription
    }
}

extension KeychainHelper {
    func save(_ item: some Codable, service: String, account: String) {
        do {
            // Encode as JSON data and save in keychain
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)

        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }

    func read<T>(service: String, account: String, type: T.Type) -> T? where T: Codable {
        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            return nil
        }

        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
}
