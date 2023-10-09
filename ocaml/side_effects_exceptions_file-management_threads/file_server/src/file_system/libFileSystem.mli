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

module InMemoryFileSystem : FileSystem
module OnDiskFileSystem : FileSystem
