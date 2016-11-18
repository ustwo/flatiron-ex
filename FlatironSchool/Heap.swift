//
//  Heap.swift
//  FlatironSchool
//
//  Created by Matt Isaacs on 10/30/16.
//  Copyright © 2016 Ustwo. All rights reserved.
//

import Foundation

public enum HeapType {
    case max
    case min
}

public class Heap<T: Comparable> {
    public let type: HeapType
    var backing: Array<T>

    public var count: Int {
        return backing.count
    }

    public var top: T? {
        return backing.first
    }

    public  init(type: HeapType, array: Array<T>) {
        self.type = type
        self.backing = array

        var idx = backing.count / 2

        while idx >= 0 {
            bubbleDown(index: idx)
            idx -= 1
        }
    }

    public init(type: HeapType) {
        self.type = type
        self.backing  = []
    }

    public func insert(_ item: T) {
        backing.append(item)
        bubbleUp(index: backing.endIndex - 1)
    }

    public func deleteTop() -> T? {
        if let first = top {
            backing[0] = backing[backing.endIndex - 1]
            bubbleDown(index: 0)
            backing.removeLast()
            return first
        }
        return nil
    }

    func bubbleDown(index: Int) {
        let leftChildIndex = 2 * index + 1
        let rightChildIndex = 2 * index + 2
        var top = index

        let comparison: (T, T) -> Bool = type == .min ? (>) : (<)

        if leftChildIndex < backing.count {
            if comparison(backing[top], backing[leftChildIndex]) {
                top = leftChildIndex
            }
        }

        if rightChildIndex < backing.count {
            if comparison(backing[top], backing[rightChildIndex]) {
                top = rightChildIndex
            }
        }

        if top != index {
            backing.swap(indexA: top, indexB: index)
            self.bubbleDown(index: top)
        }
    }

    func bubbleUp(index: Int) {
        let parentIndex = index % 2 == 0 ? (index / 2) - 1 : (index - 1) / 2
        let comparison: (T, T) -> Bool = type == .min ? (<) : (>)

        if parentIndex >= 0 {
            if comparison(backing[index], backing[parentIndex]) {
                backing.swap(indexA: index, indexB: parentIndex)
                bubbleUp(index: parentIndex)
            }
        }
    }
}
