import XCTest
@testable import Algorithms

final class HeapTests: XCTestCase {

    func testEmptyHeap() {
        var heap = Heap<Int>(sort: >)
        XCTAssertTrue(heap.isEmpty)
        XCTAssertEqual(heap.count, 0)
        XCTAssertNil(heap.peek)
        XCTAssertNil(heap.remove())
    }

    func testIsEmpty() {
        var heap = Heap<Int>(sort: <)
        XCTAssertTrue(heap.isEmpty)
        heap.insert(1)
        XCTAssertFalse(heap.isEmpty)
        heap.remove()
        XCTAssertTrue(heap.isEmpty)
        heap.insert(contentOf: [1, 3, 2])
        XCTAssertFalse(heap.isEmpty)
        XCTAssertTrue(isPermutation([1, 2, 3], heap.getNodes()))
        XCTAssertTrue(verifyMinHeap(heap))
        heap.remove()
        XCTAssertFalse(heap.isEmpty)
        XCTAssertTrue(isPermutation([2, 3], heap.getNodes()))
        XCTAssertTrue(verifyMinHeap(heap))
        heap.remove()
        heap.remove()
        XCTAssertTrue(heap.isEmpty)
        heap.remove()
        XCTAssertTrue(heap.isEmpty)
    }

    func testCount() {
        var heap = Heap<Int>(sort: >)
        XCTAssertEqual(0, heap.count)
        heap.insert(1)
        XCTAssertEqual(1, heap.count)
        heap.insert(contentOf: [6, 9, 3])
        XCTAssertEqual(4, heap.count)
        XCTAssertTrue(isPermutation([9, 6, 3, 1], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))
        heap.remove(at: 2)
        XCTAssertEqual(3, heap.count)
        XCTAssertTrue(isPermutation([9, 3, 1], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))
    }

    func testMaxHeapOneNode() {
        let heap = Heap<Int>(nodes: [10], sort: >)
        XCTAssertFalse(heap.isEmpty)
        XCTAssertEqual(heap.count, 1)
        XCTAssertEqual(heap.peek!, 10)
    }

    func testCreateMaxHeap() {
        let heap1 = Heap(nodes: [1, 2, 3, 4, 5, 6, 7], sort: >)
        XCTAssertFalse(heap1.isEmpty)
        XCTAssertEqual(heap1.count, 7)
        XCTAssertEqual(heap1.peek!, 7)
        XCTAssertTrue(isPermutation([1, 2, 3, 4, 5, 6, 7], heap1.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap1))

        let heap2 = Heap(nodes: [7, 6, 5, 4, 3, 2, 1], sort: >)
        XCTAssertFalse(heap2.isEmpty)
        XCTAssertEqual(heap2.count, 7)
        XCTAssertEqual(heap2.peek!, 7)
        XCTAssertTrue(isPermutation([1, 2, 3, 4, 5, 6, 7], heap2.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap2))


        let heap3 = Heap(nodes: [4, 1, 3, 2, 16, 9, 10, 14, 8, 7], sort: >)
        XCTAssertFalse(heap3.isEmpty)
        XCTAssertEqual(heap3.count, 10)
        XCTAssertEqual(heap3.peek!, 16)
        XCTAssertTrue(isPermutation([4, 1, 3, 2, 16, 9, 10, 14, 8, 7], heap3.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap3))


        let heap4 = Heap(nodes: [27, 17, 3, 16, 13, 10, 1, 5, 7, 12, 4, 8, 9, 0], sort: >)
        XCTAssertFalse(heap4.isEmpty)
        XCTAssertEqual(heap4.count, 14)
        XCTAssertEqual(heap4.peek!, 27)
        XCTAssertTrue(isPermutation([27, 17, 3, 16, 13, 10, 1, 5, 7, 12, 4, 8, 9, 0], heap4.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap4))
    }

