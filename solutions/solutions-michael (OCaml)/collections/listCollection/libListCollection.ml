open LibFoldable
open LibCollection

module ListFoldable : Foldable with type 'a t = 'a list = struct
  type 'a t = 'a list

  let empty = []
  let insert = List.cons
  let fold_left = List.fold_left
end

module ListCollection = CollectionFromFoldable (ListFoldable)
