//
// Lambda.swift
// Lambda
//
// Created by sabotzs on 12.07.2024
//

class Lambda {
    let lambda: LambdaExpression
    private(set) lazy var freeVariables: Set<String> = {
        getFreeVariables(lambda: lambda, free: [], bound: [])
    }()

    init(_ lambda: LambdaExpression) {
        self.lambda = lambda
    }
}

// MARK: Free variables
extension Lambda {
    private func getVariables(
        lambda: LambdaExpression,
        all: inout Set<String>,
        bound: inout Set<String>
    ) {
        switch lambda {
        case let .variable(name):
            all.insert(name)
        case let .abstraction(variable, body):
            all.insert(variable)
            bound.insert(variable)
            getVariables(lambda: body, all: &all, bound: &bound)
        case let .application(function, argument):
            getVariables(lambda: function, all: &all, bound: &bound)
            getVariables(lambda: argument, all: &all, bound: &bound)
        }
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

