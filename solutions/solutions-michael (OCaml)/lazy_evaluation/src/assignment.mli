type 'a inf_list = Cons of 'a * (unit -> 'a inf_list)

val integers : int -> int inf_list
val take : int -> 'a inf_list -> 'a list
val map : ('a -> 'b) -> 'a inf_list -> 'b inf_list
val filter : ('a -> bool) -> 'a inf_list -> 'a inf_list

type 'a lazy_value = unit -> 'a

val map_lazy : ('a -> 'b) -> 'a lazy_value -> 'b lazy_value
val bind_lazy : ('a -> 'b lazy_value) -> 'a lazy_value -> 'b lazy_value
val combine_lazy : 'a lazy_value -> 'b lazy_value -> ('a * 'b) lazy_value
