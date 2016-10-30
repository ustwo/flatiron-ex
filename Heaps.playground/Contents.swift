// This Playground will fail to run until you build the FlatironSchool Target.

import FlatironSchool

public protocol Median {
    var median: Double { get }
    func insert(number: Int)
}

class RunningMedian : Median {
    var backing: [Int]
    var median: Double

    init() {
        self.backing = []
        self.median = 0
    }

    func insert(number: Int) {
        backing.append(number)
        backing.sort()

        if backing.count % 2 == 0 {
            let index = backing.count / 2 - 1
            median = Double(backing[index] + backing[index + 1]) / 2.0
        } else {
            let index = backing.count / 2
            median = Double(backing[index])
        }
    }
}

class AnotherRunningMedian : Median {

    var left: [Int]
    var right: [Int]
    var median: Double

    init() {
        self.left = [0]
        self.right = [Int.max]
        self.median = 0
    }

    func insert(number: Int) {

        // Three cases:
        // left.count == right.count
        // left.count > right.count
        // left.count < right.count

        if left.count == right.count {
            let top: Int

            if (Double(number) > median) {
                right.append(number)
                top = right.min()!
            } else {
                left.append(number)
                top = left.max()!
            }
            median = Double(top)
            return
        }


        if left.count < right.count {
            let rightTop = right.min()!
            let topIndex = right.index(of: rightTop)!

            if number >= rightTop {
                // Move the min of right over to left.
                // Replace the min with the new number.
                left.append(rightTop)
                right[topIndex] = number
            } else {
                left.append(number)
            }
        } else {
            let leftTop = left.max()!
            let topIndex = left.index(of: leftTop)!

            if number <= leftTop {
                // Move the max of left over to right. 
                // Replace the max with the new number.
                right.append(leftTop)
                left[topIndex] = number
            } else {
                right.append(number)
            }
        }

        median = Double(left.max()! + right.min()!)/2.0
    }
}

class BetterRunningMedian : Median {

    var left: Heap<Int>
    var right: Heap<Int>
    var median: Double

    init() {
        self.left = Heap(type: .max)
        self.right = Heap(type: .min)
        self.median = 0
    }

    func insert(number: Int) {

        if left.count == right.count {
            let top: Int

            if (Double(number) > median) {
                right.insert(number)
                top = right.top!
            } else {
                left.insert(number)
                top = left.top!
            }
            median = Double(top)
            return
        }


        if left.count < right.count {
            let rightTop = right.top!

            if number >= rightTop {
                // Move the min of right over to left.
                // Replace the min with the new number.
                left.insert(right.deleteTop()!)
                right.insert(number)
            } else {
                left.insert(number)
            }
        } else {
            let leftTop = left.top!

            if number <= leftTop {
                // Move the max of left over to right.
                // Replace the max with the new number.
                right.insert(left.deleteTop()!)
                left.insert(number)
            } else {
                right.insert(number)
            }
        }
        
        median = Double(left.top! + right.top!)/2.0
    }
}

// Generate a random array of Ints

func randomArray(n:Int, upper: UInt32) -> [Int] {
    
    return (0..<n).map { _ in
        return Int(arc4random_uniform(upper))
    }
}

let sampleArray = randomArray(n: 100, upper: 20)

print("\nSorted median.\n")

var startTicks = mach_absolute_time()

let rm0 = RunningMedian()

let medians0 = sampleArray.map { item  -> Double in
    rm0.insert(number: item)
    return rm0.median
}
var totalTicks = Double((mach_absolute_time() - startTicks)) / 1000000000.0
print("\(totalTicks) billion ticks.")

print("\nMin/Max median.\n")

startTicks = mach_absolute_time()

let rm1 = AnotherRunningMedian()

let medians1 = sampleArray.map { item  -> Double in
    rm1.insert(number: item)
    return rm1.median
}
totalTicks = Double((mach_absolute_time() - startTicks)) / 1000000000.0

print("\(totalTicks) billion ticks.")

print("\nHeaped median.\n")

startTicks = mach_absolute_time()

let rm2 = BetterRunningMedian()

let medians2 = sampleArray.map { item  -> Double in
    rm2.insert(number: item)
    return rm2.median
}

totalTicks = Double((mach_absolute_time() - startTicks)) / 1000000000.0

print("\(totalTicks) billion ticks.")

// Make sure all our methods agree on their output.
assert((medians0 == medians1) && (medians1 == medians2))
