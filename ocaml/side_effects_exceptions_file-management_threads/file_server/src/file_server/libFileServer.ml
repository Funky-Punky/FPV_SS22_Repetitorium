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
module CreateFileServer (FS : FileSystem) : FileServer = PlaceholderFileServer

(* TODO *)
module InMemoryFileServer = PlaceholderFileServer

(* TODO *)
module OnDiskFileServer = PlaceholderFileServer
