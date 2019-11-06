import Foundation

var str = "pthread playground"

// 多线程计算 N 个数的和

struct ThreadContext {
    let inputs: [Int]
}

struct ThreadResult {
    let sum: Int
}

func sum(pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
    let context = pointer.bindMemory(to: ThreadContext.self, capacity: 1)
    let sum = context.pointee.inputs.reduce(0, +)
    let result = ThreadResult(sum: sum)
    let resultPointer = UnsafeMutablePointer<ThreadResult>.allocate(capacity: 1)
    resultPointer.pointee = result
    return .init(resultPointer)
}


let count = 1_000_000
let threadCount = 4

let inputs = (0..<count).map { _ in Int(arc4random()) }


var threads = [pthread_t]()

// 创建多线程
for i in 0..<threadCount {
    let start = count / threadCount * i
    let end = start + min(count - start, count / threadCount)
    let threadInputs = Array(inputs[start..<end])
    let context = ThreadContext(inputs: threadInputs)
    let contextPointer = UnsafeMutablePointer<ThreadContext>.allocate(capacity: 1)
    contextPointer.pointee = context
    var thread: pthread_t?
    let error = pthread_create(&thread, nil, sum, contextPointer)
    guard error == 0, let tid = thread else { fatalError() }
    threads.append(tid)
}

// 等待多线程返回结果
var results = [ThreadResult]()
for thread in threads {
    var resultPointer: UnsafeMutableRawPointer?
    let error = pthread_join(thread, &resultPointer)
    guard error == 0, let pointer = resultPointer else { fatalError() }
    let result = pointer.bindMemory(to: ThreadResult.self, capacity: 1)
    results.append(result.pointee)
}


let total = results.reduce(0) {
    $0 + $1.sum
}

debugPrint("总和: \(total)")
