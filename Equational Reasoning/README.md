# Equational Reasoning

## Template

Be sure to always use this template

```
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

1. Do the first exercise on [Artemis](https://artemis.ase.in.tum.de/courses/253/exercises/10310) on Equational Reasoning.

2. Show that the statement

    ```ocaml
    fold_right (fun e a -> g e :: a) l []   =   map g l
    ```

    holds for all Lists l and functions g.
3. Show that the statement

    ```ocaml
    fold_left (fun acc _ -> acc + 1) 0 l   =   len_tr 0 l
    ```

    holds for all Lists l.
4. Show that the statement

    ```ocaml
    nlen n l   =   fold_left (+) 0 (map (fun _ -> n) l)
    ```

    holds for all Lists l.
5. Show that the statement

   ```ocaml
   fold_left (+) 0 l   =   fold_right (+) l 0
   ```

   holds for all Lists l.
6. Consider the following functions

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
   holds for all Lists l.\
   Hint: You didnt learn a rule for if, but it must be like match but easier, right. Im sure you can figure it out.
7. Do the third exercise on [Artemis](https://artemis.ase.in.tum.de/courses/253/exercises/10312) on Equational Reasoning.
8. Consider the following function:

   ```ocaml
   let comp f g x = -> f (g x)
   ```

   Show that the statement

    ```ocaml
    map (cmp f g) l   =   comp (map f) (map g) l
    ```

    holds for all Lists l as well as all functions g and f.
9. Consider the following function:

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
