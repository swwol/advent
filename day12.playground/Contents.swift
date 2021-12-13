import UIKit

let pathList = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

let pathStrings = pathList.split(whereSeparator: \.isNewline)
let paths = pathStrings.map { $0.split(separator: "-")}

func nextNodes(for node: String) -> [String] {
  if node == "end" {
    return []
  }
  return paths.filter( { $0[0] == node }).map { String($0[1])} +  paths.filter( { $0[1] == node }).map { String($0[0])}
}

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
}

extension Array where Element == String {
  var isValid: Bool {

    if frequency["start", default: 0] > 1 {
      return false
    }

    var lowerCaseDuplicateCount = 0

    for (key, value) in frequency {
      if value > 1 && (key.first!.isLowercase && key != "start") {
        lowerCaseDuplicateCount += 1
      }
    }
    return lowerCaseDuplicateCount <= 2
  }
}

var routes: [[String]] = []
var completed: [[String]] = []
routes.append(["start"])


func nextValids(for route: [String]) -> ([[String]], [[String]]) {
  let nextNodesAvailable = nextNodes(for: route.last!)
  let possibleRoutes = nextNodesAvailable.map { route + [$0] }
  let valid = possibleRoutes.filter { $0.isValid }
  let complete = valid.filter { $0.last! == "end" }
  let incomplete = valid.filter { $0.last! != "end" }
  return (complete, incomplete)
}

func nextValidsCollection(for routes: [[String]]) -> ([[String]], [[String]]) {
  var incomplete: [[String]] = []
  var completes: [[String]] = []
  for route in routes {
    let valids = nextValids(for: route)
    incomplete += valids.1
    completes += valids.0
  }
  return (completes, incomplete)
}



var valids = nextValidsCollection(for: routes)

while !valids.0.isEmpty || !valids.1.isEmpty {
  completed += valids.0
  routes = valids.1
  valids = nextValidsCollection(for: routes)
}

print(completed.count)
//print(routes
