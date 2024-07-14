//
// DeBruijnIndex.swift
// Lambda
//
// Created by sabotzs on 12.07.2024
//

enum DeBruijnIndex {
    case variable(index: UInt)
    indirect case abstraction(body: DeBruijnIndex)
    indirect case application(function: DeBruijnIndex, argument: DeBruijnIndex)
}
