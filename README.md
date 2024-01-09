# Flyce Networking 

Simple networking abstraction over URL Session. Use your API client & requests in an easier way!

## How to use it

To use this package, you'd to have the following main things

### Requests 

Confer to the protocol `URLRequestable`. This is an example of it:

```
struct ExampleRequest: URLRequestable {
    let method: HTTPMethod
    var parameters: [String : Any]?
    let encoding: URLEncoding
    let scheme: String
    let domain: String
    let port: Int?
    let path: String
    
    init(symbol: String,
         apiKey: String) {
        self.method = .get
        self.parameters = [
            "symbol":symbol,
            "apikey":apiKey
        ]
        self.encoding = .json
        self.scheme = "https"
        self.domain = "www.alphavantage.co"
        self.path = "query"
        self.port = nil
    }
}
```

### Clients

The api client that you'll use in your logic layer would be something like this for instance:

```
// Note: JsonParser needs your domain object. The important thing is that it conforms to the `Decodable` protocol!

final class OverviewApiClient {
    
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }
    
    func getOverview(for symbol: String) async throws -> Overview {
        let request = ExampleRequest(symbol: symbol)
        let parser = JsonParser<Overview>() 
        return try await self.apiClient.call(request: request, parser: parser)
    }
}
```

