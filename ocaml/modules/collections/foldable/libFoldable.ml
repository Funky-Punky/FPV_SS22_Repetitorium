module type Foldable = sig
  type 'a t

  val empty : 'a t
  val insert : 'a -> 'a t -> 'a t
  val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
end

module PlaceholderFoldable = struct
  type 'a t = unit (* TODO *)

  let empty = ()
  let insert value foldable = failwith "TODO"
  let fold_left f acc foldable = failwith "TODO"
end
