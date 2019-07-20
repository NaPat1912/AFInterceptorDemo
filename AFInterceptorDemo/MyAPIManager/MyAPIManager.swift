
import Foundation
import Alamofire

fileprivate let SP_CLIENT_ID:String = "0acf4351408c4a51b188c5e984922eed"
fileprivate let SP_CLIENT_SECRET: String = "ad8dade03beb4c6e9971bd6a1b2c37e8"


class MyAPIManager: NSObject {
    static let shared = MyAPIManager()
    
    static let baseUrl: String = "https://api.spotify.com/v1"
    var mainSession: Session!
    let tokenSession = Alamofire.Session()
    var authInterceptor: OAuthInterceptor!
    
    private override init(){
        let configuration = URLSessionConfiguration.default
        self.authInterceptor = OAuthInterceptor(baseURLString: MyAPIManager.baseUrl)
        mainSession = Session(configuration: configuration, interceptor: self.authInterceptor)
    }
    
    func playlistFromG8(){
        mainSession.request("\(MyAPIManager.baseUrl)/users/12100663099/playlists").validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseJSON { response  in
            switch response.result{
            case .failure(let f):
                print(">> ERROR:",f)
            case .success(let s):
                print(">> SUCCESS: ",s)
            }
        }
    }
    
    // MARK: - Private - Refresh Tokens
    public func refreshTokens(completion: @escaping (_ succeeded: Bool, _ accessToken: String?) -> Void) {
        let urlString = "https://accounts.spotify.com/api/token"
        let parameters: [String:String] = [
            "grant_type": "client_credentials"
        ]
        let basicAuthHeader: HTTPHeader = HTTPHeader.authorization(username: SP_CLIENT_ID, password: SP_CLIENT_SECRET)
        let contentTypeHeader: HTTPHeader = HTTPHeader.contentType("application/x-www-form-urlencoded")
        let authHeaders = HTTPHeaders(arrayLiteral: basicAuthHeader,contentTypeHeader)
        print("🔐 - Retrieving Token")
        
        tokenSession.request(urlString, method: .post,
                               parameters: parameters,
                               encoder: URLEncodedFormParameterEncoder.default ,
                               headers: authHeaders).validate(contentType: ["application/json"]).responseJSON {[weak self] response  in
                                guard let strongSelf = self else { return }
                                if
                                    let json = response.value as? [String: Any],
                                    let accessToken = json["access_token"] as? String
                                {
                                    print("🌕 - New Token: \(accessToken)")
                                    completion(true, accessToken)
                                } else {
                                    completion(false, nil)
                                }
        }
    }
}

