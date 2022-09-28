# Day 2
## Partial Application
### Parameter order
Try and write the desired function using the provided function as concisely as possible. Then, you may re-order the provided function's parameters and adapt your own implementations to (ideally) make them even more consise. What do you notice?

```ocaml
(* Given *)
let fold_left l acc f = match l with [] -> acc | x :: xs -> fold_left xs (f acc x) f

(* Please implement *)
let sum = failwith "TODO: Compute the sum of all elements in the list"
```

### Random Exercises

1. Figure out what `||>` (see definition below) does and why it could be useful in combination with partial evaluation. Come up with three examples where it is helpful.
   ```ocaml
   let (||>) f g = fun x -> g (f x)
   let (|||>) f g = fun x y -> g (f x y)
   (float_of_int ||> string_of_float ) 1
   1 |> float_of_int |> string_of_float
   (||>) float_of_int string_of_float 1
   let string_of_int = float_of_int ||> string_of_float
   let double_of_squares =
      (fun x -> x * x) ||> ( * ) 2
   ```
2. Implement the following function without explicitly accepting all the arguments. You may change the order of the arguments, if it seems helpful. However, make sure to not change the return type! `val pipe_many : 'a -> ('a -> 'a) list -> 'a`

## Lazy evaluation
```ocaml
type 'a inf_list = Cons of 'a * (unit -> 'a inf_list)
```
1. After we discuss a suitable type for infinite lists in class, implement these functions
   1. integers - creates an infinite list of ascending integers starting at some n
   2. take - takes the first n elements out of an infinite lists and puts them into a normal list
   3. map - like normal map, but compatible with infinite lists
   4. filter - same
   5. Two other functions from the List module that you deem suitable. Make sure they make sense for infinite lists before starting yor implementation!
2. Implement utility functions for lazily evaluated methods (i.e. `unit -> 'a` functions)
   1. Implement map
   2. Implement bind. Bind is like map, but the mapping function returns a new lazy that is then used instead of a plain value that must then be wrapped in a lazy by map
   3. Implement combine, which takes to lazies and combines them to a lazy of the tuple of their results

## Tail recursion
1. Pull the newest version of the repository and check out our recursive list functions. Make them all tail-recursive
2. Take a look at the BST implementations. Re-implement inorder, preorder, postorder, and height to be tail-recursive
3. Implement [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) tailrecursively
   ```ocaml
   type node = int
   type weight = int
   type edge = node * weight * node
   type graph = edge list

   val dijkstra : graph -> edge list
   ```

## Sub-expressions
Find all sub-expressions of these expressions and determine their types. Also determine the type and value of the expressions 

1. ```ocaml
   (let foo = ("bar") in ((print_endline) (foo)))
    ```
2. ```ocaml
   (((float_of_int) ((1) + (2))) *. (3.5))
   ```
3. ```ocaml
   [2; 3] |> List.cons 1 |> List.map (( * ) 2) |> List.fold_left ( + ) 0
   List.fold_left ( + ) 0 (List.map (( * ) 2) (List.cons 1 [2; 3]))
   List.fold_left ( + ) 0 (List.map (( * ) 2) (List.cons 1 (2 :: 3 :: [])))
    ```
4. ```ocaml
   let flip f a b = f b a in flip ( - ) 2 3
    ```
5. ```ocaml
   let y a b c = a c b in List.map (y (@@) [2; 3; 4]) [List.cons 1; (@) [0; 4]]
   ```
