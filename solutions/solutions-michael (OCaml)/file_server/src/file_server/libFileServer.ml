open LibCommon
open LibFileSystem
open Event
open Thread

module type FileServer = sig
  type t

  exception FileNotFound

  val create_file_server : unit -> t
  val read : t -> read_request -> file_content
  val write : t -> write_request -> unit
  val delete : t -> file_reference -> unit
  val kill : t -> unit
end

module PlaceholderFileServer = struct
  type t = unit

  exception FileNotFound

  let create_file_server () = ()
  let read server req = failwith "TODO"
  let write server req = failwith "TODO"
  let delete server req = failwith "TODO"
  let kill server = failwith "TODO"
end

(* TODO *)
module CreateFileServer (FS : FileSystem) : FileServer = struct
  type request =
    | Read of (file_reference * (file_content, exn) result Event.channel)
    | Write of
        (file_reference * file_content * (unit, exn) result Event.channel)
    | Delete
    | Kill

  type t = request Event.channel * Thread.t

  exception FileNotFound

  let wrap_ok f x = try Ok (f x) with e -> Error e
  let unwrap_result = function Ok v -> v | Error e -> raise e

  let rec serve fs request_channel =
    match Event.sync @@ Event.receive request_channel with
    | Kill -> ()
    | Read (filename, response_channel) ->
        wrap_ok (FS.read fs) filename
        |> Event.send response_channel
        |> Event.sync;
        serve fs request_channel
    | Write (filename, content, res_channel) ->
        wrap_ok (FS.write fs) (filename, content)
        |> Result.map ignore |> Event.send res_channel |> Event.sync;
        serve fs request_channel
    | Delete -> () (* TODO *)

  let create_file_server () =
    let fs = FS.init () in
    let request_channel = Event.new_channel () in
    (request_channel, Thread.create (serve fs) request_channel)

  let read (req_channel, _) filename =
    let res_channel = Event.new_channel () in
    Event.sync @@ Event.send req_channel @@ Read (filename, res_channel);
    Event.sync @@ Event.receive res_channel |> unwrap_result

  let write server req = failwith "TODO"
  let delete server req = failwith "TODO"

  let kill (request_channel, thread) =
    Event.sync @@ Event.send request_channel Kill;
    Thread.join thread
end

(* TODO *)
module InMemoryFileServer = PlaceholderFileServer

(* TODO *)
module OnDiskFileServer = PlaceholderFileServer
