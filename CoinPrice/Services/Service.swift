//
//  Service.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import RxSwift
import RxCocoa

protocol Service {

    func buildRequest(method: RequestType, path: String, params: [(String, String)]) -> Observable<Data>

    func buildAndMapRequest<T: Decodable>(method: RequestType, path: String, params: [(String, String)]) -> Observable<T>

}

extension Service {

    func buildRequest(method: RequestType, path: String, params: [(String, String)]) -> Observable<Data> {
        guard let url = prepareURL(method: method, path: path, params: params) else {
            return Observable.error(ServiceError.wrongPath)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.rx.data(request: request)
    }

    func buildAndMapRequest<T: Decodable>(method: RequestType, path: String, params: [(String, String)]) -> Observable<T> {
        return buildRequest(method: method, path: path, params: params)
            .map { (data) -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }

    private func prepareURL(method: RequestType, path: String, params: [(String, String)]) -> URL? {
        guard let url = URL(string: path) else {
            return nil
        }
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        if method == .get {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
        }
        return urlComponents.url
    }

}
