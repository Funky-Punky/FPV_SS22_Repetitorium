let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

(* l only required only to resolve weak type *)
let length l = fold_left (fun acc _ -> acc + 1) 0 l
let sum_int = fold_left ( + ) 0
let sum_float = fold_left ( +. ) 0.
let prod_int = fold_left ( * ) 1

let map f xs = List.rev (fold_left (fun list x -> f x :: list) [] xs)

let partition p =
  fold_left
    (fun (t, f) x -> if p x then (t @ [ x ], f) else (t, f @ [ x ]))
    ([], [])

let filter p xs = fst (partition p xs)
