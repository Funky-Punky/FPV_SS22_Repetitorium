type 'a inf_list = Cons of 'a * (unit -> 'a inf_list)

let rec integers n = Cons (n, fun () -> integers (n + 1))

let rec take n (Cons (head, tail)) =
  if n <= 0 then [] else head :: take (n - 1) (tail ())

let rec map f (Cons (head, tail)) = Cons (f head, fun () -> map f (tail ()))

let rec filter p (Cons (head, tail)) =
  if p head then Cons (head, fun () -> filter p (tail ()))
  else filter p (tail ())

type 'a lazy_value = unit -> 'a

let map_lazy f lazy_val () = f @@ lazy_val ()
let bind_lazy f lazy_val () = (f @@ lazy_val ()) ()
let combine_lazy a b () = (a (), b ())
