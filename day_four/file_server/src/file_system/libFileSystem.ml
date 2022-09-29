open LibCommon

module type FileSystem = sig
  type t

  val init : unit -> t
  val kill : t -> unit
  val read : t -> read_request -> file_content
  val write : t -> write_request -> t
  val delete : t -> file_reference -> t
end
