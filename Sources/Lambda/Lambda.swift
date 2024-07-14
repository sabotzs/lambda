//
// Lambda.swift
// Lambda
//
// Created by sabotzs on 12.07.2024
//

class Lambda {
    let lambda: LambdaExpression
    private(set) lazy var freeVariables: Set<String> = {
        lambda.freeVariables
    }()
    private(set) lazy var deBruijnIndex: DeBruijnIndex = {
        lambda.deBruijnIndex
    }()

    init(_ lambda: LambdaExpression) {
        self.lambda = lambda
    }
}
