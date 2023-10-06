let rec length = function [] -> 0 | _ :: xs -> 1 + length xs
let rec sum_int = function [] -> 0 | x :: xs -> x + sum_int xs
let rec sum_float = function [] -> 0. | x :: xs -> x +. sum_float xs
let rec prod_int = function [] -> 1 | x :: xs -> x * prod_int xs
let rec map f = function [] -> [] | x :: xs -> f x :: map f xs

let rec fold_left f acc l =
  match l with [] -> acc | x :: xs -> fold_left f (f acc x) xs

let rec filter predicate = function
  | [] -> []
  | x :: xs when predicate x -> x :: filter predicate xs
  | _ :: xs -> filter predicate xs

let rec filter predicate = function
  | [] -> []
  | x :: xs -> (if predicate x then [ x ] else []) @ filter predicate xs

let rec partition pred = function
  | [] -> ([], [])
  | x :: xs ->
      let l1, l2 = partition pred xs in
      if pred x then (x :: l1, l2) else (l1, x :: l2)
