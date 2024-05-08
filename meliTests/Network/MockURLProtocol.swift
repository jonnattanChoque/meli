//
//  MockURLProtocol.swift
//  meliTests
//
//  Created by jonnattan Choque on 7/05/24.
//

import Alamofire

class MockURLProtocol: URLProtocol {
    static var mockResponse: (HTTPURLResponse, Data)?
    
    override class func canInit(with request: URLRequest) -> Bool {
        // Interceptamos todas las solicitudes
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // Simulamos la respuesta utilizando los datos y la respuesta falsos
        if let (response, data) = MockURLProtocol.mockResponse {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