    func testCreateMinHeap() {
        let heap1 = Heap(nodes: [1, 2, 3, 4, 5, 6, 7], sort: <)
        XCTAssertFalse(heap1.isEmpty)
        XCTAssertEqual(heap1.count, 7)
        XCTAssertEqual(heap1.peek!, 1)
        XCTAssertTrue(isPermutation([1, 2, 3, 4, 5, 6, 7], heap1.getNodes()))
        XCTAssertTrue(verifyMinHeap(heap1))

        let heap2 = Heap(nodes: [7, 6, 5, 4, 3, 2, 1], sort: <)
        XCTAssertFalse(heap2.isEmpty)
        XCTAssertEqual(heap2.count, 7)
        XCTAssertEqual(heap2.peek!, 1)
        XCTAssertTrue(isPermutation([1, 2, 3, 4, 5, 6, 7], heap2.getNodes()))
        XCTAssertTrue(verifyMinHeap(heap2))


        let heap3 = Heap(nodes: [4, 1, 3, 2, 16, 9, 10, 14, 8, 7], sort: <)
        XCTAssertFalse(heap3.isEmpty)
        XCTAssertEqual(heap3.count, 10)
        XCTAssertEqual(heap3.peek!, 1)
        XCTAssertTrue(isPermutation([4, 1, 3, 2, 16, 9, 10, 14, 8, 7], heap3.getNodes()))
        XCTAssertTrue(verifyMinHeap(heap3))

        let heap4 = Heap(nodes: [27, 17, 3, 16, 13, 10, 1, 5, 7, 12, 4, 8, 9, 0], sort: <)
        XCTAssertFalse(heap4.isEmpty)
        XCTAssertEqual(heap4.count, 14)
        XCTAssertEqual(heap4.peek!, 0)
        XCTAssertTrue(isPermutation([27, 17, 3, 16, 13, 10, 1, 5, 7, 12, 4, 8, 9, 0], heap4.getNodes()))
        XCTAssertTrue(verifyMinHeap(heap4))

    }

    fileprivate func randomArray(_ count: Int) -> [Int] {
        Array(0..<count).map { _ in Int(arc4random()) }
    }

    func testCreateRandomMaxHeap() {
        Array(1...40).forEach { count in
            let array = randomArray(count)
            let heap = Heap(nodes: array, sort: >)
            XCTAssertFalse(heap.isEmpty)
            XCTAssertEqual(heap.count, count)
        }
    }

    func testCreateRandomMinHeap() {
        Array(1...40).forEach { count in
            let array = randomArray(count)
            let heap = Heap(nodes: array, sort: <)
            XCTAssertFalse(heap.isEmpty)
            XCTAssertEqual(heap.count, count)
        }
    }

