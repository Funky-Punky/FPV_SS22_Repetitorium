open Event
(* open Thread *)



(* Error handling *)

(*
   the Syntax for try .. with ...  is:

   try
     ...             <- the expression you want to evaluate
   with
     | ... -> ...    <- a pattern matching over the exceptions you want to catch
     | ... -> ...
*)

let divide a b = try a / b with Division_by_zero -> -1
let infinity = divide 1 0

(* You can define custom exceptions like so: *)

exception Invalid_Age of string

(* Use the raise keyword to raise exceptions *)
let age_of_string s =
  let i =
    try int_of_string s
    with Failure _ -> raise (Invalid_Age "String is not an Integer")
  in
  if i < 0 then raise (Invalid_Age "Age cant be smaller than Zero")
  else if i > 900 then raise (Invalid_Age "No one can be that old")
  else i

(* failwith ist just this: (this is taken from Ocaml Libraries) *)
let failwith msg = raise (Failure msg)

(*
   the Type "result" as a possibility to return an error as a value
     Its like an Option, but more advanced.
*)

type ('a, 'e) t = ('a, 'e) result = Ok of 'a | Error of 'e

let res s = try Ok (int_of_string s) with Failure msg -> Error (Failure msg)

(* Unit Chaining *)

(*
  Unit is a datatype, that only has one value.
  Imagine it like this: int is a type, that can assume the values 0, 5, 222, -10 and so on
                        unit is a type, that can assume the values ()    <- open and closed brackets

  It is usefull, for a few things:
    -specifiing, that a function doesnt have a return parameter
    -creating a function, that doesnt have an input parameter
    -wrapping functions, so they can be evaluated layzily later
    -...
*)

(* 
   If a expression evaluates to an unit, you can drop this unit, by adding an ";".
   The line of Code is executed, the result (unit) is thrown away (what would you want to do with it anyways) and the next line is evaluated.
*)

let talkative_add a b =
  print_endline "Hi, my Name is Addy";
  print_endline "I will be your Number One Adder Tonight";
  print_endline "Here Goes:";
  let sum = a + b in
  print_endline "That wasnt to bad :)";
  print_endline "Bon Appétit:";
  sum

(* 
    example for a function, that uses unit. Look at the signature for List.iter
*)

let () = List.iter (fun x -> print_endline (string_of_int x)) [ 1; 2; 3; 4 ]

(* Side Effects *)

let (), () =
  let x = print_endline "foo" in
  (x, x)

let (), () =
  let x () = print_endline "foo" in
  (x (), x ())

(*
     1. What are side-effects? Give some examples.
     2. What are pure functions? What are their benefits?
     3. Why does delaying evaluation only make sense in case of side-effects or in presence of non-terminating expressions?
     4. Why do we want to use () instead of some unused variable or the discard _?
*)

(* Jonas' File Handling API *)

(*
  often used Functions (Documentation can be found at https://v2.ocaml.org/api/Stdlib.html)

  Types:
    type in_channel
    type out_channel

  Channel Management:
    open_in : string -> in_channel      (filename)
    open_out : string -> out_channel
    flush : out_channel -> unit

    close_in : in_channel -> unit
    close_out : out_channel -> unit


  Writing:
    output_string : out_channel -> string -> unit

  Reading:
    input_line : in_channel -> string
    String.split_on_char : char -> string -> string list

  Misc:
    Sys.getcwd () 
      (* returns the current working directory as a String *)
    Sys.remove <filepath>
      (* removes the given file from the file system *)
*)


(* TASK: Do the IntListDatabase assignment, then continue here *)

(*
   Threads:

   type t

   Thread.create : ('a -> 'b) -> 'a -> t      (* creates a thread, that executes the given function with the given argument. Returns a handle to the created Thread *)
   Thread.join : t -> unit                    (* the Thread that executes this function is blocked until the Thread t has halted, *)
   Thread.self : unit -> t                    (* returns the executing thread *)
   Thread.id : t -> int                       (* return the id of a given thread *)


   Channel:

   About Channels:
    Channels are a method, by which threads can communicate with each other. They are Bidirectional, so elements can be sent both ways.
    Note that a channel has a polymorohic type, so there can be a thing such as a "int option list channel"
    It has two important functions:
      1. Recieving: sync(recieve <chan>)   The recieve function blocks execution until some other thread has given some value to the thread. It returns said value
      2. Sending: sync(send <chan> <val>)  Send sends the given value into the given Channel. 
         IMPORTANT: It is a little unintuitive, but the Ocaml channel implementation doesnt have some kind of buffer to store sent, but not yet recieved elements.
                    Send also blocks execution until some other thread has recieved the sent element.


   Event.new_channel : unit -> 'a channel

   sync(send <chan> <val>) : unit
   sync(recieve <chan>) : 'a
*)

(* Thread-Safe Server *)

type server_request = Req1 of int | Req2

let start_server () =
  let channel = Event.new_channel () in
  let help thread_state =
    match sync (receive channel) with
    | Req1 _ -> failwith "Handle this Request and then tail recursion"
    | Req2 -> failwith "Handle this Request and then tail recursion"
  in
  let _ = Thread.create help [] in
  channel

let req1 server arg = sync (send server (Req1 arg))
let req2 server = sync (send server Req2)

module type Map = sig
  type ('k, 'v) t
  type 'k key
  type 'v value

  val create_map : unit -> ('k, 'v) t
  val put : ('k, 'v) t -> 'k key -> 'v value -> unit
  val get : ('k, 'v) t -> 'k key -> 'v value option
end

type ('k, 'v) request = Put of ('k * 'v) | Get of ('k * 'v option channel)

(* module MyMap :
     Map
       with type 'a key = 'a
        and type 'v value = 'v = struct
     type ('k, 'v) t = ('k, 'v) request channel
     type 'k key = 'k
     type 'v value = 'v

     let create_map () =
       let channel = Event.new_channel () in
       let rec help assoq_list =
         match sync (receive channel) with
         | Put (key, value) ->
             help ((key, value) :: List.remove_assoc key assoq_list)
         | Get (key, retchan) ->
             let value = List.assoc_opt key assoq_list in
             sync (send retchan value);
             help assoq_list
       in
       let _ = Thread.create help [] in
       channel

     let put map key value = sync (send map (Put (key, value)))

     let get map key =
       let channel = Event.new_channel () in
       sync (send map (Get (key, channel)));
       sync (receive channel)
   end *)
