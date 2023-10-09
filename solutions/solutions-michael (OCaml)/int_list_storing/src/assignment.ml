module type IntListDataBase = sig
  val store_int_list : string -> int list -> unit
  val read_int_list : string -> int list
  val remove : string -> unit
  val concat : string -> string -> string -> unit
end

module DiskDataBase : IntListDataBase = struct
  let write_int_list_to_channel channel list =
    List.iter (fun x -> output_string channel (string_of_int x ^ "\n")) list

  let store_int_list filename list =
    let channel = open_out filename in
    write_int_list_to_channel channel list;
    close_out channel

  let rec read_int_list_from_channel channel =
    try
      let i = int_of_string (input_line channel) in
      i :: read_int_list_from_channel channel
    with
    | End_of_file -> []
    | Failure _ -> failwith "Die Liste darf nur Integer Werte enthalten"

  let read_int_list filename =
    let channel = open_in filename in
    try
      let db = read_int_list_from_channel channel in
      close_in channel;
      db
    with exn ->
      close_in channel;
      raise exn

  let remove filename = Sys.remove (Sys.getcwd () ^ "/" ^ filename)

  (* let concat file1 file2 new_filename =
     store_int_list new_filename (read_int_list file1 @ read_int_list file2) *)

  let concat file1 file2 new_filename =
    let c1 = open_in file1 in
    let c2 = open_in file2 in
    let cout = open_out new_filename in
    output_string cout (really_input_string c1 (in_channel_length c1));
    output_string cout (really_input_string c2 (in_channel_length c2));
    close_in c1;
    close_in c2;
    close_out cout
end
