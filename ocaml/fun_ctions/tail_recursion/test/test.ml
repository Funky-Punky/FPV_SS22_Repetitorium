open OUnit
open Assignment

let ( ||> ) f g x = x |> f |> g

let string_of_list string_of_item =
  List.map string_of_item ||> String.concat ", " ||> fun s -> "[" ^ s ^ "]"

let assert_equal_strings = assert_equal ?printer:(Some Fun.id)
let assert_equal_ints = assert_equal ?printer:(Some string_of_int)
let assert_equal_floats = assert_equal ?printer:(Some string_of_float)

let assert_equal_int_lists =
  assert_equal ?printer:(Some (string_of_list string_of_int))

let list_functionality_tests =
  "List functionality"
  >::: [
         ( "length should be correct" >:: fun _ ->
           let the_length = 12 in
           assert_equal_ints the_length (length @@ List.init the_length Fun.id)
         );
         ( "map should be correct" >:: fun _ ->
           assert_equal_int_lists [ 1; 2; 3 ] (map (( + ) 1) [ 0; 1; 2 ]) );
         ( "fold_left should be correct" >:: fun _ ->
           assert_equal_strings "Hello, World!"
             (fold_left ( ^ ) "" [ "Hello"; ", "; "World!" ]) );
         ( "filter should be correct" >:: fun _ ->
           assert_equal_int_lists [ 0; 3 ] (filter (( > ) 10) [ 0; 10; 3 ]) );
         ( "partition should be correct" >:: fun _ ->
           let yes, no = partition (( >= ) 10) [ 0; 12; 100; 10; 11 ] in
           assert_equal_int_lists [ 0; 10 ] yes;
           assert_equal_int_lists [ 12; 100; 11 ] no );
         ( "sum_int should be correct" >:: fun _ ->
           assert_equal_ints 10 (sum_int @@ List.init 10 @@ Fun.const 1) );
         ( "sum_float should be correct" >:: fun _ ->
           assert_equal_floats 10. (sum_float @@ List.init 10 @@ Fun.const 1.)
         );
         ( "prod_int should be correct" >:: fun _ ->
           assert_equal_ints 32 (prod_int @@ List.init 5 @@ Fun.const 2) );
       ]

let create_tree_of_depth =
  let rec aux t = function
    | n when n <= 0 -> t
    | n -> aux (Node (t, 1, t)) (n - 1)
  in
  aux Leaf

let list_tailrecursiveness_tests =
  (* Arbitrary *)
  let long_list = List.init 10_001 @@ Fun.const 1 in
  let long_float_list = List.init 10_001 @@ Fun.const 1. in
  "List functions - tailrecursiveness"
  >::: [
         ("length should be TR" >:: fun _ -> length long_list |> ignore);
         ("map should be TR" >:: fun _ -> map Fun.id long_list |> ignore);
         ( "fold_left should be TR" >:: fun _ ->
           fold_left Fun.const 0 long_list |> ignore );
         ( "filter should be TR" >:: fun _ ->
           filter (Fun.const true) long_list |> ignore );
         ( "partition should be TR" >:: fun _ ->
           partition (Fun.const true) long_list |> ignore );
         ("sum_int should be TR" >:: fun _ -> sum_int long_list |> ignore);
         ( "sum_float should be TR" >:: fun _ ->
           sum_float long_float_list |> ignore );
         ("prod_int should be TR" >:: fun _ -> prod_int long_list |> ignore);
       ]

