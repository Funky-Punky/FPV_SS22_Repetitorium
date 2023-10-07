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

module PlaceholderFileServer = struct
  type t = unit

  exception FileNotFound

  let create_file_server () = failwith "TODO"
  let read server req = failwith "TODO"
  let write server req = failwith "TODO"
  let delete server req = failwith "TODO"
  let kill server = failwith "TODO"
end

(* TODO *)
module CreateFileServer (_ : FileSystem) = PlaceholderFileServer
(* TODO *)
module InMemoryFileServer = PlaceholderFileServer
(* TODO *)
module OnDiskFileServer = PlaceholderFileServer
