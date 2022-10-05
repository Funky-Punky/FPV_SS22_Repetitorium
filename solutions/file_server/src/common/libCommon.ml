type file_reference = string
type file_content = string
type file = file_reference * file_content
type read_request = file_reference
type write_mode = Append | Replace
type write_request = file_reference * file_content * write_mode

let rec replace_assoc key replace = function
  | [] -> [ (key, replace None) ]
  | (k, v) :: xs when k = key -> (k, replace (Some v)) :: xs
  | x :: xs -> x :: replace_assoc key replace xs

let wrap_in_result f = try Ok (f ()) with e -> Error e
(* let wrap_in_result_unary f x = try Ok (f x) with e -> Error e *)