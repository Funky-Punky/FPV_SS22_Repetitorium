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

module PlaceholderCollection : Collection
module CollectionFromFoldable (F : Foldable) : Collection
