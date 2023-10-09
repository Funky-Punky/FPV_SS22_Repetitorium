open OUnit
open LibFileSystem
open LibFileServer
open LibCommon

let test_filename = "testname"
let test_filename_two = "testnameTwo"
let test_file_path = "files/testname"
let test_filecontent = "testcontent"
let test_filecontent_two = "testcontent two"

let make_test_dir () =
  try Sys.mkdir (Sys.getcwd () ^ "/files") 0o755 with _ -> ()

module CreateFileSystemTests (FS : FileSystem) = struct
  let empty_fs = FS.init ()

  let tests =
    [
      ( "should create and read file a" >:: fun _ ->
        let fs = FS.write empty_fs (test_file_path, test_filecontent) in
        let result = FS.read fs test_file_path in
        assert_equal test_filecontent result );
      ( "should raise an exception when inexistent file is read" >:: fun _ ->
        assert_raises FS.FileSystemException (fun () ->
            FS.read empty_fs (test_file_path ^ "doesnt_exist")) );
      ( "should create and delete file a" >:: fun _ ->
        let fs = FS.write empty_fs (test_file_path, test_filecontent) in
        let fs = FS.delete fs test_file_path in
        assert_raises FS.FileSystemException (fun () ->
            FS.read fs test_file_path) );
    ]
end

module Tmp (Server : FileServer) = struct
  let with_file_server f _ =
    let server = Server.create_file_server () in
    f server;
    Server.kill server

  let tests =
    [
      ("simple read write test"
      >:: with_file_server @@ fun server ->
          let request = ("simpletest", "content") in
          Server.write server request;
          assert_equal "content" (Server.read server "simpletest"));
      ("read write test - two files"
      >:: with_file_server @@ fun server ->
          let request1 = ("doubletestone", "asdf") in
          let request2 = ("doubletesttwo", "qwer") in
          Server.write server request1;
          Server.write server request2;
          assert_equal "qwer" (Server.read server "doubletesttwo");
          assert_equal "asdf" (Server.read server "doubletestone"));
      ("delete test"
      >:: with_file_server @@ fun server ->
          Server.write server ("todelete", "todelete");
          Server.delete server "todelete";
          assert_raises Server.FileNotFound (fun () ->
              Server.read server "todelete"));
      ("test replace"
      >:: with_file_server @@ fun server ->
          let filename = "replace" in
          Server.write server (filename, "first");
          Server.write server (filename, "second");
          assert_equal "content" (Server.read server "second"));
      ("read should forward errors"
      >:: with_file_server @@ fun server ->
          assert_raises Server.FileNotFound (fun () ->
              Server.read server "non_existent"));
      ("delete should forward errors"
      >:: with_file_server @@ fun server ->
          assert_raises Server.FileNotFound (fun () ->
              Server.delete server "non_existent"));
    ]
end

(* File System tests *)
module InMemoryFileSystemTests = CreateFileSystemTests (InMemoryFileSystem)
module OnDiskFileSystemTests = CreateFileSystemTests (OnDiskFileSystem)

(* File Server tests *)
module InMemoryFileServerTests = Tmp (InMemoryFileServer)
module OnDiskFileServerTests = Tmp (OnDiskFileServer)

let tests =
  make_test_dir ();
  "My tests"
  >::: [
         "in_memory_file_system_tests" >::: InMemoryFileSystemTests.tests;
         "disk_file_system_tests" >::: OnDiskFileSystemTests.tests;
         "InMemory_file_server_tests" >::: InMemoryFileServerTests.tests;
         "OnDisk_tests" >::: OnDiskFileServerTests.tests;
       ]

let _ = run_test_tt_main tests
