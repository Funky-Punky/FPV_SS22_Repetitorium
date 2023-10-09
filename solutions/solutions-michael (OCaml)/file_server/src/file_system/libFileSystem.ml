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
module InMemoryFileSystem : FileSystem = struct
  type t = (file_reference * file_content) list

  exception FileSystemException

  let init () = []

  let read fs filename =
    match List.assoc_opt filename fs with
    | None -> raise FileSystemException
    | Some content -> content

  let write fs ((filename, _) as file) = file :: List.remove_assoc filename fs
  let delete fs filename = List.remove_assoc filename fs
end

(* TODO *)
module OnDiskFileSystem : FileSystem = struct
  type t = unit

  exception FileSystemException

  let init () = ()

  let read () filename =
    let file = try open_in filename with _ -> raise FileSystemException in
    let rec run content =
      let line = try Some (input_line file) with End_of_file -> None in
      match line with
      | None ->
          close_in file;
          content
      | Some line -> run @@ content ^ line
    in
    run ""

  let write () (filename, content) =
    let file = try open_out filename with _ -> raise FileSystemException in
    String.split_on_char '\n' content
    |> List.iter (fun line -> output_string file @@ line ^ "\n");
    close_out file

  let delete () = Sys.remove
end
