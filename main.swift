enum Crash: ErrorType { case Key(String) }
func kaboom(str: String) throws -> String {
  throw Crash.Key(str)
}

print("")
print("Demo for https://bugs.swift.org/browse/SR-696")
print("Use -DTESTn when compiling to select a test case (n=1...6)")
print("")

#if TEST1
print("====== TEST 1 ====== ")

// Crash with EXC_BAD_ACCESS, not every time but quite often
func test1() throws -> [String:[String]] {
  return [
    "foo": try [kaboom("test1a"), kaboom("test1b")]
  ]
}

do {
  // randomly EXC_BAD_ACCESS
  try test1()
} catch { print("--> \(error)") }
#endif


#if TEST2
print("====== TEST 2 ====== ")

// Crash with EXC_BAD_ACCESS, not every time but very often
func test2() throws -> [String:Any] {
  return [
    "foo": try ["test2a","test2b"].map { try kaboom($0) }
  ]
}

do {
  // randomly EXC_BAD_ACCESS
  try test2()
} catch { print(error) }
#endif


#if TEST3
print("====== TEST 3 ====== ")
// Crash with EXC_BAD_ACCESS sometimes, but way less often
func test3() throws -> [String:Any] {
  let t: [String:Any] = [
    "foo": try ["test3a","test3b"].map { try kaboom($0) }
  ]
  return t
}

do {
  // randomly EXC_BAD_ACCESS
  try test3()
} catch { print(error) }
#endif


#if TEST4
print("====== TEST 4 ====== ")
// Crash with EXC_BAD_ACCESS, not every time but quite often
func test4() throws -> [String:String] {
  return [
    "foo": try kaboom("test4")
  ]
}

do {
  // randomly EXC_BAD_ACCESS
  try test4()
} catch { print(error) }
#endif


#if TEST5
print("====== TEST 5 ====== ")
// Crash with EXC_BAD_ACCESS, not every time but quite often
func test5() -> [String:Any] {
  do {
    return [
      "foo": try [kaboom("test5a"), kaboom("test5b")]
    ]
  } catch {
    print(error)
    return [:]
  }
}

// randomly EXC_BAD_ACCESS
test5()
#endif


#if TEST6
print("====== TEST 6 ====== ")
// Seems ok
func test6() throws -> [Any] {
  return [try kaboom("test6a"), try kaboom("test6b")]
}

do {
  // Seems ok
  try test6()
} catch { print(error) }
#endif

