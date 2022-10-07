# BigStep Proofs

## Simple Evaluation

1. The first exercise on BigStepProofs on [Artemis](https://artemis.ase.in.tum.de/courses/189/exercises/7211)
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

## Induction Proofs

1. The second exercise on BigStepProofs on [Artemis](https://artemis.ase.in.tum.de/courses/189/exercises/7212)

2. Consider the following functions:
    ```ocaml
    let rec impl = fun n a -> 
        match n with 0 -> a | _ -> impl (n-1) (a * n * n)
    let bar = fun n -> impl n 1
    ```
    Prove that ```bar n``` evaluates to ```n! * n!``` for all non-negative inputs.\
    Hint: Prove that ```impl n a``` evaluates to ```a * n! * n!``` first.

## Bonus exercises

coming soon...