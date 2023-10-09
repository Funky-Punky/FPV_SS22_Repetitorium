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

type color = Red | Green | Blue | Orange

let string_of_color = function
  | Red -> "red"
  | Green -> "green"
  | Blue -> "blue"
  | Orange -> "orange"

exception No_such_student of string
exception Has_no_favorite_color of string
exception Has_bad_favorite_color of string * color

let students = [ ("Michael", Some Orange); ("Hugo", Some Red); ("Angel", None) ]

let rec get_favorite_color_by_name name = function
  | [] -> raise (No_such_student name)
  | (n, c) :: _ when n = name -> (
      match c with
      | None -> raise (Has_no_favorite_color name)
      | Some Red -> raise (Has_bad_favorite_color (name, Red))
      | Some c -> c)
  | _ :: rest -> get_favorite_color_by_name name rest
;;

try
  get_favorite_color_by_name "Michael" students
  |> string_of_color |> print_endline
with
| No_such_student name -> print_endline @@ name ^ " doesn't exist"
| Has_no_favorite_color name -> print_endline @@ name ^ " is boring"
| Has_bad_favorite_color (name, c) ->
    print_endline @@ name ^ " incorrectly thinks that " ^ string_of_color c
    ^ " is cool"

(* failwith ist just this: (this is taken from Ocaml Libraries) *)
let failwith msg = raise (Failure msg)

(*
   the Type "result" as a possibility to return an error as a value
     Its like an Option, but more advanced.
*)

type ('a, 'e) t = ('a, 'e) result = Ok of 'a | Error of 'e

let res s = try Ok (int_of_string s) with Failure msg -> Error (Failure msg)

(* Unit Chaining *)
(* ; is like unit -> 'a -> 'a *)
let ( ||| ) () x = x;;

print_endline "hey" ||| 3;;

print_endline "hey";
3

let ignore _ = ();;

read_line () |> ignore;
3

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
    Printf.fprintf : out_channel -> ('a, out_channel, unit) format -> 'a

  Reading:
    input_line : in_channel -> string
    String.split_on_char : char -> string -> string list

  Misc:
    Sys.getcwd () 
      (* returns the current working directory as a String *)
    Sys.remove <filepath>
      (* removes the given file from the file system *)
*)

let filename = "example.txt"

(* Output *)
let write_file = open_out filename;;

output_string write_file @@ "Hello" ^ " " ^ "World!";
output_string write_file @@ Printf.sprintf "%s %s" "Hello" "World!";
Printf.fprintf write_file "%s %s" "Hello" "World!";
close_out write_file;
()

(* Input *)
let read_file = open_in filename
let line = input_line read_file

let hello, world =
  match String.split_on_char ' ' line with
  | [ hello; world ] -> (hello, world)
  | _ ->
      close_in read_file;
      failwith "incorrect format"

let read_file = Scanf.Scanning.from_channel @@ open_in filename
let read_file = Scanf.Scanning.open_in filename

let hello, world =
  Fun.protect
    (fun () ->
      Scanf.bscanf read_file "%s %s\n" (fun hello world -> (hello, world)))
    ~finally:(fun () -> Scanf.Scanning.close_in read_file)

let hello, world =
  Fun.protect
    (fun () ->
      Scanf.bscanf read_file "%s@ %s\n" (fun hello world -> (hello, world)))
    ~finally:(fun () -> Scanf.Scanning.close_in read_file)
;;

Sys.remove filename

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

type request =
  | Post of string * string
  | Get of string * string Event.channel
  | Kill

let rec server request_channel state =
  match Event.sync @@ Event.receive request_channel with
  | Kill -> ()
  | Post (key, value) -> server request_channel @@ ((key, value) :: state)
  | Get (key, response_channel) ->
      List.assoc key state |> Event.send response_channel |> Event.sync;
      server request_channel state

let start_server () =
  let request_channel = Event.new_channel () in
  (Thread.create (server request_channel) [], request_channel)

let quit_server (server_thread, request_channel) =
  Event.sync @@ Event.send request_channel Kill;
  Thread.join server_thread

let post (_, request_channel) key value =
  Event.sync @@ Event.send request_channel @@ Post (key, value)

let get (_, request_channel) key =
  let response_channel = Event.new_channel () in
  Event.sync @@ Event.send request_channel @@ Get (key, response_channel);
  Event.sync @@ Event.receive response_channel

(* Usage *)
let server = start_server ();;

post server "Michael" "Orange";
post server "Hugo" "Red"

let michaels_color = get server "Michael"
let angels_color = get server "Angel"
