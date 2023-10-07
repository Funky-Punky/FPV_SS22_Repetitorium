open LibCommon

type file_reference = string
type file_content = string
type read_request = file_reference
type write_request = file_reference * file_content

module type FileSystem = sig
  type t

  val init : unit -> t
  val kill : t -> unit
  val read : t -> read_request -> file_content
  val write : t -> write_request -> t
  val delete : t -> file_reference -> t
end

module PlaceholderFileSystem = struct
  type t = unit

  let init () = failwith "placeholder"
  let kill fs = failwith "placeholder"
  let read fs filename = failwith "placeholder"
  let write fs (filename, content) = failwith "placeholder"
  let delete fs filename = failwith "placeholder"
end

(* TODO *)
module InMemoryFileSystem = PlaceholderFileSystem
(* TODO *)
module OnDiskFileSystem = PlaceholderFileSystem
