open LibFoldable
open LibCollection

type 'a bst = Leaf | Node of 'a bst * 'a * 'a bst

module BstFoldable : Foldable with type 'a t = 'a bst = struct
  type 'a t = 'a bst

  let empty = Leaf

  let rec insert v = function
    | Leaf -> Node (Leaf, v, Leaf)
    | Node (l, v', r) as node ->
        if v = v' then node
        else if v < v' then Node (insert v l, v', r)
        else Node (l, v', insert v r)

  let rec fold_left f acc = function
    | Leaf -> acc
    | Node (l, v, r) ->
        fold_left f acc l |> Fun.flip f v |> Fun.flip (fold_left f) r
end

module BstCollection = CollectionFromFoldable (BstFoldable)
