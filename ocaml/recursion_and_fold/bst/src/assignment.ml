type bst = Leaf | Node of bst * int * bst

let rec insert n t =
  match t with
  | Leaf -> Node (Leaf, n, Leaf)
  | Node (l, v, r) as node ->
      if n > v then Node (l, v, insert n r)
      else if n < v then Node (insert n l, v, r)
      else node

let rec contains n t =
  match t with
  | Leaf -> false
  | Node (l, v, r) ->
      if n > v then contains n r else if n < v then contains n l else true

let rec delete_max t =
  match t with
  (* return (t, max) *)
  | Leaf -> failwith "shouldn't be possible"
  | Node (l, v, Leaf) -> (l, v)
  | Node (l, v, r) ->
      let new_r, max = delete_max r in
      (Node (l, v, new_r), max)

let rec delete n t =
  match t with
  | Leaf -> Leaf
  | Node (l, v, r) ->
      if n < v then Node (delete n l, v, r)
      else if n > v then Node (l, v, delete n r)
      else if l = Leaf then r
      else if r = Leaf then l
      else
        let new_l, max = delete_max l in
        Node (new_l, max, r)

let rec height = function
  | Leaf -> 0
  | Node (l, _, r) -> 1 + Int.max (height l) (height r)

let rec inorder = function
  | Leaf -> []
  | Node (l, v, r) -> inorder l @ (v :: inorder r)

let rec preorder = function
  | Leaf -> []
  | Node (l, v, r) -> (v :: preorder l) @ preorder r

let rec postorder = function
  | Leaf -> []
  | Node (l, v, r) -> postorder l @ postorder r @ [ v ]

let rec mirror = function
  | Leaf -> Leaf
  | Node (l, v, r) -> Node (mirror r, v, mirror l)

let rec length = function
  | Leaf -> 0
  | Node (l, _, r) -> 1 + length l + length r

let rec sum = function Leaf -> 0 | Node (l, v, r) -> sum l + sum r + v
let rec prod = function Leaf -> 0 | Node (l, v, r) -> prod l * prod r * v

let rec map f = function
  | Leaf -> Leaf
  | Node (l, v, r) -> Node (map f l, f v, map f r)

let rec fold_left f acc = function
  | Leaf -> acc
  | Node (l, v, r) ->
      let left_acc = fold_left f acc l in
      let curr_acc = f left_acc v in
      fold_left f curr_acc r

let rec filter pred = function
  | Leaf -> Leaf
  | Node (l, v, r) as node ->
      if pred v then Node (filter pred l, v, filter pred r)
      else filter pred @@ delete v node

let partition pred t = (filter pred t, filter (Fun.negate pred) t)

let partition pred t =
  fold_left
    (fun (yes, no) x ->
      if pred x then (insert x yes, no) else (yes, insert x no))
    (Leaf, Leaf) t
