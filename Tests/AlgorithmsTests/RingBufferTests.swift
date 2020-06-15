import XCTest
@testable import Algorithms

private let readCount = 100000
private let writeCount = readCount

final class RingBufferTests: XCTestCase {

    func testEmpty() {
        let buffer = RingBuffer<Int>(capacity: 10)
        XCTAssertTrue(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
    }

    func testOneElement() {
        var buffer = RingBuffer<Int>(capacity: 10)
        XCTAssertTrue(buffer.write(123))
        XCTAssertFalse(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
        XCTAssertEqual(buffer.read(), 123)
        XCTAssertTrue(buffer.isEmpty)
        XCTAssertNil(buffer.read())
        XCTAssertTrue(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
    }

    func testTwoElements() {
        var buffer = RingBuffer<Int>(capacity: 10)
        XCTAssertTrue(buffer.write(123))
        XCTAssertTrue(buffer.write(456))
        XCTAssertFalse(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
        XCTAssertEqual(buffer.read(), 123)
        XCTAssertFalse(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
        XCTAssertEqual(buffer.read(), 456)
        XCTAssertTrue(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
        XCTAssertNil(buffer.read())
    }

    func testMakeEmpty() {
        var buffer = RingBuffer<Int>(capacity: 10)
        XCTAssertTrue(buffer.write(123))
        XCTAssertTrue(buffer.write(456))
        XCTAssertNotNil(buffer.read())
        XCTAssertNotNil(buffer.read())
        XCTAssertNil(buffer.read())
        XCTAssertTrue(buffer.write(789))
        XCTAssertEqual(buffer.read(), 789)
        XCTAssertTrue(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
        XCTAssertNil(buffer.read())
    }

    func testMakeFull() {
        var buffer = RingBuffer<Int>(capacity: 10)
        Array(0..<9).forEach { _ in XCTAssertTrue(buffer.write(123)) }
        XCTAssertFalse(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
        XCTAssertTrue(buffer.write(456))
        XCTAssertFalse(buffer.isEmpty)
        XCTAssertTrue(buffer.isFull)
        XCTAssertFalse(buffer.write(789))
        XCTAssertFalse(buffer.isEmpty)
        XCTAssertTrue(buffer.isFull)
        XCTAssertNotNil(buffer.read())
        XCTAssertNotNil(buffer.read())
        XCTAssertFalse(buffer.isEmpty)
        XCTAssertFalse(buffer.isFull)
        XCTAssertTrue(buffer.write(456))
    }

    func testPerformance() {
        var buffer = RingBuffer<Int>(capacity: writeCount)
        measure {
            Array(0..<writeCount).forEach { _ in buffer.write(123) }
            Array(0..<writeCount).forEach { _ in buffer.write(123) }
            Array(0..<readCount).forEach { _ in buffer.read() }
        }
    }
}
