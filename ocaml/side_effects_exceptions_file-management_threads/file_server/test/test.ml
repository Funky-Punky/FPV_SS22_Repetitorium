open OUnit
open LibFileSystem
open LibFileServer
open LibCommon

let test_filename = "testname"
let test_filename_two = "testnameTwo"
let test_file_path = "files/testname"
let test_filecontent = "testcontent"
let test_filecontent_two = "testcontent two"
let test_write_request = (test_filename, test_filecontent)
let test_write_request_two = (test_filename_two, test_filecontent_two)

(* TODO: add tests for in memory file system *)

let disk_file_system_tests =
  [
    ( "simple write test" >:: fun _ ->
      (try Sys.mkdir (Sys.getcwd () ^ "/files") 0o755 with _ -> ());

      let fs = OnDiskFileSystem.init () in
      let _ = OnDiskFileSystem.write fs test_write_request in
      let chan = open_in test_file_path in
      let content = really_input_string chan (in_channel_length chan) in
      close_in chan;
      (try Sys.remove test_file_path with _ -> ());
      assert_equal test_filecontent content );
    ( "simple read test" >:: fun _ ->
      (try Sys.mkdir (Sys.getcwd () ^ "/files") 0o755 with _ -> ());
      let cout = open_out test_file_path in
      output_string cout test_filecontent;
      close_out cout;
      let fs = OnDiskFileSystem.init () in
      let content = OnDiskFileSystem.read fs test_filename in
      (try Sys.remove test_file_path with _ -> ());
      assert_equal test_filecontent content );
  ]

(* TODO: kill server *)
module Tmp (FS : FileServer) = struct
  let file_server_tests =
    [
      ( "simple read write test" >:: fun _ ->
        (try Sys.mkdir (Sys.getcwd () ^ "/files") 0o755 with _ -> ());
        let request = ("simpletest", "content") in
        let fs = FS.create_file_server () in
        assert_equal None (FS.write fs request);
        assert_equal (Ok "content") (FS.read fs "simpletest") );
      ( "read write test - two files" >:: fun _ ->
        (try Sys.mkdir (Sys.getcwd () ^ "/files") 0o755 with _ -> ());
        let request1 = ("doubletestone", "content") in
        let request2 = ("doubletesttwo", "content") in
        let fs = FS.create_file_server () in
        assert_equal None (FS.write fs request1);
        assert_equal None (FS.write fs request2);
        assert_equal (Ok "content") (FS.read fs "doubletestone");
        assert_equal (Ok "content") (FS.read fs "doubletesttwo") );
      ( "delete test" >:: fun _ ->
        (try Sys.mkdir (Sys.getcwd () ^ "/files") 0o755 with _ -> ());
        let fs = FS.create_file_server () in
        assert_equal None (FS.write fs ("todelete", "todelete"));
        assert_equal None (FS.delete fs "todelete");
        assert_equal (Error FS.FileNotFound) (FS.read fs "todelete") );
      ( "test replace" >:: fun _ ->
        let request = ("replace", "content") in
        let fs = FS.create_file_server () in
        assert_equal None (FS.write fs request);
        assert_equal None (FS.write fs request);
        assert_equal (Ok "content") (FS.read fs "replace") );
    ]
end

module InMemoryTests = Tmp (InMemoryFileServer)
module OnDiskTests = Tmp (OnDiskFileServer)

let tests =
  "My tests"
  >::: [
         "disk_file_system_tests" >::: disk_file_system_tests;
         "InMemory_file_server_tests" >::: InMemoryTests.file_server_tests;
         "OnDisk_file_server_tests" >::: OnDiskTests.file_server_tests;
       ]

let _ = run_test_tt_main tests
