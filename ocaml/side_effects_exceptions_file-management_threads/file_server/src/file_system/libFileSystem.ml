open LibCommon

type file_reference = string
type file_content = string
type read_request = file_reference
type write_request = file_reference * file_content

module type FileSystem = sig
  type t

  exception FileSystemException

  val init : unit -> t
  val read : t -> read_request -> file_content
  val write : t -> write_request -> t
  val delete : t -> file_reference -> t
end

module PlaceholderFileSystem : FileSystem = struct
  type t = unit

  exception FileSystemException

  let init () = ()
  let read fs filename = failwith "placeholder"
  let write fs (filename, content) = failwith "placeholder"
  let delete fs filename = failwith "placeholder"
end

(* TODO *)
module InMemoryFileSystem : FileSystem = PlaceholderFileSystem

(* TODO *)
module OnDiskFileSystem : FileSystem = PlaceholderFileSystem
