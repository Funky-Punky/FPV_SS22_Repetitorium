# Equational Reasoning

1. Do the first exercise on [Artemis](https://artemis.ase.in.tum.de/courses/189/exercises/7329) on Equasional Reasoning.
2. Consider the following functions:
    ```ocaml
    let rec fold_left f accu l =
      match l with [] -> accu | a :: l -> fold_left f (f accu a) l
     
    let rec length_aux len l = match l with [] -> len | _ :: l -> length_aux (len + 1) l
    ```
    Show that the statement
    ```ocaml
    fold_left (fun acc _ -> acc + 1) 0 xs   =   lenth_aux (len + 1) l
    ```
    holds for all Lists xs.
3. Consider the following functions:
    ```ocaml
    let rec fold_left f accu l =
      match l with [] -> accu | a :: l -> fold_left f (f accu a) l
    
    let rec fold_right f l accu =
      match l with [] -> accu | a :: l -> f a (fold_right f l accu)
   ```
   Show that the statement
   ```ocaml
   fold_left (fun acc x -> acc + x) 0 xs   =   fold_right (fun x acc -> x + acc) xs 0
   ```
   holds for all Lists xs.





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