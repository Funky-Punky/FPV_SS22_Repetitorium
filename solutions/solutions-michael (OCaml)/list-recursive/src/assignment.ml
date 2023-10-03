let rec length = function [] -> 0 | _ :: xs -> 1 + length xs
let rec sum_int = function [] -> 0 | x :: xs -> x + length xs
let rec sum_float = function [] -> 0. | x :: xs -> x +. sum_float xs
let rec prod_int = function [] -> 1 | x :: xs -> x * prod_int xs
let rec map f = function [] -> [] | x :: xs -> f x :: map f xs

let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

let rec filter pred = function
  | [] -> []
  | x :: xs when pred x -> x :: filter pred xs
  | _ :: xs -> filter pred xs

let rec partition p = function
  | [] -> ([], [])
  | x :: xs ->
      let yes, no = partition p xs in
      if p x then (x :: yes, no) else (yes, x :: no)
