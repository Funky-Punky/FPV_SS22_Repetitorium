let my_int = 42
let my_float = 42.0
let my_string = "Hello, World"
let my_char = 'a'
let my_bool = false
let list = [1; 2; 3]
let list = 1 :: 2 :: 3 :: []
let list = (1 :: (2 :: (3 :: ([]))))
let list = 1 :: [2; 3];;

match list with [] -> "empty" | _ :: _ -> "not empty";;
(match (list) with [] -> ("empty") | _ :: _ -> ("not empty"))

let (head :: _) = (list)

let my_tuple = (((2), (3)))
let my_tuple = ((("hello"), (42.0), (true)))

let (s, _, b) = (my_tuple)

type student = { name : string; age : int }
let michael = ({ name = ("Michael"); age = (24) })
let michaels_age = (michael.age)
let { age = michaels_age } = michael;;
let age_next_year = ((michaels_age) + (1));;

1 + 1;;
1 - 1;;
3 * 2;;
3 / 2;;
-1;;
5 mod 2;;
3. +. 2.;;
3. -. 2.;;
3. *. 2.;;
3. /. 2.;;
"Hello, " ^ "World";;
[1; 2] @ [3; 4];;
(([(1); (2)]) @ ([(3); (4)]));;
(((1) :: ((2) :: ([]))) @ ((3) :: ((4) :: ([]))));;
(* technically not an operator :/ *)
1 :: [2; 3; 4];;
1 < 2;;
1 <= 2;;
1 > 2;;
1 >= 2;;
1. < 2.;;
true < false;;
"Hello" < "World";;
(1, "foo") < (42, "bar");;
1 = 1;;
1 <> 1;;

1 < 2;;
(<) 1 2;;
(+) 1 2;;
((( * )) (2) (3));;
(mod) 5 2;;
( +. ) 1. 2.;;
( - ) 1 2;;
( ~- ) 1;;
(* (::) 1 [];; *)
List.cons 1 [];;

not @@ not true;;
not (not true);;
not true;;
true |> not;;
((((5) |> (( * )) (4)) |> (((-)) (3))) |> (string_of_int));;
string_of_int ((-) 3 (( * ) 4 5));;

(-) 2 3 = -1;;
(((((Fun.flip) ((-))) (2)) (3)) = (1));;

fun a b c -> a + b + c;;
function (a, b) -> a + b;;
fun x -> match x with [] -> 0 | _ :: _ -> 1;;
function [] -> 0 | _ :: _ -> 1;;

if 1 < 2 then 0 else 1;;
match 1 < 2 with true -> 0 | false -> 1;;

let a = function [] -> 0 | _ :: _ -> 1 in a [];;
let a = function [] -> 0 | _ :: _ -> 1;; a [];;

type color = Red | Green | Blue | Orange
let my_favorite_color = Orange
let am_i_cool = my_favorite_color <> Red

let coolness = match my_favorite_color with
| Red -> -1
| Blue -> 0
| Green -> 1
| Orange -> 100_000_000

type nat = Zero | Succ of nat
let zero = Zero
let one = Succ (zero)
let five = Succ (Succ (Succ (Succ (Succ (Zero)))))

let rec int_of_nat n = match n with
  | Zero -> 0
  | Succ x -> 1 + int_of_nat x;;

let rec print_until_zero n = match n with
  | 0 -> ()
  | n -> print_endline @@ string_of_int n; print_until_zero @@ n - 1;;

let thrd ((_, _, v) as all) = v, all

let rec print_until_zero = function
  | Zero -> ()
  | Succ x as old_value -> print_endline @@ string_of_int @@ int_of_nat old_value; print_until_zero @@ x;;

type 'a option = None | Some of 'a;;

let my_favorite_number = 7;;

match Some 42 with
  | None -> "None"
  | Some 13 -> "13"
  | Some x when my_favorite_number = x -> "YAY!"
  | Some x -> "A VALUEEEEEEE"
