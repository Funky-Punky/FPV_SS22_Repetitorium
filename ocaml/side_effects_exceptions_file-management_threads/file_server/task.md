# FileServer
Consider the following signatures
```ocaml
type file_reference = string
type file_content = string
type read_request = file_reference
type write_mode = Append | Replace            (* describes the writing behaviour *)
type write_request = file_reference * file_content * write_mode

module type FileSystem = sig
  type t

  val init : unit -> t
  val read : t -> read_request -> file_content
  val write : t -> write_request -> t
  val delete : t -> file_reference -> t
end

module type FileServer = sig
  type t

  exception FileNotFound

  val create_file_server : unit -> t
  val read : t -> read_request -> (file_content, exn) result (* if you want the tests to work, then exn must be a 'FileNotFound' exception*)
  val write : t -> write_request -> exn option
  val delete : t -> file_reference -> exn option
  val kill : t -> unit
end
```
The FileSystem module represents a connection to a File System. It is not Thread-safe and raises exceptions left and right.\
The FileServer is a way to control access to a FileSystem and ensures, that only one thread at a time can interact with the files as well as cantching all the nasty exceptions.

Your Tasks:
1. Create two Implementations of the FileSystem Module. Both of them are allowed to raise exceptions.
   1. The first Implementation will be called InMemoryFileSystem. It saves the entirety of its state in a ```type t```. Its your decision what this type will be.
   2. The second will be called OnDiskFileSystem. It should save all its files and their contents on your Disk in actual files. Use the files subdirectory in this repo to store your files there. You must do this or the tests wont work.\
   Hint: What would be the state of such an FileSystem
2. Create a functor `CreateFileServer` that creates a `FileServer` from a `FileSystem`. It must be thread-safe.\
   **Hint:** First, think about what requests this server must handle and what information must me attached to every request.\
   **Important:** The FileServer must catch every exception the functor could possibly throw at it.
3. Create two FileServer Instances that take the ```InMemoryFileSystem``` and the ```OnDiskFileSystem```. Call them ```InMemoryFileServer``` and ```OnDiskFileServer```.




These library functions might help you:
  ```ocaml
  Sys.getcwd () 
      (* returns the current working directory as a String *)
  open_out_gen [ Open_wronly; Open_creat; Open_trunc; Open_text ] 0o644 <filepath>
      (* opens an out_channel, that deletes the filecontents - same as 'open_out <filepath>' *)
  open_out_gen [ Open_wronly; Open_creat; Open_append; Open_text ] 0o644 <filepath>
      (* opens an out_channel, that appends to the end of the file *)
  Sys.remove <filepath>
      (* removes the given file from the file system *)
  ```
