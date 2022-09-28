let length l =
  let rec impl acc ls =
    match ls with [] -> acc | _ :: xs -> impl (acc + 1) xs
  in
  impl 0 l

let sum_int l =
  let rec impl acc ls =
    match ls with [] -> acc | x :: xs -> impl (acc + x) xs
  in
  impl 0 l

let rec sum_float = function [] -> 0. | x :: xs -> x +. sum_float xs
let rec prod_int = function [] -> 1 | x :: xs -> x * prod_int xs

let rec map f l =
  let rec impl acc = function [] -> acc | x :: xs -> impl (f x :: acc) xs in
  impl [] (List.rev l)

let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

let filter pred l =
  let rec inner_filter pred l acc =
    match l with
    | [] -> acc
    | x :: xs ->
        if pred x then inner_filter pred xs (x :: acc)
        else inner_filter pred xs acc
  in
  inner_filter pred (List.rev l) []

let rec partition p = function
  | [] -> ([], [])
  | x :: xs ->
      let yes, no = partition p xs in
      if p x then (x :: yes, no) else (yes, x :: no)
