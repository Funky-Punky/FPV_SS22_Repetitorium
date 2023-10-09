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

let rec inorder = function
  | Leaf -> []
  | Node (l, v, r) -> inorder l @ [ v ] @ inorder r

let rec preorder = function
  | Leaf -> []
  | Node (l, v, r) -> [ v ] @ preorder l @ preorder r

let rec postorder = function
  | Leaf -> []
  | Node (l, v, r) -> postorder l @ postorder r @ [ v ]

let rec mirror = function
  | Leaf -> Leaf
  | Node (l, v, r) -> Node (mirror r, v, mirror l)

let rec length = function
  | Leaf -> 0
  | Node (l, _, r) -> 1 + length l + length r

let rec sum = function Leaf -> 0 | Node (l, v, r) -> v + sum l + sum r
let rec prod = function Leaf -> 1 | Node (l, v, r) -> v * prod l * prod r

let rec map f = function
  | Leaf -> Leaf
  | Node (l, v, r) -> Node (map f l, f v, map f r)

let rec fold_left f acc = function
  | Leaf -> acc
  | Node (l, v, r) ->
      let left_acc = fold_left f acc l in
      let curr_acc = f left_acc v in
      fold_left f curr_acc r

let filter p =
  let rec impl acc = function
    | Leaf -> acc
    | Node (l, v, r) ->
        let curr_filtered = if p v then insert v acc else acc in
        let left_filtered = impl curr_filtered l in
        impl left_filtered r
  in
  impl Leaf

let partition p =
  let rec impl (yes, no) = function
    | Leaf -> (yes, no)
    | Node (l, v, r) ->
        let curr_filtered =
          if p v then (insert v yes, no) else (yes, insert v no)
        in
        let left_filtered = impl curr_filtered l in
        impl left_filtered r
  in
  impl (Leaf, Leaf)
