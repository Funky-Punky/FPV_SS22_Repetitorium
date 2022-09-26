# Day 1
## Lists
1. Implement the functions described by the interface below. Do **NOT** use the OCaml `List` module! Do not take any shortcuts, i.e. don't use functions you have already implemented and try to not even copy and paste code for similar functions. These are somewhat monotonous drills, but they will give you practice in dealing with lists!
  - length - takes a list and returns the amount of elements inside it
  - sum_int - takes a list of ints and returns its sum. Remember that the empty sum is 0!
  - sum_float - same, but with floats
  - prod_int - takes a list of ints and returns its product. Remember that the empty product is 1!
  - map - Re-implement `List.map`. It should take a conversion function and a list of elements and return a list of all the converted elements
  - fold_left - Takes a folding function, an initial accumulator and a list. The folding function returns a new accumulator based on the old accumulator and the current list element.
  - filter - Takes a predicate and a list. Returns a list with all items of the list that "survived" the predicate, i.e. that it returned `true` for
  - partition - Similar to filter, but returns a tuple of two lists. First, the elements that "survived" the predicate, and second those that didn't.
2. Re-implement all of the above functions **except for `fold_left`** by using **only** `fold_left`! This means, you may only choose a folding function and an initial accumulator to implement the same functionality
3. Freestyle - Implement these functions as elegantly as possible (but still refrain from using the `List` module). In addition to that, scroll through [the `List` module's documentation](https://v2.ocaml.org/api/List.html) and find two more functions that sound interesting. Implement them in whatever way you like.

```ocaml
val length : 'a list -> int
val sum_int : int list -> int
val sum_float : float list -> float
val prod_int : int list -> int
val map : ('a -> 'b) -> 'a list -> 'b list
val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
val filter : ('a -> bool) -> 'a list -> 'a list
val partition : ('a -> bool) -> 'a list -> 'a list * 'a list
```

## Binary Search Trees
1. Implement the BST-specific functions
  - insert - Inserts an int into a BST
  - contains - Checks whether a BST contains an int
  - delete - Removes an int from a BST
  - height - Computes the (maximum) height of the tree
  - inorder - Returns the elements of a BST such that the children occur from left to right ([see this image](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.cdn.geeksforgeeks.org%2Fwp-content%2Fuploads%2FPreorder-from-Inorder-and-Postorder-traversals.jpg&f=1&nofb=1&ipt=05f5f6f9355d83adfbf8031f38b931c3fc3cd2d92e062e601aa6d9542c074955&ipo=images))
  - preorder - Returns a list of the elements that lists the root first and then its children (see image above)
  - postorder - Lists the children first and then the root (see image above)
  - mirror - Mirrors a BST (watch out; this is no longer a BST but instead only a binary tree! But we'll just ignore that for the moment)
2. Implement a the list functions from above, but this time for BSTs. Implement them directly, i.e. do not convert the tree to a list first using inorder and then recycle the list functions and do not recycle any other functions or code you have written (Again, this is only for practice purposes. In a real-world scenario, you would want to recycle as much code as possible!)

```ocaml
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
```
