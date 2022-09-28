(((1) + (1)) + (1));;

(2 / 4) / 7;;
2 / (4 / 7);;

2 / (4 / 7);;

1 + 2 * 3;;
((1) + ((2) * (3)));;
(1 + 2) * 3;;

let x = 1 in x;;
(let x = (1) in (x));;

let x = (let y = 10 in 2 * y) in x - 7;;
(let x = (let y = (10) in ((2) * (y))) in ((x) - (7)));;

let x = (1);;

match 10 with 0 -> true | n -> false;;
(match (10) with 0 -> (true) | n -> (false));;

if condition then expression1 else expression2;;
match condition with true -> expression1 | false -> expression2;;

(if (((x) + (1)) > (0)) then ((7) + (x)) else ((7) - (x)));;

(match ([(2); ((3) * (7)); ((f) (x))]) with [] -> (true) | x :: xs -> ((g) ((not) (x))));;

([]);;
((1) :: ([]));;
(((1) + (2)) :: ((3) :: ([])));;


[1; 2; 3; 4];;
1 :: 2 :: 3 :: 4 :: [];;

(fun x -> (x));;


fun x y -> x + y;;
(fun x -> (fun y -> ((x) + (y))));;

let join a b = [a; b];;
let join = (fun a -> (fun b -> ((a) :: ((b) :: ([])))));;

let f _ =
  (let impl _ = ... in
  impl 0);;

let rec sum = function [] -> 0 | x :: xs -> x + sum xs in sum [1; 2; 3];;
(let rec sum =
  (fun l -> (match (l) with [] -> (0) | x :: xs -> ((x) + ((sum) (xs)))))
  in ((sum) ((1) :: ((2) :: ((3) :: ([]))))));;

((f) (x));;
((fun x -> (x)) (5));;

((1), ("asdf"));;

(((4), (true), (" asdf "), ((2) :: ([]))));;

((((List.fold_left) ( + )) (0)) (((List.map) (( * ) (2))) (((List.cons) (1)) ((2) :: ((3) :: ([]))))))


let flip f a b = f b a in flip ( - ) 2 3
(let flip =
  (fun f -> (fun a -> (fun b -> (((f) (b)) (a)))))
  in ((((flip) ( - )) (2)) (3)))


let y a b c = a c b in List.map (y (@@) [2; 3; 4]) [List.cons 1; (@) [0; 4]]

module Peter = struct
  type t = string

  let f = 234
end

Peter.
