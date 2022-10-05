open OUnit
open Assignment

let one_two_three_string = "1\n2\n3\n"
let one_two_three_list = [ 1; 2; 3 ]
let four_five_six_list = [ 4; 5; 6 ]

let store_tests =
  [
    ( "simple store" >:: fun _ ->
      (* print_endline (Sys.getcwd ()); *)
      DiskDataBase.store_int_list "storetest" [ 1; 2; 3 ];
      let chan = open_in "storetest" in
      let content = really_input_string chan (in_channel_length chan) in
      close_in chan;
      assert_equal one_two_three_string content );
  ]

let load_tests =
  [
    ( "simple load" >:: fun _ ->
      (* print_endline (Sys.getcwd ()); *)
      let chan = open_out "loadtest" in
      output_string chan one_two_three_string;
      close_out chan;
      assert_equal one_two_three_list (DiskDataBase.read_int_list "loadtest") );
  ]

let remove_tests =
  [
    ( "remove test" >:: fun _ ->
      DiskDataBase.store_int_list "removetest" [ 1; 2; 3 ];
      DiskDataBase.remove "removetest";
      assert_raises (Sys_error "removetest: No such file or directory")
        (fun () -> open_in "removetest") );
  ]

let concat_tests =
  [
    ( "concat test" >:: fun _ ->
      DiskDataBase.store_int_list "onetwothree" one_two_three_list;
      DiskDataBase.store_int_list "fourfivesix" four_five_six_list;
      DiskDataBase.concat "onetwothree" "fourfivesix" "final";
      assert_equal
        (one_two_three_list @ four_five_six_list)
        (DiskDataBase.read_int_list "final") );
  ]

let tests =
  "My tests"
  >::: [
         "store tests" >::: store_tests;
         "load tests" >::: load_tests;
         "remove tests" >::: remove_tests;
         "concat tests" >::: concat_tests;
       ]

let _ = run_test_tt_main tests
