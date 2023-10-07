open LibCollection

module type Map = sig
  type ('k, 'v) t

  val empty : ('k, 'v) t
  val get_opt : 'k -> ('k, 'v) t -> 'v option
  val set : 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t
  val delete : 'k -> ('k, 'v) t -> ('k, 'v) t
  val contains : 'k -> ('k, 'v) t -> bool
end

module PlaceholderMap = struct
  type ('k, 'v) t = unit (* TODO *)

  let empty = ()
  let get_opt key map = failwith "TODO"
  let set key value map = failwith "TODO"
  let delete key map = failwith "TODO"
  let contains key map = failwith "TODO"
end

module type MyFunctor = functor (C : Collection) ->
  Map with type ('k, 'v) t = ('k * 'v) C.t

module MapFromCollection (C : Collection) : Map = struct
  type ('k, 'v) t = ('k * 'v) C.t

  let empty = C.empty
  let get_opt key map = C.find_opt (fun (k, _) -> k = key) map |> Option.map snd
  let delete key map = C.filter (fun (k, _) -> k <> key) map
  let set key value map = C.insert (key, value) @@ delete key map
  let contains key map = get_opt key map |> Option.is_some
end
