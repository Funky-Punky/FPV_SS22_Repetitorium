open LibCollection

module type Map = sig
  type ('k, 'v) t

  val empty : ('k, 'v) t
  val get_opt : 'k -> ('k, 'v) t -> 'v option
  val set : 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t
  val delete : 'k -> ('k, 'v) t -> ('k, 'v) t
  val contains : 'k -> ('k, 'v) t -> bool
end

module MapFromCollection (C : Collection) : Map = struct
  type ('k, 'v) t = ('k * 'v) C.t

  let empty = C.empty
  let get_opt k t = C.find_opt (fun (k', _) -> k = k') t |> Option.map snd

  let delete k t =
    match get_opt k t with None -> t | Some v -> C.delete (k, v) t

  let set k v t = delete k t |> C.insert (k, v)
  let contains k t = get_opt k t |> Option.is_some
end
