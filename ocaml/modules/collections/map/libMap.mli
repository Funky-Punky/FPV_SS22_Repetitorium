open LibCollection

module type Map = sig
  type ('k, 'v) t

  val empty : ('k, 'v) t
  val get_opt : 'k -> ('k, 'v) t -> 'v option
  val set : 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t
  val delete : 'k -> ('k, 'v) t -> ('k, 'v) t
  val contains : 'k -> ('k, 'v) t -> bool
end

module PlaceholderMap : Map
module MapFromCollection (C : Collection) : Map
