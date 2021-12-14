import UIKit

let template = "OHFNNCKCVOBHSSHONBNF"

let ruleStrings = """
SV -> O
KP -> H
FP -> B
VP -> V
KN -> S
KS -> O
SB -> K
BS -> K
OF -> O
ON -> S
VS -> F
CK -> C
FB -> K
CH -> K
HS -> H
PO -> F
NP -> N
FH -> C
FO -> O
FF -> C
CO -> K
NB -> V
PP -> S
BB -> N
HH -> B
KK -> H
OP -> K
OS -> V
KV -> F
VH -> F
OB -> S
CN -> H
SF -> K
SN -> P
NF -> H
HB -> V
VC -> S
PS -> P
NK -> B
CV -> P
BC -> S
NH -> K
FN -> P
SH -> F
FK -> P
CS -> O
VV -> H
OC -> F
CC -> N
HK -> N
FS -> P
VF -> B
SS -> V
PV -> V
BF -> V
OV -> C
HO -> F
NC -> F
BN -> F
HC -> N
KO -> P
KH -> F
BV -> S
SK -> F
SC -> F
VN -> V
VB -> V
BH -> O
CP -> K
PK -> K
PB -> K
FV -> S
HN -> K
PH -> B
VK -> B
PC -> H
BO -> H
SP -> V
NS -> B
OH -> N
KC -> H
HV -> F
HF -> B
HP -> S
CB -> P
PN -> S
BK -> K
PF -> N
SO -> P
CF -> B
VO -> C
OO -> K
FC -> F
NV -> F
OK -> K
NN -> O
NO -> O
BP -> O
KB -> O
KF -> O
""".split(whereSeparator: \.isNewline).map { String($0)}

//"   OH  FN   N  CKCVOBHSSHONBNF"

var pairDict: [String: Int] = ["OH": 1, "HF": 1, "FN": 1, "NN": 1, "NC": 1, "CK": 1, "KC": 1, "CV": 1, "VO": 1, "OB": 1, "BH": 1, "HS": 1, "SS": 1, "SH":1, "HO":1, "ON": 1, "NB":1, "BN":1, "NF": 1]

struct Rule {
  let pair: String
  let output: Character

  init(_ string: String) {
    let components = string.components(separatedBy: " -> ")
    self.pair = components.first!
    self.output = components.last!.first!
  }

  func process(input: String) -> String {
    return input == pair ? String([pair.first!, output, pair.last!]) : input
  }

  //return array of pairs not string
  func processToArray(input: String) -> [String] {
    return [String([pair.first!, output]), String([output, pair.last!])]
  }
}

let rules = ruleStrings.map { Rule($0) }

var result = template

func apply(rules: [Rule], to dict: [String: Int]) -> [String: Int] {
  var transformedDict: [String: Int] = [:]
  for (key, value) in dict {
    if let matchingRules = rules.first(where: { $0.pair == key }) {
      let resultingPairs = matchingRules.processToArray(input: key)
      transformedDict[resultingPairs.first!, default: 0] += value
      transformedDict[resultingPairs.last!, default: 0] += value
    }
  }
  return transformedDict
}

func apply(rules: [Rule], to template: String) -> String {
  let templateArray = Array(template)
  let pairs = zip(templateArray, templateArray.dropFirst()).map { String([$0.0, $0.1]) }

  let transformedPairs: [String] = pairs.map { pair in
    if let matchingRule = rules.first(where: { $0.pair == pair }) {
      return matchingRule.process(input: pair)
  }
    return pair
  }

  return transformedPairs.dropFirst().reduce(transformedPairs[0]) { initial, next in
    return initial + String(next.dropFirst())
  }
}

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
}

var dictResult: [String: Int] = pairDict

for _ in 0..<40 {
  dictResult = apply(rules: rules, to: dictResult)
}

print(dictResult)

var tally: [Character: Int] = [:]

for (key, value) in dictResult {
  tally[key.first!, default: 0] += value
}

print(tally)

let res = tally.map { ($0.key, $0.value) }.sorted(by: { $0.1 > $1.1 })


print(res.first!.1 - res.last!.1)

print(apply(rules: rules, to: result))


for _ in 0..<40 {
  result = apply(rules: rules, to: result)
  print(result)
}

let tuples = result.frequency.map { ($0.key, $0.value) }.sorted(by: { $0.1 > $1.1 })
print(tuples)

print(tuples.first!.1 - tuples.last!.1 )



