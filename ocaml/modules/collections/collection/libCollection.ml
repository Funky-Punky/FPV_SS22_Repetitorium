open LibFoldable

module type Collection = sig
  include Foldable

  val size : 'a t -> int
  val map : ('a -> 'b) -> 'a t -> 'b t
  val filter : ('a -> bool) -> 'a t -> 'a t
  val delete : 'a -> 'a t -> 'a t
  val find_opt : ('a -> bool) -> 'a t -> 'a option
  val iter : ('a -> unit) -> 'a t -> unit
end

module TODO_Collection : Collection = struct
  include TODO_Foldable

  let size c = failwith "TODO"
  let map f c = failwith "TODO"
  let filter pred c = failwith "TODO"
  let delete v c = failwith "TODO"
  let find_opt pred c = failwith "TODO"
  let iter f c = failwith "TODO"
end

module CollectionFromFoldable (F : Foldable) : Collection = TODO_Collection
