//
// DeBruijnIndex+Shifting.swift
// Lambda
//
// Created by sabotzs on 14.07.2024
//

extension DeBruijnIndex {
    func shifted(cutoff: UInt, by amount: Int) -> DeBruijnIndex {
        switch self {
        case let .variable(index):
            let newIndex = if index < cutoff {
                index
            } else {
                UInt(bitPattern: Int(bitPattern: index) + amount)
            }
            return .variable(index: newIndex)
        case let .abstraction(body):
            let shiftedBody = body.shifted(cutoff: cutoff + 1, by: amount)
            return .abstraction(body: shiftedBody)
        case let .application(function, argument):
            let shiftedFunction = function.shifted(cutoff: cutoff, by: amount)
            let shiftedArgument = argument.shifted(cutoff: cutoff, by: amount)
            return .application(function: shiftedFunction, argument: shiftedArgument)
        }
    }
}
