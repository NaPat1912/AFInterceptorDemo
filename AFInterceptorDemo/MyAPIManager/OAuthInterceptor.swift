//
//  OAuthHandler.swift
//  GenerateMetal-iOS
//
//  Created by Omar Juarez Ortiz on 2019-07-18.
//  Copyright © 2019 Generate Software Inc. All rights reserved.
//

import Foundation
import Alamofire

class OAuthInterceptor: RequestInterceptor {
    private var baseURLString: String
    public var accessToken: String?
    
    // MARK: - Initialization
    
    public init(baseURLString: String) {
        self.baseURLString = baseURLString
    }
    
    // MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        //completion(.success(urlRequest))
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
            var adaptedRequest = urlRequest

            if let sToken = accessToken {
                adaptedRequest.setValue("Bearer \(sToken)", forHTTPHeaderField: "Authorization")
                print("🔑 >> AuthToken appended: \(urlString)")
            }else{
                print("🔑❌ >> No Token appended: \(urlString)")
            }
            completion(.success(adaptedRequest))
        }
        completion(.success(urlRequest))
    }
    
    // MARK: - RequestRetrier
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        dump(request.request?.allHTTPHeaderFields!) //Prints twice because for some reason, I read that 401 causes to repeat the request automatically no matter what. But still no Authorization Header that I set in adapt()
        completion(.doNotRetry)
    }
    
    
    
}
