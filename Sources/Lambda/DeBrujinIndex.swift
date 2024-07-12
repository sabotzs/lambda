//
// DeBrujinIndex.swift
// Lambda
//
// Created by sabotzs on 12.07.2024
//

enum DeBrujinIndex {
    case variable(index: UInt)
    indirect case abstraction(body: DeBrujinIndex)
    indirect case application(function: DeBrujinIndex, argument: DeBrujinIndex)
}

extension DeBrujinIndex: Equatable {
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
