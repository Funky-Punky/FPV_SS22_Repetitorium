open LibFoldable

module type Collection = sig
  (* include Foldable *)
  type 'a t = 'a list

  val size : 'a t -> int
  val map : ('a -> 'b) -> 'a t -> 'b t
  val filter : ('a -> bool) -> 'a t -> 'a t
  val delete : 'a -> 'a t -> 'a t
  val find_opt : ('a -> bool) -> 'a t -> 'a option
  val iter : ('a -> unit) -> 'a t -> unit
end

module PlaceholderCollection : Collection = struct
  include PlaceholderFoldable

  let size c = failwith "TODO"
  let map f c = failwith "TODO"
  let filter pred c = failwith "TODO"
  let delete v c = failwith "TODO"
  let find_opt pred c = failwith "TODO"
  let iter f c = failwith "TODO"
end

module CollectionFromFoldable (F : Foldable) : Collection = struct
  include F

  let size c = fold_left (fun acc _ -> acc + 1) 0 c
  let map f c = F.fold_left (fun acc x -> F.insert (f x) acc) F.empty c

  let filter pred c =
    F.fold_left (fun acc x -> if pred x then F.insert x acc else acc) F.empty c

  let delete v c = filter (( <> ) v) c

  let find_opt pred c =
    F.fold_left
      (fun acc x -> if pred x && acc = None then Some x else acc)
      None c

  let iter f c = F.fold_left (fun () x -> f x) () c
end
