let rev l = List.fold_left (Fun.flip List.cons) [] l

let f a b c = a + b + c
let f = fun a b c -> a + b + c
let f : (int -> (int -> (int -> int))) = (fun a -> (fun b -> (fun c -> a + b + c)));;

f 1 2 3;;
(((f 1) 2) 3);;

let increment_2 = f 1;;
let add_four = increment_2 3;;
let five = add_four 1;;

let double_values = List.map (( * ) 2)

let increment = fun a -> a + 1
let increment = (+) 1
let sum = List.fold_left (+) 0
let sum f = List.fold_left f 0 [1; 2; 3]


(* JavaScript *)
(* const add3 = (a, b, c) => a + b + c
add3(1, 2, 3)
const add3_curried = a => b => c => a + b + c
add3(1)(2)(3) *)

let uncurried = fun (a, b) -> a + b
let curried = fun a -> fun b -> a + b

let curry = fun f -> (fun a -> fun b -> f (a, b))
let curry f a b = f (a, b)
let uncurry f (a, b) = f a b

let rec fold_left l acc f = match l with [] -> acc | x :: xs -> fold_left xs (f acc x) f

let sum = Fun.flip (Fun.flip fold_left 0) (+)
let sum l = fold_left l 0 (+)

let print_numbers a b c = print_int a; print_int b; print_int c;;
let print_numbers_delayed = fun a -> (fun b -> (fun c -> (print_int a; print_int b; print_int c)));;

print_numbers_delayed 1;;
print_numbers_delayed 1 2;;
print_numbers_delayed 1 2 3;; (* Console: 1 2 3 *)

let print_numbers_immediately = fun a -> print_int a; (fun b -> print_int b; (fun c -> print_int c));;

let with_one = print_numbers_immediately 1;; (* Console 1 *)
let with_two = with_one 2;; (* Console 2 *)
with_two 3;; (* Console 3 *)

(* [1; 2; 3] -> [(1, 1); (2, 2); (3, 3)] *)
let double_values l = List.map (fun x -> (x, x)) l;;

type monomorphic = int * int * int
type monomorphic_2 = Red | Blue | Green

type 'a polymorphic = 'a -> 'a

let variant_1 : 'a -> 'a = fun x -> x;;

(<);;

let my_fun : 'a list -> 'a list = List.rev

(* double_values [""];;
double_values [1];; *)

let immediate_value = 5
let lazy_value = fun () -> Float.pow 5.0 100_000_000.0



(* map, bind = flatMap, filter, fold  *)

type color = Red | Green | Blue | Orange
type student = { name : string; favorite_color : color option }

let students =
  [
    { name = "Michael"; favorite_color = Some Orange };
    { name = "Hugo"; favorite_color = None };
  ]

let get_favorite_color_by_name search students =
  List.find_opt (fun { name; _ } -> name = search) students |> function
  | None -> None
  | Some { favorite_color; _ } -> favorite_color

let double_every_item list = List.concat_map (fun x -> [ x; x ]) list

let get_favorite_color_by_name search students =
  List.find_opt (fun { name; _ } -> name = search) students
  |> Fun.flip Option.bind (fun { favorite_color; _ } -> favorite_color)


let sum list =
  let rec hepler acc = function [] -> acc | x :: xs -> (hepler [@tailcall]) (x + acc) xs
  in 
  hepler 0 list

let init length generator =
  let rec helper generator index acc =
    if index = length then List.rev acc
    else (helper [@tailcall]) generator (index + 1) (generator index :: acc)
  in
  helper generator 0 []

let init length generator =
  let rec helper length acc =
    if length > 0 then
      (helper [@tailcall]) (length - 1) (generator (length - 1) :: acc)
    else acc
  in
  helper length []
  