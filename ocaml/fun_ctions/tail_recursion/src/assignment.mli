(* List *)
val length : 'a list -> int
val sum_int : int list -> int
val sum_float : float list -> float
val prod_int : int list -> int
val map : ('a -> 'b) -> 'a list -> 'b list
val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
val filter : ('a -> bool) -> 'a list -> 'a list
val partition : ('a -> bool) -> 'a list -> 'a list * 'a list

(* BST *)
type bst = Leaf | Node of bst * int * bst

val height : bst -> int
val inorder : bst -> int list
val preorder : bst -> int list
val postorder : bst -> int list

(* Dijkstra *)
type node = int
type weight = int
type edge = node * weight * node
type graph = edge list

val dijkstra : graph -> edge list

(* BST *)
val sum : bst -> int
val insert : int -> bst -> bst
