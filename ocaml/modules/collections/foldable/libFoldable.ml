module type Foldable = sig
  type 'a t

  val empty : 'a t
  val insert : 'a -> 'a t -> 'a t
  val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
end

module TODO_Foldable = struct
  type 'a t = unit (* TODO *)

  let empty = failwith "TODO"
  let insert value foldable = failwith "TODO"
  let fold_left f acc foldable = failwith "TODO"
end
