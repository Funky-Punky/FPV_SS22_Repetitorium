open Thread
open Event

type file_reference = string
type file_content = string
type file = file_reference * file_content
type read_request = file_reference
type write_mode = Append | Replace
type write_request = file_reference * file_content * write_mode

let rec replace_assoc key replace = function
  | [] -> [ (key, replace None) ]
  | (k, v) :: xs when k = key -> (k, replace (Some v)) :: xs
  | x :: xs -> x :: replace_assoc key replace xs

let wrap_in_result f = try Ok (f ()) with e -> Error e
(* let wrap_in_result_unary f x = try Ok (f x) with e -> Error e *)

module type FileSystem = sig
  type t

  val init : unit -> t
  val kill : t -> unit
  val read : t -> read_request -> file_content
  val write : t -> write_request -> t
  val delete : t -> file_reference -> t
end

module RunTimeFileSystem : FileSystem = struct
  type t = file list

  let init () = []
  let kill _ = ()
  let read state read_request = List.assoc read_request state

  let write state
      ((file_reference, content, write_mode) : write_request) =
    replace_assoc file_reference
      (fun old_content_option ->
        match old_content_option with
        | None -> content
        | Some old_content -> (
            match write_mode with
            | Replace -> content
            | Append -> old_content ^ content))
      state

  let delete state file_reference = List.remove_assoc file_reference state
end

module DiskFileSystem : FileSystem = struct
  type t = unit

  let init () = ()
  let kill _ = ()

  let read () file_reference =
    let ch = open_in ("files/" ^ file_reference) in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s

  let write () (file_reference, file_content, write_mode) =
    let flags =
      match write_mode with
      | Replace -> [ Open_wronly; Open_creat; Open_trunc; Open_text ]
      | Append -> [ Open_wronly; Open_creat; Open_append; Open_text ]
    in
    let ch = open_out_gen flags 0o544 ("files/" ^ file_reference) in
    output_string ch file_content;
    close_out ch

  let delete () file_reference =
    Sys.remove (Sys.getcwd () ^ "/files/" ^ file_reference)
end

module type FileServer = sig
  type t

  val create_file_server : unit -> t
  val read : t -> read_request -> (file_content, exn) result
  val write : t -> write_request -> exn option
  val delete : t -> file_reference -> exn option
  val kill : t -> unit
end

module MyFileServer (FS : FileSystem) : FileServer = struct
  type request =
    | Read of read_request * (file_content, exn) result channel
    | Write of write_request * exn option channel
    | Delete of file_reference * exn option channel
    | Kill

    type t = request channel
  let create_file_server () =
    let chan = new_channel () in
    let rec help state =
      match sync (receive chan) with
      | Read (read_request, retchan) ->
          let ret = wrap_in_result (fun () -> FS.read state read_request) in
          sync (send retchan ret);
          help state
      | Write (write_request, retchan) -> (
          match wrap_in_result (fun () -> FS.write state write_request) with
          | Ok new_state ->
              sync (send retchan None);
              help new_state
          | Error e ->
              sync (send retchan (Some e));
              help state)
      | Delete (file_reference, retchan) -> (
          match wrap_in_result (fun () -> FS.delete state file_reference) with
          | Ok new_state ->
              sync (send retchan None);
              help new_state
          | Error e ->
              sync (send retchan (Some e));
              help state)
      | Kill -> failwith ""
    in
    let _ = create help (FS.init ()) in
    chan

  let read file_server read_request =
    let chan = new_channel () in
    sync (send file_server (Read (read_request, chan)));
    sync (receive chan)

  let write file_server write_request =
    let chan = new_channel () in
    sync (send file_server (Write (write_request, chan)));
    sync (receive chan)

  let delete file_server file_reference =
    let chan = new_channel () in
    sync (send file_server (Delete (file_reference, chan)));
    sync (receive chan)

  let kill file_server = sync (send file_server Kill)
end

module Ramfile_server = MyFileServer (RunTimeFileSystem)
module Diskfile_server = MyFileServer (DiskFileSystem)
