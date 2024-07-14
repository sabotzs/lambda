//
// LambdaExpression+FreeVariables.swift
// Lambda
//
// Created by sabotzs on 14.07.2024
//

extension LambdaExpression {
    var freeVariables: Set<String> {
        getFreeVariables(bound: [])
    }

    private func getFreeVariables(bound: Set<String>) -> Set<String> {
        switch self {
        case let .variable(name):
            return bound.contains(name) ? [] : [name]
        case let .abstraction(variable, body):
            return body.getFreeVariables(bound: bound.union([variable]))
        case let .application(function, argument):
            let functionFree = function.getFreeVariables(bound: bound)
            let argumentFree = argument.getFreeVariables(bound: bound)
            return functionFree.union(argumentFree)
        }
    }
}