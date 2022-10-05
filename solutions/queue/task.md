# Thread-safe Queue

Consider the following functionalities:
```ocaml
  exception NoElementLeft

  create_queue : unit -> 'a queue
  enqueue : 'a queue -> 'a -> unit
  dequeue_opt : 'a queue -> 'a option
  dequeue : 'a queue -> 'a              (* Throws a 'NoElementLeft' exception if no element is left *)
  empty : 'a queue -> unit              (* deletes every element*)
  reverse : 'a queue -> unit            (* reverses the order of the elements *)
  discard_queue : 'a queue -> unit      (* opposite of create_queue *)
```
Your Task: Create a module type signature for the above funtionalities and an Impementation of said module
1. Create a module type for signature these functions. It should be called ```Queue```
2. Create a module implementation of ```Queue``` it must be called ```MyQueue```\
   The Implementation must be safe for multiple threads to use.


Tipp: Create all the Method stumbs with simple ```failwith ""``` implementions first.\
Tipp: Use ```dune test``` to execute some tests. But be aware: They dont test for thread safety. Only for funtionality.\
