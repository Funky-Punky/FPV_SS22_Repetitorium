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

(*

Lets analyze this preset:

First the type server_request: Well these are the kinds of requests we can send to the server

Now the start_server function:
      First we create a channel. Notice that in the last line this channel is returned. Why is that? What happens in this function, 
        is that we first create a request channel and then we create a Thread, that "listenes" on this channel for eternity. 
        If another Thread wants to interact with out server it has to send a request through said channel. 
        If we execute the start_server function, what we get is a handle to the server. And thats really all we need

      Then we create a helper function. This is the function the serverThread will execute up until eternity. That is why it needs to be tail recursive.
        This function first recieves a request out of the channel we created. It then handles the request and starts a new recursion.
        Now what about the parameter of the helper function: If our server needs to store some data, it can do so by altering said parameter for the next recursion.
        The next iteration will reach the recieve call and wait for a new request. And because our server spends all his time in the loop, the value is never dropped,
      
      Now the actual thread is created. The function it should execute is of course the helper function and the argument it the initial state for our server.
        Note that the thread_handle returned by Thread.create is dropped and forgotten. We dont need it, because we will use the channel to talk to out server.

      aaaaand the channel from the beginning is returned and we are finished.

The req1 and req2 functions:
    Those are gonna be executed by the Thread, that requests someting from us.
    They take a "server" (which is only the handle to the serverthread and a channel) and all the arguments they need.
    Then they send a request through the channel where the server is waiting.

What if the server needs to return something? 
    The sollution is a bit complicated: The communication must happen over channels right?
    So the requester creates a channel and sends this channel together with his request through the server channel
    The Server then can use this second channel to send his answer through.
    
    In the server_request type this looks like this:

    type server_request = 
              | Set of (int * int)          <- index * value
              | Get of (int * int channel)  <- index * return-channel


*)

type server_request = Req1 of int | Req2

let start_server () =
  let channel = Event.new_channel () in
  let help server_state =
    match sync (receive channel) with
    | Req1 _ -> failwith "Handle this Request and then tail recursion"
    | Req2 -> failwith "Handle this Request and then tail recursion"
  in
  let _ = Thread.create help [] in
  channel

let req1 server arg = sync (send server (Req1 arg))
let req2 server = sync (send server Req2)

(*
    This is a Example for a module type Map and a Thread safe implementation.
*)

module type Map = sig
  type ('k, 'v) t
  type 'k key
  type 'v value

  val create_map : unit -> ('k, 'v) t
  val put : ('k, 'v) t -> 'k key -> 'v value -> unit
  val get : ('k, 'v) t -> 'k key -> 'v value option
end

type ('k, 'v) request = Put of ('k * 'v) | Get of ('k * 'v option channel)

module MyMap : Map with type 'a key = 'a and type 'v value = 'v = struct
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
end
