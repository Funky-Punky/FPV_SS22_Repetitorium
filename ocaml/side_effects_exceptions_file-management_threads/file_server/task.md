# FileServer
Consider the following signatures
```ocaml
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

module type FileServer = sig
  type t

  exception FileNotFound

  val create_file_server : unit -> t
  val read : t -> read_request -> file_content
  val write : t -> write_request -> unit
  val delete : t -> file_reference -> unit
  val kill : t -> unit
end
```
The FileSystem module represents a connection to a File System. It is not Thread-safe and raises exceptions left and right.\
The FileServer is a way to control access to a FileSystem and ensures, that only one thread at a time can interact with the files. It also ensures that exceptions raised by the file system don't cause a general server crash but are instead propagated to the user.

Your Tasks:
1. Create two Implementations of the FileSystem Module. Both of them are allowed to raise exceptions.
   1. The first Implementation will be called InMemoryFileSystem. It saves the entirety of its state in a ```type t```. Its your decision what this type will be.
   2. The second will be called OnDiskFileSystem. It should save all its files and their contents on your Disk in actual files. Use the files subdirectory in this repo to store your files there. You must do this or the tests wont work.
2. Create a functor `CreateFileServer` that creates a `FileServer` from a `FileSystem`. It must be thread-safe.\
   **Hint:** First, think about what requests this server must handle and what information must me attached to every request.\
   **Important:** The FileServer must catch every exception the functor could possibly throw at it.
3. Create two FileServer Instances that take the ```InMemoryFileSystem``` and the ```OnDiskFileSystem```. Call them ```InMemoryFileServer``` and ```OnDiskFileServer```. Play around with them on utop and ensure you've implemented everything correctly.
