//
//  EmailToUsernameConverter.swift
//  Lunar
//
//  Created by Mani on 29/07/2023.
//

import Alamofire
import Foundation
import SwiftUI

class EmailToUsernameConverter: ObservableObject {
    @Published var username: String = ""
    @Published var isLoading: Bool = false

    private var userEmail: String

    private var endpoint: URLComponents {
        // URLBuilder should be properly defined and implemented
        URLBuilder(
            endpointPath: "/api/v3/site",
            authUser: userEmail
        ).buildURL()
    }

    init(userEmail: String) {
        self.userEmail = userEmail
    }

    func convertEmailToUsername(completion: @escaping (String?) -> Void) {
        guard !isLoading else { return }

        isLoading = true

        // Use Alamofire to make a network request
        AF.request(endpoint)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: SiteModel.self) { response in
                switch response.result {
                case let .success(result):
                    // Assuming that the API response contains the username
                    self.username = result.myUser.localUserView.person.name
                    self.isLoading = false
                    completion(self.username) // Pass the converted username to the completion closure

                case let .failure(error):
                    print("EmailToUsernameConverter ERROR: \(error): \(error.errorDescription ?? "")")
                    self.isLoading = false
                    completion(nil) // Notify about failure by passing nil to the completion closure
                }
            }
    }
}
