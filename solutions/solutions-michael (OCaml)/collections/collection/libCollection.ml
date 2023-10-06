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

module CollectionFromFoldable (F : Foldable) :
  Collection with type 'a t = 'a F.t = struct
  include F

  let size c = F.fold_left (fun acc _ -> acc + 1) 0 c
  let map f c = F.fold_left (fun acc x -> F.insert (f x) acc) F.empty c

  let filter pred c =
    F.fold_left (fun acc x -> if pred x then F.insert x acc else acc) F.empty c

  let delete v c = filter (( <> ) v) c

  let find_opt pred c =
    F.fold_left
      (fun acc x ->
        match acc with Some _ -> acc | None -> if pred x then Some x else None)
      None c

  let iter f c = F.fold_left (fun () x -> f x) () c
end
