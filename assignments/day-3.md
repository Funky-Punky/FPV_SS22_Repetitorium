# Day 3

```ocaml
let f a b c = a + b + c
  f 1 2 3 |> string_of_int

let rec sum = function
| [] -> 0
| x :: xs -> x + sum xs

let rec sum acc = function
| [] -> acc
| x :: xs -> sum (acc + x) xs

```

## Tail recursion
1. Implement `sum`, insert, and then `map` tailrecursively for BSTs


## Modules
1. 
