type bst = Leaf | Node of bst * int * bst

val insert : int -> bst -> bst
val contains : int -> bst -> bool
val delete : int -> bst -> bst
val height : bst -> int
val inorder : bst -> int list
val preorder : bst -> int list
val postorder : bst -> int list
val mirror : bst -> bst

val length : bst -> int
val sum : bst -> int
val prod : bst -> int
val map : (int -> int) -> bst -> bst
val fold_left : ('a -> int -> 'a) -> 'a -> bst -> 'a
val filter : (int -> bool) -> bst -> bst
val partition : (int -> bool) -> bst -> bst * bst
