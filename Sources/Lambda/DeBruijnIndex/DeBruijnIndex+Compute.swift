//
// DeBruijnIndex+Compute.swift
// Lambda
//
// Created by sabotzs on 16.07.2024
//

import Foundation

extension DeBruijnIndex {
    func compute() -> DeBruijnIndex {
        guard case let .application(function, argument) = self,
            case let .abstraction(body) = function
        else {
            return self
        }
        return body
            .substituting(0, with: argument.shifted(cutoff: 0, by: 1))
            .shifted(cutoff: 0, by: -1)
    }
}
