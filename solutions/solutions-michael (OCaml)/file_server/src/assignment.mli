open Thread
open Event

type file_reference = string
type file_content = string
type file = file_reference * file_content
type read_request = file_reference
type write_mode = Append | Replace
type write_request = file_reference * file_content * write_mode

module type FileSystem = sig
  type t

  val init : unit -> t
  val kill : t -> unit
  val read : t -> read_request -> file_content
  val write : t -> write_request -> t
  val delete : t -> file_reference -> t
end

module type FileServer = sig
  type t

  val create_file_server : unit -> t
  val read : t -> read_request -> (file_content, exn) result
  val write : t -> write_request -> exn option
  val delete : t -> file_reference -> exn option
  val kill : t -> unit
end

module RunTimeFileSystem : FileSystem
module DiskFileSystem : FileSystem
module MyFileServer (FS : FileSystem) : FileServer
