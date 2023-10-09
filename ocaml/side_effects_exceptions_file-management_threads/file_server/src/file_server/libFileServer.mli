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

module CreateFileServer (FS : FileSystem) : FileServer
module InMemoryFileServer : FileServer
module OnDiskFileServer : FileServer
