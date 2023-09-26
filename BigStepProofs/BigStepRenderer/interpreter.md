# Interpreter for Big Step

As previously mentioned, big step evaluations are not hard at all. They just require a ton of writing. 
Furtunately, it is also very easy to come up with a simple program to automate this boring task.

## The Type System

To be able to differentiate between the different types of expressions, we will use a simple type system to represent them.

```ocaml
(* Todo: Add Pattern match expr *)
(* Todo: Add global definitions *)
type expr =
  | Const of int
  | Tuple of expr list
  | List of expr list
  | Fun of (string * expr)
  | App of (expr * expr)
  | Var of string
  | Let of (string * expr * expr)
  | Op of (expr * operator * expr)
```

Just with this simple type system, we can already represent a lot of different expressions.
    
```ocaml    
let number = Const 1
let tuple = Tuple [ Const 0; Const 1; Const 2]
let list = List [ Const 0; Const 1; Const 2]

let local_def = Let ("x", Const 1, Op (Var "x", Plus, Const 1))

(* or even write down formulas *)
let square = Fun ("x", Op (Var "x", Times, Var "x"))
let square_of_2 = App (square, Const 2)
```

## The Interpreter

If we want to evaluate these expressions, we can write a simple interpreter that does this for us.
You can find the code for this interpreter in `big_step_renderer.ml` file. The function is called `eval`.

We can use this interpreter to interpret the expressions we defined above.

```ocaml
eval square_of_2;;
- : expr = Const 4
```

In this case we get the correct result of the evaluation, which is `Const 4`.

## The Big Step Proof

If we want more than just the result of the evaluation, we can also use the interpreter to generate a big step proof for us. This means we will be basically implementing all the big step rules in OCaml. We do this in a way so that we can easily print the proof to the console.

The code for this can be found in the `big_step_renderer.ml` file. The function is called `render_bigstep_tree`.


Lets look at a few examples of how this works. Each indentation level represents a further step in the proof-tree.

Rule application is represented by the `+` symbol. The `=>` symbol represents the final result of the evaluation.


```ocaml
render_bigstep_tree tuple;;

(* Prints

+ TU (0, 1, 2)
    0 => 0
    1 => 1
    2 => 2
=> (0, 1, 2)

This checks out, as we need to individually evaluate each element of the tuple, to be able to evaluate the tuple itself.
*)
```

```ocaml
render_bigstep_tree local_def;;

(* Prints

+ LD let x = 1 in x + 1
    1 => 1
  + OP 1 + 1
      1 => 1
      1 => 1
      1 + 1 => 2
  => 2
=> 2

This also checks out. We need to evaluate the substited expression first, before we can substitute it into the original expression and perform the simple addition using the OP rule. 
*)
```

Lists are cool too, as the big step tree gets deep very quickly, due to the recursive nature of lists.

```ocaml
render_bigstep_tree list;;
    
(* Prints

+ LI [0; 1; 2]
    0 => 0
  + LI [1; 2]
      1 => 1
    + LI [2]
        2 => 2
      + LI []
      => []
    => [2]
  => [1; 2]
=> [0; 1; 2]
*)
```

The trees can get out of hand pretty quickly, if we have a lot of nested expressions. Lets look at a more complicated example.

In this example, we will evaluate the expression `let f = (fun x -> x * x + 7) in (f ((fun x -> x * x + 7) 3))`.

```ocaml
render_bigstep_tree complicated;;

(* Prints

+ LD let f = (fun x -> x * x + 7) in (f ((fun x -> x * x + 7) 3))
    (fun x -> x * x + 7) => (fun x -> x * x + 7)
  + APP ((fun x -> x * x + 7) ((fun x -> x * x + 7) 3))
      (fun x -> x * x + 7) => (fun x -> x * x + 7)
    + APP ((fun x -> x * x + 7) 3)
        (fun x -> x * x + 7) => (fun x -> x * x + 7)
        3 => 3
      + OP 3 * 3 + 7
        + OP 3 * 3
            3 => 3
            3 => 3
            3 * 3 => 9
        => 9
          7 => 7
          9 + 7 => 16
      => 16
    => 16
    + OP ((fun x -> x * x + 7) 3) * ((fun x -> x * x + 7) 3) + 7
      + OP ((fun x -> x * x + 7) 3) * ((fun x -> x * x + 7) 3)
        + APP ((fun x -> x * x + 7) 3)
            (fun x -> x * x + 7) => (fun x -> x * x + 7)
            3 => 3
          + OP 3 * 3 + 7
            + OP 3 * 3
                3 => 3
                3 => 3
                3 * 3 => 9
            => 9
              7 => 7
              9 + 7 => 16
          => 16
        => 16
        + APP ((fun x -> x * x + 7) 3)
            (fun x -> x * x + 7) => (fun x -> x * x + 7)
            3 => 3
          + OP 3 * 3 + 7
            + OP 3 * 3
                3 => 3
                3 => 3
                3 * 3 => 9
            => 9
              7 => 7
              9 + 7 => 16
          => 16
        => 16
          16 * 16 => 256
      => 256
        7 => 7
        256 + 7 => 263
    => 263
  => 263
=> 263

It spits out 263, which is the correct result. (The proof tree should hopefully also be correct, I am not going to check it though.)
*)
```

