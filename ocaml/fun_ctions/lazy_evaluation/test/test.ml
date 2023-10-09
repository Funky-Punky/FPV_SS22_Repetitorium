open OUnit2
open Assignment

let ( ||> ) f g x = x |> f |> g

let string_of_list string_of_item =
  List.map string_of_item ||> String.concat ", " ||> fun s -> "[" ^ s ^ "]"

let lazy_int_printer = Some (fun x -> x () |> string_of_int)

let lazy_int_tuple_printer =
  Some
    (fun lazy_val ->
      let x, y = lazy_val () in
      "(" ^ string_of_int x ^ "," ^ string_of_int y ^ ")")

let int_list_printer = Some (string_of_list string_of_int)
let assert_equal_lazies = assert_equal ?cmp:(Some (fun a b -> a () = b ()))

let infinite_list_tests =
  let depth = 1000 in
  let reference_list = List.init depth Fun.id in
  [
    ( "integers 0 + take" >:: fun _ ->
      assert_equal ?printer:int_list_printer reference_list
        (take depth @@ integers 0) );
    ( "integers 10 + take" >:: fun _ ->
      assert_equal ?printer:int_list_printer
        (List.init depth @@ ( + ) 10)
        (take depth @@ integers 10) );
    ( "integers + map" >:: fun _ ->
      assert_equal ?printer:int_list_printer
        (List.init depth @@ Fun.const 42)
        (take depth @@ map (Fun.const 42) @@ integers 0) );
    ( "integers + filter" >:: fun _ ->
      let predicate = Fun.flip ( mod ) 2 ||> ( = ) 0 in
      assert_equal ?printer:int_list_printer
        (List.filter predicate (List.init depth (( * ) 2)))
        (take depth @@ filter predicate @@ integers 0) );
  ]

exception Evaluated_Lazy_Expression_at_wrong_time

let lazy_value_tests =
  let throws_when_evaluated () =
    raise Evaluated_Lazy_Expression_at_wrong_time
  in
  let lazy_0 () = 0 in
  [
    ( "map_lazy changes value" >:: fun _ ->
      assert_equal_lazies ?printer:lazy_int_printer (Fun.const 1)
        (map_lazy (( + ) 1) lazy_0) );
    ( "map_lazy always terminates" >:: fun _ ->
      assert_raises Evaluated_Lazy_Expression_at_wrong_time
      @@ map_lazy (( + ) 1) throws_when_evaluated );
    ( "bind_lazy changes value" >:: fun _ ->
      assert_equal_lazies ?printer:lazy_int_printer (Fun.const 1)
        (bind_lazy (fun v () -> v + 1) lazy_0) );
    ( "bind_lazy always terminates" >:: fun _ ->
      assert_raises Evaluated_Lazy_Expression_at_wrong_time
      @@ bind_lazy (fun v () -> v + 1) throws_when_evaluated );
    ( "combine_lazy changes value" >:: fun _ ->
      assert_equal_lazies ?printer:lazy_int_tuple_printer
        (Fun.const (0, 1))
        (combine_lazy lazy_0 (Fun.const 1)) );
    ( "combine_lazy always terminates (left)" >:: fun _ ->
      assert_raises Evaluated_Lazy_Expression_at_wrong_time
      @@ combine_lazy lazy_0 throws_when_evaluated );
    ( "combine_lazy always terminates (right)" >:: fun _ ->
      assert_raises Evaluated_Lazy_Expression_at_wrong_time
      @@ combine_lazy throws_when_evaluated lazy_0 );
  ]

let tests =
  "Lazy Evaluation"
  >::: [
         "Infinite lists" >::: infinite_list_tests;
         "Lazy values" >::: lazy_value_tests;
       ]
;;

run_test_tt_main tests
