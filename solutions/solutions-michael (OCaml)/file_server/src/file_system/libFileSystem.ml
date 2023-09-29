open LibCommon

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

  let write state ((file_reference, content, write_mode) : write_request) =
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
    let ch = open_out_gen flags 0o644 ("files/" ^ file_reference) in
    output_string ch file_content;
    close_out ch

  let delete () file_reference =
    Sys.remove (Sys.getcwd () ^ "/files/" ^ file_reference)
end
