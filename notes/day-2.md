# Day 2
## Unary functions
```ocaml
let f = fun a -> (fun b -> (fun c -> a + b + c))
let f a = fun b -> (fun c -> a + b + c)
let f a b = fun c -> a + b + c
let f a b c = a + b + c

f 1 2 3
((f 1) 2) 3
(((fun a -> (fun b -> (fun c -> a + b + c))) 1) 2) 3
((fun b -> (fun c -> 1 + b + c)) 2) 3
(fun c -> 1 + 2 + c) 3
1 + 2 + 3

const add3 = (a, b, c) => a + b + c
const add3_curried = a => b => c => a + b + c

let fold_left f acc list = ...

let weird_op add_each_round acc f = f (acc + add_each_round)

List.fold_left (weird_op 2) 0
  [
    ( + ) 2;
    (fun x -> (x * 2) + 7);
    (fun x -> x * x);
    (fun x ->
      print_endline (string_of_int x);
      x);
  ]

let non_unary_function (a, b, c) = a + b + c

let _var1 = 
fun a ->
fun b ->
fun c ->
print_endline a;
print_endline b;
print_endline c;
;;

let _var2 = 
fun a ->
print_endline a;
fun b ->
print_endline b;
fun c ->
print_endline c;
;;

let rec pow b = function
  | 0 -> 1
  | n when n < 0 -> pow b (n + 1) / b
  | n -> b * pow b (n - 1)

let op b e acc x = acc + x + pow b e;;

List.fold_left (op 10 100_00) 0 (List.init 5_000_000 Fun.id)
```

## Tail Recursion
```ocaml
let rec sum = function
  | [] -> 0
  | x :: xs -> x + (sum[@tailcall]) xs

let rec sum_tr =
  let impl sum = function
    | [] -> sum
    | x :: xs -> (sum_tr[@tailcall]) (sum + x) xs

let asdf x = (string_of_int [@tailcall]) x |> print_endline;;

type tree = Leaf | Node of tree * int * tree

let rec contains x = function
  | Leaf -> false
  | Node (l, v, r) ->
    if x = v then true
    else if contains l then true
    else contains r

let contains x tree =
  let rec impl = function
    | [] -> false
    | Leaf :: xs -> (impl [@tailcall]) xs
    | Node (l, v, r) :: xs -> if v = x then true else (impl [@tailcall]) (l :: r :: xs)
  in
  impl [tree]
```
