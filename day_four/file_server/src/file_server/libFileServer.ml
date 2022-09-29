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