let bst_tests =
  "BST"
  >::: [
         ( "height should return 0 for Leaf" >:: fun _ ->
           assert_equal_ints 0 @@ height Leaf );
         ( "height should return 1 for single node" >:: fun _ ->
           assert_equal_ints 1 @@ height (Node (Leaf, 0, Leaf)) );
         ( "inorder should return [] for single Leaf" >:: fun _ ->
           assert_equal_int_lists [] @@ inorder Leaf );
         ( "inorder should return [5] for single node" >:: fun _ ->
           assert_equal_int_lists [ 5 ] @@ inorder (Node (Leaf, 5, Leaf)) );
         ( "inorder should generally work" >:: fun _ ->
           assert_equal_int_lists [ 3; 5; 7 ]
           @@ inorder (Node (Node (Leaf, 3, Leaf), 5, Node (Leaf, 7, Leaf))) );
         ( "preorder should return [] for single Leaf" >:: fun _ ->
           assert_equal_int_lists [] @@ preorder Leaf );
         ( "preorder should return [5] for single node" >:: fun _ ->
           assert_equal_int_lists [ 5 ] @@ preorder (Node (Leaf, 5, Leaf)) );
         ( "preorder should generally work" >:: fun _ ->
           assert_equal_int_lists [ 5; 3; 7 ]
           @@ preorder (Node (Node (Leaf, 3, Leaf), 5, Node (Leaf, 7, Leaf))) );
         ( "postorder should return [] for single Leaf" >:: fun _ ->
           assert_equal_int_lists [] @@ postorder Leaf );
         ( "postorder should return [5] for single node" >:: fun _ ->
           assert_equal_int_lists [ 5 ] @@ postorder (Node (Leaf, 5, Leaf)) );
         ( "postorder should generally work" >:: fun _ ->
           assert_equal_int_lists [ 3; 7; 5 ]
           @@ postorder (Node (Node (Leaf, 3, Leaf), 5, Node (Leaf, 7, Leaf)))
         );
         ( "sum should return 0 for Leaf" >:: fun _ ->
           assert_equal_ints 0 @@ sum Leaf );
         ( "sum should return 1 for single node with 1" >:: fun _ ->
           assert_equal_ints 1 @@ sum (Node (Leaf, 1, Leaf)) );
         ( "sum should work for other example" >:: fun _ ->
           assert_equal_ints 23
           @@ sum (Node (Node (Leaf, 5, Leaf), 1, Node (Leaf, 17, Leaf))) );
         ( "insert should create node from leaf" >:: fun _ ->
           assert_equal (Node (Leaf, 1, Leaf)) @@ insert 1 Leaf );
         ( "insert should insert into 1 layer" >:: fun _ ->
           assert_equal (Node (Node (Leaf, 1, Leaf), 3, Leaf))
           @@ insert 1 (Node (Leaf, 3, Leaf)) );
         ( "insert should insert into 2 layers (l)" >:: fun _ ->
           assert_equal (Node (Node (Leaf, 1, Node (Leaf, 2, Leaf)), 3, Leaf))
           @@ insert 2 (Node (Node (Leaf, 1, Leaf), 3, Leaf)) );
         ( "insert should not modify if already exists" >:: fun _ ->
           assert_equal (Node (Node (Leaf, 1, Leaf), 3, Leaf))
           @@ insert 3 (Node (Node (Leaf, 1, Leaf), 3, Leaf)) );
         ( "insert should insert into 2 layers" >:: fun _ ->
           assert_equal (Node (Leaf, 3, Node (Node (Leaf, 4, Leaf), 5, Leaf)))
           @@ insert 4 (Node (Leaf, 3, Node (Leaf, 5, Leaf))) );
       ]

let bst_tailrecursiveness_tests =
  (* Not actual BST, but good enough for TR tests *)
  let large_tree = create_tree_of_depth 13 in
  "List functions - tailrecursiveness"
  >::: [
         ("height should be TR" >:: fun _ -> height large_tree |> ignore);
         ("inorder should be TR" >:: fun _ -> inorder large_tree |> ignore);
         ("preorder should be TR" >:: fun _ -> preorder large_tree |> ignore);
         ("postorder should be TR" >:: fun _ -> postorder large_tree |> ignore);
         ("sum should be TR" >:: fun _ -> sum large_tree |> ignore);
         ("insert should be TR" >:: fun _ -> insert 0 large_tree |> ignore);
       ]

let tests =
  "Tail Recursion"
  >::: [
         ( "Sanity check: stack error should occur.\n\
            ****** Ensure you're running with `OCAMLRUNPARAM=l=8000 dune test` \
            ******"
         >:: fun _ ->
           assert_raises Stack_overflow (fun _ -> List.init 10_001 Fun.id @ [])
         );
         list_functionality_tests;
         list_tailrecursiveness_tests;
         bst_tests;
         bst_tailrecursiveness_tests;
       ]

let _ = run_test_tt_main tests
