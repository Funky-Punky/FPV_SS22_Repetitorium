type bst = Leaf | Node of bst * int * bst

let rec insert n tree =
  match tree with
  | Leaf -> Node (Leaf, n, Leaf)
  | Node (l, v, r) ->
      if n < v then Node (insert n l, v, r)
      else if n = v then tree
      else Node (l, v, insert n r)

let rec contains n = function
  | Leaf -> false
  | Node (l, v, r) ->
      if n = v then true else if v > n then contains n l else contains n r

let rec get_max = function
  | Leaf -> failwith "Leaf has no max"
  | Node (_, v, r) -> if r = Leaf then v else get_max r

let rec delete n = function
  | Leaf -> Leaf
  | Node (l, v, r) ->
      if n < v then Node (delete n l, v, r)
      else if n > v then Node (l, v, delete n r)
      else if l = Leaf then r
      else
        let new_v = get_max l in
        Node (delete new_v l, new_v, r)

let rec height = function
  | Leaf -> 0
  | Node (l, _, r) -> 1 + Int.max (height l) (height r)

let inorder _ = failwith "TODO"
let preorder _ = failwith "TODO"
let postorder _ = failwith "TODO"
let mirror _ = failwith "TODO"
let length _ = failwith "TODO"
let sum _ = failwith "TODO"
let prod _ = failwith "TODO"
let map _ = failwith "TODO"
let fold_left _ = failwith "TODO"
let filter _ = failwith "TODO"
let partition _ = failwith "TODO"
