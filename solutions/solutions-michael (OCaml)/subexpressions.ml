(* Task 1: *)
 (let foo = ("bar") in ((print_endline) (foo)))                  ;;

(* Just here to remove compiler warnings *)
let foo = ("bar");;

(* Subexpressions with types: *)
(            "bar"                              : string        );;
(* Remember: foo is now a string! *)
(                        print_endline          : string -> unit);;
(                                        foo    : string        );;
(                        print_endline   foo    : unit          );;
(                      ((print_endline) (foo))  : unit          );;
((let foo = ("bar") in ((print_endline) (foo))) : unit          );;

(* Task 2: *)
 (((float_of_int) ((1) + (2))) *. (3.5))                ;;

(* Subexpressions with types: *)
(   float_of_int                         : int -> float);;
(                   1                    : int         );;
(                         2              : int         );;
(                                  3.5   : float       );;
(  (float_of_int)                        : int -> float);;
(                  (1)                   : int         );;
(                        (2)             : int         );;
(                                 (3.5)  : float       );;
(                  (1) + (2)             : int         );;
(                 ((1) + (2))            : int         );;
(  (float_of_int) ((1) + (2))            : float       );;
( ((float_of_int) ((1) + (2)))           : float       );;
( ((float_of_int) ((1) + (2))) *. (3.5)  : float       );;
((((float_of_int) ((1) + (2))) *. (3.5)) : float       );;

(* Task 3 a): *)
 [2; 3] |> List.cons 1 |> List.map (( * ) 2) |> List.fold_left ( + ) 0;;

(* Subexpressions with types: *)
( 2                                                                    : int                                    );;
(    3                                                                 : int                                    );;
(          List.cons                                                   : 'a -> 'a list -> 'a list               );;
(                    1                                                 : int                                    );;
(                         List.map                                     : ('a -> 'b) -> 'a list -> 'b list       );;
(                                   ( * )                              : int -> int -> int                      );;
(                                         2                            : int                                    );;
(                                               List.fold_left         : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a);;
(                                                              ( + )   : int -> int -> int                      );;
(                                                                    0 : int                                    );;
([2; 3]                                                                : int list                               );;
(          List.cons 1                                                 : int list -> int list                   );;
([2; 3] |> List.cons 1                                                 : int list                               );;
(                                   ( * ) 2                            : int -> int                             );;
(                                  (( * ) 2)                           : int -> int                             );;
(                         List.map (( * ) 2)                           : int list -> int list                   );;
([2; 3] |> List.cons 1 |> List.map (( * ) 2)                           : int list                               );;
(                                               List.fold_left ( + )   : int -> int list -> int                 );;
(                                               List.fold_left ( + ) 0 : int list -> int                        );;
([2; 3] |> List.cons 1 |> List.map (( * ) 2) |> List.fold_left ( + ) 0 : int                                    );;

(* Task 3 b): *)
 List.fold_left ( + ) 0 (List.map (( * ) 2) (List.cons 1 [2; 3]));;

(* Subexpressions with types: *)
(List.fold_left                                                   : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a);;
(               ( + )                                             : int -> int -> int                      );;
(                     0                                           : int                                    );;
(                        List.map                                 : ('a -> 'b) -> 'a list -> 'b list       );;
(                                  ( * )                          : int -> int -> int                      );;
(                                        2                        : int                                    );;
(                                            List.cons            : 'a -> 'a list -> 'a list               );;
(                                                      1          : int                                    );;
(                                                         2       : int                                    );;
(                                                            3    : int                                    );;
(List.fold_left ( + )                                             : int -> int list -> int                 );;
(List.fold_left ( + ) 0                                           : int list -> int                        );;
(                                 (( * ) 2)                       : int -> int                             );;
(                        List.map (( * ) 2)                       : int list -> int list                   );;
(                                            List.cons 1          : int list -> int list                   );;
(                                                        [2; 3]   : int list                               );;
(                                            List.cons 1 [2; 3]   : int list                               );;
(                                           (List.cons 1 [2; 3])  : int list                               );;
(                        List.map (( * ) 2) (List.cons 1 [2; 3])  : int list                               );;
(                       (List.map (( * ) 2) (List.cons 1 [2; 3])) : int list                               );;
(List.fold_left ( + ) 0 (List.map (( * ) 2) (List.cons 1 [2; 3])) : int                                    );;

(* Task 3 c): *)
 List.fold_left ( + ) 0 (List.map (( * ) 2) (List.cons 1 (2 :: 3 :: [])));;

