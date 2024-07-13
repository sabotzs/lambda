//
// LambdaExpression+FreeVariables.swift
// Lambda
//
// Created by sabotzs on 13.07.2024
//

extension LambdaExpression {
    var freeVariables: Set<String> {
        getFreeVariables(lambda: self, free: [], bound: [])
    }

    private func getFreeVariables(
        lambda: LambdaExpression,
        free: Set<String>,
        bound: Set<String>
    ) -> Set<String> {
        switch lambda {
        case let .variable(name):
            if !bound.contains(name) {
                return free.union([name])
            }
            return free
        case let .abstraction(variable, body):
            return getFreeVariables(
                lambda: body,
                free: free,
                bound: bound.union([variable])
            )
        case let .application(function, argument):
            let functionFreeVariables = getFreeVariables(
                lambda: function,
                free: free,
                bound: bound
            )
            let argumentFreeVariables = getFreeVariables(
                lambda: argument,
                free: free,
                bound: bound
            )
            return functionFreeVariables.union(argumentFreeVariables)
        }
    }
}
