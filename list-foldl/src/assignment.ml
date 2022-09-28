let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

let length l = fold_left (fun acc _ -> acc + 1) 0 l
let sum_starting_at = fold_left ( + )
let sum_int = sum_starting_at 0
let sum_float = fold_left ( +. ) 0.
let prod_int = fold_left ( * ) 1
let map f = fold_left (fun list x -> list @ [ f x ]) []
let filter p = fold_left (fun list x -> list @ if p x then [ x ] else []) []

let partition p =
  fold_left
    (fun (t, f) x -> if p x then (t @ [ x ], f) else (t, f @ [ x ]))
    ([], [])