(* Subexpressions with types: *)
(List.fold_left                                                           : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a);;
(               ( + )                                                     : int -> int -> int                      );;
(                     0                                                   : int                                    );;
(                        List.map                                         : ('a -> 'b) -> 'a list -> 'b list       );;
(                                  ( * )                                  : int -> int -> int                      );;
(                                        2                                : int                                    );;
(                                            List.cons                    : 'a -> 'a list -> 'a list               );;
(                                                      1                  : int                                    );;
(                                                         2               : int                                    );;
(                                                              3          : int                                    );;
(                                                                   []    : 'a list                                );;
(List.fold_left ( + )                                                     : int -> int list -> int                 );;
(List.fold_left ( + ) 0                                                   : int list -> int                        );;
(                                  ( * ) 2                                : int -> int                             );;
(                                 (( * ) 2)                               : int -> int                             );;
(                        List.map (( * ) 2)                               : int list -> int list                   );;
(                                            List.cons 1                  : int list -> int list                   );;
(                                                              3 :: []    : int list                               );;
(                                                         2 :: 3 :: []    : int list                               );;
(                                                        (2 :: 3 :: [])   : int list                               );;
(                                            List.cons 1 (2 :: 3 :: [])   : int list                               );;
(                                           (List.cons 1 (2 :: 3 :: []))  : int list                               );;
(                        List.map (( * ) 2) (List.cons 1 (2 :: 3 :: []))  : int list                               );;
(                       (List.map (( * ) 2) (List.cons 1 (2 :: 3 :: []))) : int list                               );;
(List.fold_left ( + ) 0 (List.map (( * ) 2) (List.cons 1 (2 :: 3 :: []))) : int                                    );;

(* Task 4: *)
let flip f a b = f b a in flip ( - ) 2 3;;
(* OPTIONAL: De-sugar function declaration to allow for nicer formatting *)
let flip = fun f a b -> f b a in flip ( - ) 2 3;;

(* Just here to remove compiler errors *)
let flip = fun f a b -> f b a;;
let f = ( - );;
let b = 2;;
let a = 3;;

(* Subexpressions with types: *)
(* Evaluate bound expression *)
(                        f                       : ('a -> 'b -> 'c)                  );;
(                          b                     : 'a                                );;
(                            a                   : 'b                                );;
(                        f b                     : 'b -> 'c                          );;
(                        f b a                   : 'c                                );;
(           fun f a b -> f b a                   : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c);;
(* Evaluate body *)
(                                 flip           : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c);;
(                                      ( - )     : int -> int -> int                 );;
(                                            2   : int                               );;
(                                              3 : int                               );;
(                                 flip ( - )     : int -> int -> int                 );;
(                                 flip ( - ) 2   : int -> int                        );;
(                                 flip ( - ) 2 3 : int                               );;
(* Done *)
(let flip = fun f a b -> f b a in flip ( - ) 2 3 : int                               );;

(* Task 5: *)
let y a b c = a c b in List.map (y (@@) [2; 3; 4]) [List.cons 1; (@) [0; 4]];;
(* OPTIONAL: De-sugar function declaration to allow for nicer formatting *)
let y = fun a b c -> a c b in List.map (y (@@) [2; 3; 4]) [List.cons 1; (@) [0; 4]];;

(* Just here to remove compiler errors *)
let y = fun a b c -> a c b;;
let a = (@@);;
let b = [2; 3; 4];;
let c = List.cons 1;;

(* Evaluate bound expression *)
(                     a                                                              : 'a -> 'b -> 'c                    );;
(                       c                                                            : 'a                                );;
(                     a c                                                            : 'b -> 'c                          );;
(                         b                                                          : 'b                                );;
(                     a c b                                                          : 'c                                );;
(        fun a b c -> a c b                                                          : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c);;
(* Evaluate body *)
(                              List.map                                              : ('a -> 'b) -> 'a list -> 'b list  );;
(                                        y                                           : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c);;
(                                          (@@)                                      : ('a -> 'b) -> 'a -> 'b            );;
(                                                2                                   : int                               );;
(                                                   3                                : int                               );;
(                                                      4                             : int                               );;
(                                                          List.cons                 : 'a -> 'a list -> 'a list          );;
(                                                                    1               : int                               );;
(                                                                        (@)         : 'a list -> 'a list -> 'a list     );;
(                                                                             0      : int                               );;
(                                                                                4   : int                               );;
(                                        y (@@)                                      : 'b -> ('b -> 'a) -> 'a            );;
(                                               [2; 3; 4]                            : int list                          );;
(                                        y (@@) [2; 3; 4]                            : (int list -> 'a) -> 'a            );;
(                                       (y (@@) [2; 3; 4])                           : (int list -> 'a) -> 'a            );;
(                              List.map (y (@@) [2; 3; 4])                           : (int list -> 'a) list -> 'a list  );;
(                                                          List.cons 1               : int list -> int list              );;
(                                                                            [0; 4]  : int list                          );;
(                                                                        (@) [0; 4]  : int list -> int list              );;
(                                                          [List.cons 1; (@) [0; 4]] : (int list -> int list) list       );;
(                              List.map (y (@@) [2; 3; 4]) [List.cons 1; (@) [0; 4]] : int list list                     );;
(* Done *)
(let y = fun a b c -> a c b in List.map (y (@@) [2; 3; 4]) [List.cons 1; (@) [0; 4]] : int list list                     );;
