//
//  Apollo+GitStalk.swift
//  Repose
//
//  Created by Derrick Hathaway on 4/3/18.
//  Copyright © 2018 Derrick Hathaway. All rights reserved.
//

import Foundation
import Apollo

private let _client: ApolloClient = {
  let tokenFileURL = Bundle.main.url(forResource: "token", withExtension: "private")
  let token = (try! String(contentsOf: tokenFileURL!))
    .trimmingCharacters(in: .whitespacesAndNewlines)
  
  var config = URLSessionConfiguration.default
  config.httpAdditionalHeaders = [
    "Authorization": "token \(token)",
  ]
  let transport = HTTPNetworkTransport(
    url: URL(string: "https://api.github.com/graphql")!,
    configuration: config,
    sendOperationIdentifiers: false
  )
  
  return ApolloClient(networkTransport: transport)
}()

extension ApolloClient {
  static var gitStalk: ApolloClient {
    return _client
  }
}
