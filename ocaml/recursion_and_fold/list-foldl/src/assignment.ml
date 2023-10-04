let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

let length _ = failwith "TODO"
let sum_int _ = failwith "TODO"
let sum_float _ = failwith "TODO"
let prod_int _ = failwith "TODO"
let map _ _ = failwith "TODO"
let filter _ _ = failwith "TODO"
let partition _ _ = failwith "TODO"
