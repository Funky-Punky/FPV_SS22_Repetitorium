# BigStep Proofs

1. Remember what BigStep Semantics is and what it fundamentally does.
   + How do expressions and values fit into the picture?
2. (Advanced) How does an interpreter compare to BigStep Semantics?
3. Look up all the rules for BigStep Semantics in the FPV-Script.

## Simple Evaluation

+  Answer the following questions:
   + How do you identify which rule to apply?
   + Why does recursion play such a big role in BigStep Semantics?

1. Do The first exercise on BigStepProofs [w11t01](https://artemis.ase.in.tum.de/courses/253/exercises/10336)

2. Evaluate and prove the following expression:

    ```ocaml
    let f = fun a -> 2+a*3 in 8 - f 1
    ```

3. Consider the following functions:

    ```ocaml
    let fst = fun t -> match t with (a, b) -> a
    let snd = fun t -> match t with (a, b) -> b
    ```

    Evaluate and prove the following expression:

    ```ocaml
    let x = (3+6, fun x -> x*4) in (snd x) (fst x)
    ```

4. Evaluate and prove the following expression:

    ```ocaml
    let x = 3+2 :: [] in match x with [n] -> (x, n+1)::[] | _ -> [([], 0)]
    ```

5. Consider the following functions:

    ```ocaml
    let f = fun a b -> b [2] a

    let rec g = fun l -> 
      match l with
        | x :: xs -> fun n -> x * n
        | _ -> fun n -> 0
    ```

    Evaluate and prove the following expression:

    ```ocaml
    f 6 g
    ```

6. Consider the following function:

    ```ocaml
    let rec rev = fun acc l ->
      match l with [] -> acc | x :: xs -> rev (x::acc) xs
    ```

    Evaluate and prove the following expression:

    ```ocaml
    rev [ ] [ 2; 8 ]
    ```

7. Consider the following functions:

    ```ocaml
    let rec fold_left = fun f acc l ->
      match l with [] -> acc | h :: t -> fold_left f (f acc h) t

    let mul = fun a b ->
      a * b
    ```

    Evaluate and prove the following expression:

    ```ocaml
    fold_left mul 2 [10]
    ```

8. Consider the following function:

    ```ocaml
    let comp = fun f g x ->
      f (g x)
    ```

    Evaluate and prove the following expression:

    ```ocaml
    (let a = comp (fun x -> 2 * x) in a (fun x -> x + 3)) 4
   ```

9.  Consider the following functions:

    ```ocaml
    let rec map f l =
      match l with [] -> [] | h :: t -> f h :: map f t

    let if = fun x ->
      x
    ```

    Evaluate and prove the following expression:

    ```ocaml
    map (id id) [8]
    ```

> **Note:** Performing a BigStep Proof to calculate the value of an expression is not difficult. Its more like a mechanical process (which unfurtunately requires a ton of writing) as you just have to strictly follow the BigStep-rules to arrive at the correct result. Remember that there only exists one rule which you can apply at each step, so you can't really make a mistake. You just need to be careful to identify the correct *shape* of the expression and to correctly *pattern match* the expression to the chosen rule.

## Induction Proofs

1. Answer the following questions:
   + What proving-technique can we use to prove that a function behaves correctly for *all* possible inputs greater than 0?
   + How can we show termination using this method?

2. Do the second exercise on BigStepProofs on [w11t02](https://artemis.ase.in.tum.de/courses/253/exercises/10337)

3. Consider the following functions:

    ```ocaml
    let rec impl = fun n a -> 
        match n with 0 -> a | _ -> impl (n-1) (a * n * n)
    let bar = fun n -> impl n 1
    ```

    Prove that ```bar n``` evaluates to ```n! *n!``` for all non-negative inputs.\
    Hint: Prove that ```impl n a``` evaluates to ```a* n! * n!``` first.
4. Consider the following functions:

   ```ocaml
   let rec doit a x =
     if x = 0
       then a
     else
       doit (a + 2*x - 1) (x-1)

   let square x = doit = 0 x
   ```

   Prove that square terminates for all positive inputs.
