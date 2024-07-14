//
// DeBruijnIndex+Equatable.swift
// Lambda
//
// Created by sabotzs on 14.07.2024
//

extension DeBruijnIndex: Equatable {
    static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.variable(lIndex), .variable(rIndex)):
            return lIndex == rIndex
        case let (.abstraction(lBody), .abstraction(rBody)):
            return lBody == rBody
        case let (.application(lFunc, lArg), .application(rFunc, rArg)):
            return lFunc == rFunc && lArg == rArg
        default:
            return false
        }
    }
}
