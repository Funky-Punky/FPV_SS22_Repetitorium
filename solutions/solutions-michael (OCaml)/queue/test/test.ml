open OUnit
open Assignment

let print_string = Some (fun x -> x)

let enqueue_dequeue_tests =
  [
    ( "enueue and dequeue one element" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q 1;
      assert_equal (Some 1) (MyQueue.dequeue_opt q) );
    ( "enueue and dequeue four elements" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q 1;
      MyQueue.enqueue q 2;
      MyQueue.enqueue q 3;
      MyQueue.enqueue q 4;
      assert_equal (Some 1) (MyQueue.dequeue_opt q);
      assert_equal (Some 2) (MyQueue.dequeue_opt q);
      assert_equal (Some 3) (MyQueue.dequeue_opt q);
      assert_equal (Some 4) (MyQueue.dequeue_opt q) );
    ( "enueue and dequeue four elements - weird order" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q 1;
      MyQueue.enqueue q 2;
      assert_equal (Some 1) (MyQueue.dequeue_opt q);
      MyQueue.enqueue q 3;
      assert_equal (Some 2) (MyQueue.dequeue_opt q);
      assert_equal (Some 3) (MyQueue.dequeue_opt q);
      MyQueue.enqueue q 4;
      assert_equal (Some 4) (MyQueue.dequeue_opt q) );
    ( "enueue and dequeue one element - String" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q "Hello";
      assert_equal (Some "Hello") (MyQueue.dequeue_opt q) );
  ]

let empty_Queue_tests =
  [
    ( "None on empty Queue" >:: fun _ ->
      let q = MyQueue.create_queue () in
      assert_equal None (MyQueue.dequeue_opt q) );
    ( "Exception on empty Queue" >:: fun _ ->
      let q = MyQueue.create_queue () in
      assert_raises MyQueue.NoElementLeft (fun _ -> MyQueue.dequeue q) );
    ( "None on empty Queue - some activity before" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q 1;
      assert_equal (Some 1) (MyQueue.dequeue_opt q);
      assert_equal None (MyQueue.dequeue_opt q) );
    ( "Exception on empty Queue - some activity before" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q 1;
      assert_equal (Some 1) (MyQueue.dequeue_opt q);
      assert_raises MyQueue.NoElementLeft (fun _ -> MyQueue.dequeue q) );
  ]

let reverse_tests =
  [
    ( "simple reverse test" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q 1;
      MyQueue.enqueue q 2;
      MyQueue.enqueue q 3;
      MyQueue.enqueue q 4;

      MyQueue.reverse q;

      assert_equal (Some 4) (MyQueue.dequeue_opt q);
      assert_equal (Some 3) (MyQueue.dequeue_opt q);
      assert_equal (Some 2) (MyQueue.dequeue_opt q);
      assert_equal (Some 1) (MyQueue.dequeue_opt q) );
    ( "anvanced reverse Test" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q 1;
      MyQueue.enqueue q 2;
      assert_equal (Some 1) (MyQueue.dequeue_opt q);
      MyQueue.enqueue q 3;
      MyQueue.enqueue q 4;

      MyQueue.reverse q;

      MyQueue.enqueue q 5;
      MyQueue.enqueue q 6;

      MyQueue.reverse q;

      assert_equal (Some 6) (MyQueue.dequeue_opt q);
      assert_equal (Some 5) (MyQueue.dequeue_opt q);
      assert_equal (Some 2) (MyQueue.dequeue_opt q);
      assert_equal (Some 3) (MyQueue.dequeue_opt q);
      assert_equal (Some 4) (MyQueue.dequeue_opt q) );
  ]

let empty_tests =
  [
    ( "empty test" >:: fun _ ->
      let q = MyQueue.create_queue () in
      MyQueue.enqueue q 1;
      MyQueue.enqueue q 2;
      MyQueue.empty q;
      assert_equal None (MyQueue.dequeue_opt q);
      MyQueue.enqueue q 1;
      assert_equal (Some 1) (MyQueue.dequeue_opt q);
      assert_equal None (MyQueue.dequeue_opt q) );
  ]

let kill_tests = 
  [
    (* ( "simple kill test" >:: fun _ -> 
      let q = MyQueue.create_queue () in
      MyQueue.kill q;
      assert



    ); *)
  ]

let tests =
  "My tests"
  >::: [
         "enqueue and dequeue" >::: enqueue_dequeue_tests;
         "empty queue tests" >::: empty_Queue_tests;
         "reverse tests" >::: reverse_tests;
         "empty tests" >::: empty_tests;
         "kill tests" >::: kill_tests;
       ]

let _ = run_test_tt_main tests
