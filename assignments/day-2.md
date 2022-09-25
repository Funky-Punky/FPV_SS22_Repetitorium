# Day 2

## Sub-expressions
Find all sub-expressions of these expressions and determine their types. Also determine the type and value of the expressions 

1. ```ocaml
   let foo = "bar" in print_endline foo
    ```
2. ```ocaml
   (float_of_int (1 + 2)) *. 3.5
   ```
3. ```ocaml
   [2; 3] |> List.cons 1 |> List.map (( * ) 2) |> List.fold_left ( + ) 0
    ```
4. ```ocaml
   let flip f a b = f b a in flip ( - ) 2 3
    ```
5. ```ocaml
   let y a b c = a c b in List.map (y (@@) [2; 3; 4]) [List.cons 1; (@) [0; 4]]
    ```
