import XCTest
@testable import Algorithms

private let enqueueCount = 100000
private let dequeueCount = enqueueCount

final class QueueTests: XCTestCase {

    func testEmpty() {
        var queue = Queue<Int>()
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
        XCTAssertNil(queue.dequeue())
    }

    func testOneElement() {
        var queue = Queue<Int>()

        queue.enqueue(123)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.front, 123)

        let result = queue.dequeue()
        XCTAssertEqual(result, 123)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
        XCTAssertNil(queue.dequeue())
    }

    func testTwoElements() {
        var queue = Queue<Int>()

        queue.enqueue(123)
        queue.enqueue(456)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.front, 123)

        let result1 = queue.dequeue()
        XCTAssertEqual(result1, 123)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.front, 456)

        let result2 = queue.dequeue()
        XCTAssertEqual(result2, 456)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
        XCTAssertNil(queue.dequeue())
    }

    func testMakeEmpty() {
        var queue = Queue<Int>()

        queue.enqueue(123)
        queue.enqueue(456)
        XCTAssertNotNil(queue.dequeue())
        XCTAssertNotNil(queue.dequeue())
        XCTAssertNil(queue.dequeue())

        queue.enqueue(789)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.front, 789)

        let result = queue.dequeue()
        XCTAssertEqual(result, 789)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
        XCTAssertNil(queue.dequeue())
    }

    func testPerformance() {
        var queue = Queue<Int>()
        measure {
            Array(0..<enqueueCount).forEach { _ in queue.enqueue(123) }
            Array(0..<dequeueCount).forEach { _ in queue.dequeue() }
        }
    }
}

final class SlowQueueTests: XCTestCase {

    func testEmpty() {
        var queue = SlowQueue<Int>()
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
        XCTAssertNil(queue.dequeue())
    }

    func testOneElement() {
        var queue = SlowQueue<Int>()

        queue.enqueue(123)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.front, 123)

        let result = queue.dequeue()
        XCTAssertEqual(result, 123)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
        XCTAssertNil(queue.dequeue())
    }

    func testTwoElements() {
        var queue = SlowQueue<Int>()

        queue.enqueue(123)
        queue.enqueue(456)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.front, 123)

        let result1 = queue.dequeue()
        XCTAssertEqual(result1, 123)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.front, 456)

        let result2 = queue.dequeue()
        XCTAssertEqual(result2, 456)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
        XCTAssertNil(queue.dequeue())
    }

    func testMakeEmpty() {
        var queue = SlowQueue<Int>()

        queue.enqueue(123)
        queue.enqueue(456)
        XCTAssertNotNil(queue.dequeue())
        XCTAssertNotNil(queue.dequeue())
        XCTAssertNil(queue.dequeue())

        queue.enqueue(789)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.front, 789)

        let result = queue.dequeue()
        XCTAssertEqual(result, 789)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.front, nil)
        XCTAssertNil(queue.dequeue())
    }

    func testPerformance() {
        var queue = SlowQueue<Int>()
        measure {
            Array(0..<enqueueCount).forEach { _ in queue.enqueue(123) }
            Array(0..<dequeueCount).forEach { _ in queue.dequeue() }
        }
    }
}
