open Thread
open Event

type file_reference = string
type file_content = string
type read_request = file_reference
type write_mode = Append | Replace
type write_request = file_reference * file_content * write_mode

let rec replace_assoc key replace = function
  | [] -> [ (key, replace None) ]
  | (k, v) :: xs when k = key -> (k, replace (Some v)) :: xs
  | x :: xs -> x :: replace_assoc key replace xs

let wrap_in_result f = try Ok (f ()) with e -> Error e

(* let wrap_in_result_unary f x = try Ok (f x) with e -> Error e *)
let result_to_error_option = function Ok _ -> None | Error e -> Some e

module type FileSystemInterface = sig
  type t

  val create_FileServer : unit -> t
  val kill : t -> unit
  val read : t -> read_request -> (file_content, exn) result
  val write : t -> write_request -> exn option
  val delete : t -> file_reference -> exn option
end

type request =
  | Read of read_request * (file_content, exn) result channel
  | Write of write_request * exn option channel
  | Delete of file_reference * exn option channel
  | Kill

module RunTimeFileServer : FileSystemInterface = struct
  type t = request channel

  let create_FileServer () =
    let chan = new_channel () in
    let rec help state =
      match sync (receive chan) with
      | Read (read_request, retchan) ->
          let ret = wrap_in_result (fun () -> List.assoc read_request state) in
          sync (send retchan ret);
          help state
      | Write ((file_reference, file_content, write_mode), retchan) ->
          sync (send retchan None);
          help
            (replace_assoc file_reference
               (fun old_content_option ->
                 match old_content_option with
                 | None -> file_content
                 | Some old_content -> (
                     match write_mode with
                     | Replace -> file_content
                     | Append -> old_content ^ file_content))
               state)
      | Delete (file_reference, retchan) ->
          let ret =
            if List.mem_assoc file_reference state then None
            else Some (Failure "This File doesnt exist, so it cant be deleted")
          in
          sync (send retchan ret);
          help (List.remove_assoc file_reference state)
      | Kill -> ()
    in
    let _ = create help [] in
    chan

  let read fileserver read_request =
    let chan = new_channel () in
    sync (send fileserver (Read (read_request, chan)));
    sync (receive chan)

  let write fileserver write_request =
    let chan = new_channel () in
    sync (send fileserver (Write (write_request, chan)));
    sync (receive chan)

  let delete fileserver file_reference =
    let chan = new_channel () in
    sync (send fileserver (Delete (file_reference, chan)));
    sync (receive chan)

  let kill fileserver = sync (send fileserver Kill)
end

module DiskFileServer : FileSystemInterface = struct
  type t = request channel

  let create_FileServer () =
    let chan = new_channel () in
    let rec help () =
      match sync (receive chan) with
      | Read (file_reference, retchan) ->
          let ret =
            wrap_in_result (fun () ->
                let ch = open_in ("files/" ^ file_reference) in
                let s = really_input_string ch (in_channel_length ch) in
                close_in ch;
                s)
          in
          sync (send retchan ret);
          help ()
      | Write ((file_reference, file_content, write_mode), retchan) ->
          let ret =
            result_to_error_option
              (wrap_in_result (fun () ->
                   let flags =
                     match write_mode with
                     | Replace ->
                         [ Open_wronly; Open_creat; Open_trunc; Open_text ]
                     | Append ->
                         [ Open_wronly; Open_creat; Open_append; Open_text ]
                   in
                   let ch =
                     open_out_gen flags 0o644 ("files/" ^ file_reference)
                   in
                   output_string ch file_content;
                   close_out ch))
          in
          sync (send retchan ret);
          help ()
      | Delete (file_reference, retchan) ->
          let ret =
            result_to_error_option
              (wrap_in_result (fun () ->
                   Sys.remove (Sys.getcwd () ^ "/files/" ^ file_reference)))
          in
          sync (send retchan ret);
          help ()
      | Kill -> ()
    in
    let _ = create help () in
    chan

  let read fileserver read_request =
    let chan = new_channel () in
    sync (send fileserver (Read (read_request, chan)));
    sync (receive chan)

  let write fileserver write_request =
    let chan = new_channel () in
    sync (send fileserver (Write (write_request, chan)));
    sync (receive chan)

  let delete fileserver file_reference =
    let chan = new_channel () in
    sync (send fileserver (Delete (file_reference, chan)));
    sync (receive chan)

  let kill fileserver = sync (send fileserver Kill)
end
