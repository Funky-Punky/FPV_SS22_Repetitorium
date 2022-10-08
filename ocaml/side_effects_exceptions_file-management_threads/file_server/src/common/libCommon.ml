type file_reference = string
type file_content = string
type file = file_reference * file_content
type read_request = file_reference
type write_mode = Append | Replace
type write_request = file_reference * file_content * write_mode
