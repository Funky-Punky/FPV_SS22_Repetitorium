1 :: (2 :: (3 :: []));;
List.cons 1 (List.cons 2 (List.cons 3 []));;
[1; 2; 3];;
[1; 2] @ [3; 4];;


type color = Red | Green | Blue;;
type nat = Zero | Suc of nat;;
type pair = string * int;;
type person = { name: string; age: int }

let michael_tuple = ("Michael", 23);;
let michael = { name = "Michael"; age = 23 };;

let (a, b) = michael_tuple;;
let a = michael.name;;

match 1 :: [2; 3] with
| [] -> failwith "THis should have never happened! Imma go cry"
| x :: xs -> 2;;

let x :: xs = [1; 2; 3];;

match (1, "hello") with
| (n, str) -> "something";;

let (n, str) = (1, "hello");;

match michael with
| { name; age } -> name ^ " " ^ string_of_int age;;

let { name = test; age } = michael;;

match Zero with
(* | Zero -> 0 *)
| Suc n -> 1;;

let Suc n = Zero;;

let n = 5;;
n;;
let n = 6;;
5 * n;;

let n = 5 in
let y = 239847 in
print_endline (string_of_int y);
ignore (string_of_int y);
n;;

print_endline (let s = "hello" in s ^ " world");;

1 + 1;;
1 - 1;;
1 * 1;;
1 / 1;;
1.1 +. 1.1;;
-1;;
-.1.1;;

1 = 2;;
1 <> 2;;

1 :: [];;
[1] @ [2];;
"Hello " ^ "world";;
5 mod 2;;
f @@ x;; (* = f x;; *)

(f x) y;;
f @@ (x @@ y);;
f @@ (((x y) a) @@ z);;

x |> f;; (* = f x *)
2 |> (fun x -> x + 5) |> (fun x -> x * x) |> print_int;;

(f x) y;;

let x = "hello" in
match x with 1 -> true | _ -> false;;

(+);;
let (><) a b = a + b;;

let (-) a b = a - b

(fun a b c -> b c) (+) (-) 1 (-1);;
((((fun a b c -> b c) (+)) (-)) 1) (-1);;
(((fun b c -> b c) (-)) 1) (-1);;
((fun c -> (-) c) 1) (-1);;
((-) 1) (-1);;
(fun b -> 1 - b) (-1);;
1 - (-1);;
