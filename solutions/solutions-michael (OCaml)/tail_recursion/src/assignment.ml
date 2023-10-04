(* List *)
let length l =
  let rec aux acc = function [] -> acc | _ :: xs -> aux (acc + 1) xs in
  aux 0 l

let rev l =
  let rec aux acc = function [] -> acc | x :: xs -> aux (x :: acc) xs in
  aux [] l

let map f l =
  let rec aux acc = function [] -> acc | x :: xs -> aux (f x :: acc) xs in
  aux [] @@ rev l

let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

let filter predicate l =
  let rec aux acc = function
    | [] -> acc
    | x :: xs -> aux (if predicate x then x :: acc else acc) xs
  in
  aux [] @@ rev l

let partition predicate l =
  let rec aux ((yes, no) as acc) = function
    | [] -> acc
    | x :: xs when predicate x -> aux (x :: yes, no) xs
    | x :: xs -> aux (yes, x :: no) xs
  in
  aux ([], []) @@ rev l

let sum_int l =
  let rec aux acc = function [] -> acc | x :: xs -> aux (x + acc) xs in
  aux 0 l

let sum_float l =
  let rec aux acc = function [] -> acc | x :: xs -> aux (x +. acc) xs in
  aux 0. l

let prod_int l =
  let rec aux acc = function [] -> acc | x :: xs -> aux (x * acc) xs in
  aux 1 l

(* BST *)
type bst = Leaf | Node of bst * int * bst

let height tree =
  let rec impl curr_node curr_max curr_height stack =
    match curr_node with
    | Leaf -> (
        match stack with
        | [] -> curr_max
        | (x, h) :: stack -> impl x curr_max h stack)
    | Node (l, _, r) ->
        impl l
          (Int.max (curr_height + 1) curr_max)
          (curr_height + 1)
          ((r, curr_height + 1) :: stack)
  in
  impl tree 0 0 []

let inorder t =
  let rec aux todo acc = function
    | Leaf -> ( match todo with [] -> acc | t :: todo -> aux todo acc t)
    | Node (l, v, r) -> (
        match l with
        | Leaf -> aux todo (v :: acc) r
        | Node _ -> aux (Node (Leaf, v, r) :: todo) acc l)
  in
  rev @@ aux [] [] t

let preorder t =
  let rec aux todo acc = function
    | Leaf -> ( match todo with [] -> acc | t :: todo -> aux todo acc t)
    | Node (l, v, r) -> aux (r :: todo) (v :: acc) l
  in
  rev @@ aux [] [] t

let postorder =
  let rec impl todo acc = function
    | Leaf -> (
        match todo with [] -> acc | node :: todo -> impl todo acc node)
    | Node (l, v, r) -> impl (l :: todo) (v :: acc) r
  in
  impl [] []

(* Dijkstra *)
type node = int
type weight = int
type edge = node * weight * node
type graph = edge list

let dijkstra _ = failwith "TODO"

(* BST *)
let sum t =
  let rec aux acc = function
    | [] -> acc
    | Leaf :: todo -> aux acc todo
    | Node (l, n, r) :: todo -> aux (acc + n) (l :: r :: todo)
  in
  aux 0 [ t ]

let insert n =
  (* Walks down BST, saving reverse list of parents (leftmost = deepest) *)
  let rec aux reverse_parents = function
    | Leaf -> insert_with_path (Node (Leaf, n, Leaf)) reverse_parents
    | Node (l, v, r) as node ->
        if v = n then insert_with_path node reverse_parents
        else aux (node :: reverse_parents) (if v < n then r else l)
  (* Inserts node into original structure *)
  and insert_with_path node =
    List.fold_left
      (fun node -> function
        | Leaf -> failwith "shouldn't be possible"
        | Node (l, v, r) ->
            if v < n then Node (l, v, node) else Node (node, v, r))
      node
  in
  aux []
