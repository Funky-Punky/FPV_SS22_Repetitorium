open Event
(* open Thread *)

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

(* Error handling *)

let divide a b = try a / b with Division_by_zero -> -1
let infinity = divide 1 0

exception Invalid_Age of string

let age_of_string s =
  let i =
    try int_of_string s
    with Failure _ -> raise (Invalid_Age "String is not an Integer")
  in
  if i < 0 then raise (Invalid_Age "Age cant be smaller than Zero")
  else if i > 900 then raise (Invalid_Age "No one can be that old")
  else i

let failwith msg = raise (Failure msg)

type ('a, 'e) t = ('a, 'e) result = Ok of 'a | Error of 'e

let res s = try Ok (int_of_string s) with Failure msg -> Error (Failure msg)

(* Unit Chaining *)

let talkative_add a b =
  print_endline "Hi, my Name is Addy";
  print_endline "I will be your Number One Adder Tonight";
  print_endline "Here Goes:";
  let sum = a + b in
  print_endline "That wasnt to bad :)";
  print_endline "Bon Appétit:";
  sum

let () = List.iter (fun x -> print_endline (string_of_int x)) [ 1; 2; 3; 4 ]

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
*)

(*
   Threads:

   type t

   Thread.create : ('a -> 'b) -> 'a -> t
   Thread.join : t -> unit
   Thread.self : unit -> t
   Thread.id : t -> int



   Channel:

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
    | Req1 _ ->
        failwith "Handle this Request and then tail recursion"
    | Req2 ->
        failwith "Handle this Request and then tail recursion"
  in
  let _ = Thread.create help [] in
  channel

let req1 chan arg = sync (send chan (Req1 arg))

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
