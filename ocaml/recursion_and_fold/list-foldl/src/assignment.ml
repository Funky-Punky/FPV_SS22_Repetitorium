let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

let length l = fold_left (fun acc _ -> acc + 1) 0 l
let sum_int l = fold_left ( + ) 0 l
let sum_float l = fold_left ( +. ) 0. l
let prod_int = fold_left ( * ) 1
let map f l = fold_left (fun acc x -> acc @ [ f x ]) [] l

let partition pred l =
  fold_left
    (fun (yes, no) x -> if pred x then (x :: yes, no) else (yes, x :: no))
    ([], []) @@ List.rev l

let filter pred l = fst (partition pred l)
