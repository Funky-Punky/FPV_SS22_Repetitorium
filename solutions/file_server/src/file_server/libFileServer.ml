open LibCommon
open LibFileSystem
open Event
open Thread

module type FileServer = sig
  type t

  exception FileNotFound

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

  exception FileNotFound

  type t = request channel

  let create_file_server () =
    let chan = new_channel () in
    let rec help state =
      match sync (receive chan) with
      | Read (read_request, retchan) ->
          let tmp = wrap_in_result (fun () -> FS.read state read_request) in
          let ret = match tmp with Error _ -> Error FileNotFound | x -> x in
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

module RunTimeFileServer = MyFileServer (RunTimeFileSystem)
module DiskFileServer = MyFileServer (DiskFileSystem)
