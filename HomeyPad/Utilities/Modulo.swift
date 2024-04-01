func modulo(_ a: Int8, _ n: Int8) -> Int8 {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}
