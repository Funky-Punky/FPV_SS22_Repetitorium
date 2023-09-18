# Equational Reasoning

## Template

Be sure to always use this template

```text
Generalized statement (*) (if necessary): <...>
---
Base Case:
Statement being proven in base case: <...>
Proof of base case:
<...>
---
Inductive Step:
Induction hypothesis (or hypotheses): <...>
Statement being proved in inductive step: <...>
Proof of inductive step:
<...>
---
Instantiation of generalization (if necessary):
<...>
---
QED
```

Write your answer as plain text. For all equational proofs that show the equivalence of two MiniOCaml expressions, annotate each step as follows:

```text
           e_1
(rule 1) = e_2
(rule 2) = e_3
...
(rule n) = e_n
```

For each step, when you:

+ apply the definition of a function `f`, the rule must be `f`
+ apply a (lambda-) function, the rule must be `fun`
+ apply an induction hypothesis, the rule must be `I.H`
+ simplify an arithmetic expression, the rule must be `arith`
+ select a branch in a match expression, the rule must be `match`
+ expand a let defintion (local definition), the rule must be `let`
+ apply a lemma `L` that you have already proven in the exercise, the rule must be `L`

## Predefined functions

For all of the following tasks, these functions are predefined:

```ocaml
let rec fold_left f acc l =
  match l with [] -> acc | h :: t -> fold_left f (f acc h) t

let rec fold_right f l acc =
  match l with [] -> acc | h :: t -> f h (fold_right f t acc)

let rec map f l =
  match l with [] -> [] | h :: t -> f h :: map f t

let rec nlen n l =
  match l with [] -> 0 | h :: t -> n + nlen n t

let rec len_tr acc l = 
  match l with [] -> acc | _ :: t -> len_tr (acc + 1) t
```

## Tasks

Assume, that all expressions terminate.

1. Answer the following questions
    + How can we prove that two expressions evaluate to the same value for all inputs?
    + Which proving-technique can we use to prove that a function behaves correctly for *all* possible inputs?
    + What is generalization? When is it necessary?
    + Why do we need an instantiation step?

2. Do the first exercise on equational reasoning [w12t01](https://artemis.ase.in.tum.de/courses/253/exercises/10310) on Equational Reasoning.

3. Show that the statement

    ```ocaml
    fold_right (fun e a -> g e :: a) l []   =   map g l
    ```

    holds for all Lists l and functions g.
4. Show that the statement

    ```ocaml
    fold_left (fun acc _ -> acc + 1) 0 l   =   len_tr 0 l
    ```

    holds for all Lists l.
5. Show that the statement

    ```ocaml
    nlen n l   =   fold_left (+) 0 (map (fun _ -> n) l)
    ```

    holds for all Lists l.
6. Show that the statement

   ```ocaml
   fold_left (+) 0 l   =   fold_right (+) l 0
   ```

   holds for all Lists l.
7. Consider the following functions

   ```ocaml
   let rec fac n = if n < 1 the 1 else n * fac (n-1)

   let rec facc_help f n =
     if n <= 0 then f 1
     else facc_help (fun p -> f (n*p)) (n-1)

   let facc n = 
     facc_help (fun x -> x) n
   ```

   Show that the statement

   ```ocaml
   facc n   =   fac n
   ```

   for all non negative n.
   Hint: You didnt learn a rule for *if-then-else*, but you can invent one yourself. If you want you can also
   rewrite it to a match expression and use the known rule for that.
8. Do the third exercise on Equational Reasoning [w12t03](https://artemis.ase.in.tum.de/courses/253/exercises/10312)
9. Consider the following function:

   ```ocaml
   let comp f g x = f (g x)
   ```

   Show that the statement

    ```ocaml
    map (cmp f g) l   =   comp (map f) (map g) l
    ```

    holds for all Lists l as well as all functions g and f.

10. Consider the following function:

    ```ocaml
    let app l1 l2 = 
      match l1 with [] -> l2 | h :: t -> h :: app t l2
    ```

    Show that the statement

    ```ocaml
    fold_left (fun a e -> app a [g e]) [] l   =   map g l
    ```

    holds for all Lists l and functions g.\
    Hint: If you manage to do this, then you are waaaayyy more prepared, than you need to be.
