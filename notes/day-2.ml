fun a b c -> a + b + c;;
fun a -> (fun b -> (fun c -> a + b + c));;
let add3 a b c = a + b + c
let add3 = fun a -> (fun b -> (fun c -> a + b + c));;

add3 1 2 3;;
((add3 1) 2) 3;;
(((fun a -> (fun b -> (fun c -> a + b + c))) 1) 2) 3;;
((fun b -> (fun c -> 1 + b + c)) 2) 3;;
(fun c -> 1 + 2 + c) 3;;
1 + 2 + 3;;

add3 1;;
add3 1 2;;
add3 1 2 3;;

let weird_op add_each_round acc f = f (acc + add_each_round);;

List.fold_left (weird_op 2) 0
  [
    ( + ) 2;
    (fun x -> (x * 2) + 7);
    (fun x -> x * x);
    (fun x ->
      print_endline (string_of_int x);
      x);
  ];;

let print3 =
  fun a ->
    print_endline a;
    fun b ->
      print_endline b;
      fun c ->
        print_endline c;;

print3 "hello" "dear" "students";;
print3 "hello" "dear";;


let rec pow b = function
  | 0 -> 1
  | n when n < 0 -> pow b (n + 1) / b
  | n -> b * pow b (n - 1)

let op b e acc x = acc + x + pow b e;;
let op b e =
  let power = pow b e in
  fun acc x -> acc + x + power;;

(* let op = fun acc -> fun x -> acc + x + pow 10 100_000;; *)

List.fold_left (op 10 100_000) 0 (List.init 5_000_000 (Fun.const 42));;

Fun.const 42;;

let flip f b a = f a b;;

Fun.flip List.cons

let negate p x = not (p x)

let rec pipe_many acc = function
| [] -> acc
| f :: fs -> pipe_many (f acc) fs
let pipe_many acc = List.fold_left (fun acc f -> f acc) acc
let pipe_many = List.fold_left (|>)

let two = 1 + 1

let compute_two = fun () -> 1 + 1;;

compute_two ();;
print_endline "Hello world";

type 'a inf_list = Cons of 'a * (unit -> 'a inf_list)

let rec integers n = Cons (n, fun () -> integers (n + 1))

let rec take inf_list n =
  let Cons (curr, rest_lazy) = inf_list in
  if n <= 0 then []
  else List.cons curr (take (rest_lazy ()) (n - 1))

let rec map f (Cons (curr, rest_lazy)) = Cons (f curr, fun () -> map f (rest_lazy ()))

let rec filter p (Cons (curr, rest_lazy)) =
  if p curr then Cons (curr, fun () -> filter p (rest_lazy ()))
  else filter p (rest_lazy ())

let rec nth n (Cons (v, f)) = match n with
  | n when n < 0 -> failwith "Index out of bounds"
  | 0 -> v
  | n -> nth (n - 1) (f ())

type 'a lazier = unit -> 'a

let (map : ('a -> 'b) -> 'a lazier -> 'b lazier) = fun f lazy_val () -> lazy_val () |> f

let bind (f : 'a -> 'b lazier) (lazy_val: 'a lazier) = fun () -> f (lazy_val ()) ()

let combine lazy_a lazy_b = fun () -> (lazy_a (), lazy_b ())

let sum =
  let rec impl acc = function
    | [] -> 1 + (Int.abs [@tailcall]) acc
    | x :: xs -> impl (Int.abs acc + x) xs
  in
  impl 0


let rec sum_with_start start = function
| [] -> start
| x :: xs -> x + (sum_with_start [@tailcall]) start xs

type bst = Leaf | Node of bst * int * bst

let inorder =
  let rec impl acc todos tree = match tree with
    | Leaf -> (
      match todos with
      | [] -> acc
      | Leaf :: rest -> failwith "This should be impossible"
      | Node (l, v, _) :: rest -> impl (v :: acc) rest l
    )
    | Node (l, _, r) -> impl acc (tree :: todos) r
  in
  impl [] []

let rec (@) l1 l2 =
  let rec impl l1 l2 = match l1 with
    | [] -> l2
    | x :: xs -> impl xs (x :: l2)
  in
  impl (List.rev l1) l2

let sum =
  let rec impl continue = function
    | [] -> continue 0
    | x :: xs -> impl (fun sum -> x + sum |> continue) xs
  in
  impl Fun.id