    func testRemoving() {
        var heap = Heap(nodes: [100, 50, 70, 10, 20, 60, 65], sort: >)
        XCTAssertTrue(isPermutation([100, 50, 70, 10, 20, 60, 65], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        //test index out of bounds
        let heap1 = heap.remove(at: 10)
        XCTAssertEqual(heap1, nil)
        XCTAssertTrue(isPermutation([100, 50, 70, 10, 20, 60, 65], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        let heap2 = heap.remove(at: 5)
        XCTAssertEqual(heap2, 60)
        XCTAssertTrue(isPermutation([100, 50, 70, 10, 20, 65], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        let heap3 = heap.remove(at: 4)
        XCTAssertEqual(heap3, 20)
        XCTAssertTrue(isPermutation([100, 50, 70, 10, 65], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))


        let heap4 = heap.remove(at: 4)
        XCTAssertEqual(heap4, 50)
        XCTAssertTrue(isPermutation([100, 70, 10, 65], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        let heap5 = heap.remove(at: 0)
        XCTAssertEqual(heap5, 100)
        XCTAssertTrue(isPermutation([70, 10, 65], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        XCTAssertEqual(heap.peek!, 70)
        let heap6 = heap.remove()
        XCTAssertEqual(heap6, 70)
        XCTAssertTrue(isPermutation([10, 65], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        XCTAssertEqual(heap.peek!, 65)
        let heap7 = heap.remove()
        XCTAssertEqual(heap7, 65)
        XCTAssertTrue(isPermutation([10], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        XCTAssertEqual(heap.peek!, 10)
        let heap8 = heap.remove()
        XCTAssertEqual(heap8, 10)
        XCTAssertTrue(isPermutation([], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        XCTAssertNil(heap.peek)
    }

    func testRemoveEmpty() {
        var heap = Heap<Int>(sort: >)
        let removed = heap.remove()
        XCTAssertNil(removed)
    }

    func testRemoveRoot() {
        var heap = Heap(nodes: [15, 13, 9, 5, 12, 8, 7, 4, 0, 6, 2, 1], sort: >)
        XCTAssertEqual(heap.peek!, 15)
        let heap1 = heap.remove()
        XCTAssertEqual(heap1, 15)
    }

    func testRemoveRandomItems() {
        Array(1...40).forEach { count in
            var array = randomArray(count)
            var heap = Heap(nodes: array, sort: >)

            let m = (count + 1) / 2
            for k in 1...m {
                let i = Int(arc4random_uniform(UInt32(count - k + 1)))
                let v = heap.remove(at: i)!
                let j = array.firstIndex(of: v)!
                array.remove(at: j)

                XCTAssertEqual(heap.count, array.count)
                XCTAssertEqual(heap.count, count - k)
            }
        }
    }

    func testInsert() {
        var heap = Heap(nodes: [15, 13, 9, 5, 12, 8, 7, 4, 0, 6, 2, 1], sort: >)

        heap.insert(10)
        XCTAssertEqual(15, heap.peek)
        XCTAssertTrue(isPermutation([15, 13, 9, 5, 12, 8, 7, 4, 0, 6, 2, 1, 10], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        heap.insert(20)
        XCTAssertEqual(20, heap.peek)
        XCTAssertTrue(isPermutation([15, 13, 9, 5, 12, 8, 7, 4, 0, 6, 2, 1, 10, 20], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        heap.insert(19)
        XCTAssertEqual(20, heap.peek)
        XCTAssertTrue(isPermutation([15, 13, 9, 5, 12, 8, 7, 4, 0, 6, 2, 1, 10, 20, 19], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        XCTAssertEqual(20, heap.remove())
        XCTAssertEqual(19, heap.peek)
        XCTAssertTrue(isPermutation([15, 13, 9, 5, 12, 8, 7, 4, 0, 6, 2, 1, 10, 19], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))
    }

    func testInsertArrayAndRemove() {
        var heap = Heap<Int>(sort: >)
        heap.insert(contentOf: [1, 3, 2, 7, 5, 9])

        XCTAssertEqual(9, heap.remove())
        XCTAssertEqual(7, heap.remove())
        XCTAssertEqual(5, heap.remove())
        XCTAssertEqual(3, heap.remove())
        XCTAssertEqual(2, heap.remove())
        XCTAssertEqual(1, heap.remove())
        XCTAssertNil(heap.remove())
    }

    func testReplace() {
        var heap = Heap(nodes: [16, 14, 10, 8, 7, 9, 3, 2, 4, 1], sort: >)

        heap.replace(at: 5, with: 20)
        XCTAssertEqual(20, heap.peek!)
        XCTAssertTrue(isPermutation([16, 14, 10, 8, 7, 20, 3, 2, 4, 1], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))

        //test index out of bounds
        heap.replace(at: 20, with: 21)
        XCTAssertEqual(20, heap.peek)
        XCTAssertTrue(isPermutation([16, 14, 10, 8, 7, 20, 3, 2, 4, 1], heap.getNodes()))
        XCTAssertTrue(verifyMaxHeap(heap))
    }
}

private func verifyMaxHeap(_ heap: Heap<Int>) -> Bool {
    for index in 0..<heap.count {
        let left = HeapHelper.leftChildIndex(ofIndex: index)
        let right = HeapHelper.rightChildIndex(ofIndex: index)
        let parent = HeapHelper.parentIndex(ofIndex: index)
        if left < heap.count, heap.getNodes()[index] < heap.getNodes()[left] { return false }
        if right < heap.count, heap.getNodes()[index] < heap.getNodes()[right] { return false }
        if index > 0, heap.getNodes()[parent] < heap.getNodes()[index] { return false }
    }
    return true
}

private func verifyMinHeap(_ heap: Heap<Int>) -> Bool {
    for index in 0..<heap.count {
        let left = HeapHelper.leftChildIndex(ofIndex: index)
        let right = HeapHelper.rightChildIndex(ofIndex: index)
        let parent = HeapHelper.parentIndex(ofIndex: index)
        if left < heap.count, heap.getNodes()[index] > heap.getNodes()[left] { return false }
        if right < heap.count, heap.getNodes()[index] > heap.getNodes()[right] { return false }
        if index > 0, heap.getNodes()[parent] > heap.getNodes()[index] { return false }
    }
    return true
}

private func isPermutation(_ lhsArray: [Int], _ rhsArray: [Int]) -> Bool {
    var lhs = lhsArray
    var rhs = rhsArray
    if lhs.count != rhs.count { return false }
    while lhs.count > 0 {
        if let index = rhs.firstIndex(of: lhs[0]) {
            lhs.remove(at: 0)
            rhs.remove(at: index)
        } else {
            return false
        }
    }
    return rhs.count == 0
}

private extension Heap where Node == Int {

    func getNodes() -> [Int] {
        description
            .prefix(description.count - 1)
            .suffix(description.count - 2)
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(Int.init)
    }
}
