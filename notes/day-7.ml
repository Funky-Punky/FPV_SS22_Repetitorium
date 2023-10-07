module MyModule = struct
  let my_function a b = a + b;;

  my_function 1 2

  let five = my_function 2 3
  let some_function x = x + 1
end
;;

(* open MyModule;; *)

MyModule.my_function 5 6

(* my_function 5 7;; *)

module type OtherModuleType = sig
  type t

  val example_t : t
  val some_function : t -> int
end

module OtherModule = struct
  type t = int

  let example_t = 42

  include MyModule;;

  my_function 5 7

  let ten = five + five
  let some_function x = x + 2
end
;;

OtherModule.five;;
OtherModule.some_function 42

(* OtherModule.some_function 1;; *)

module type BalancedBST = sig
  type 'a t

  val empty : 'a t
  val create : int -> int t
  val insert : 'a -> 'a t -> 'a t
  val delete : 'a -> 'a t -> 'a t
end

type 'a bst = Leaf | Node of 'a bst * 'a * 'a bst

module MyBST : BalancedBST = struct
  type 'a t = 'a bst

  let empty = Leaf
  let create n = Node (Leaf, n, Leaf)
  let insert _ _ = failwith "TODO"
  let delete _ _ = failwith "TODO"
end

let my_tree = Node (Leaf, 1, Node (Leaf, 7, Node (Leaf, 3, Leaf)))
let my_new_tree = MyBST.insert 5 MyBST.empty
let my_new_tree = MyBST.insert 8 my_new_tree

module type Whatever = sig
  type a
  type b

  val my_fun : a -> b -> a * b
end

module M : Whatever with type a = int and type b = string = struct
  type a = int
  type b = string

  let my_fun a b = (a, b)
  let my_secret_helper = List.fold_left
end
;;

M.my_fun 1 "hey"

module type MonomorphicBalancedBST = sig
  type t

  val empty : t
  val create : int -> t
  val insert : int -> t -> t
  val delete : int -> t -> t
end

type 'a bst = Leaf | Node of 'a bst * 'a * 'a bst

module MyMonomorphicBST : MonomorphicBalancedBST with type t = int bst = struct
  type t = int bst

  let empty = Leaf
  let create n = Node (Leaf, n, Leaf)
  let insert _ _ = failwith "TODO"
  let delete _ _ = failwith "TODO"
end
;;

MyMonomorphicBST.insert 5 MyMonomorphicBST.empty

module type Bag = sig
  type 'a bag

  val get_new_bag : unit -> 'a bag
  val throw_in_bag : 'a -> 'a bag -> 'a bag
  val take_top_item : 'a bag -> 'a * 'a bag
end

module Backpack : Bag = struct
  type 'a bag = 'a list

  let brand = "Eastpak"
  let get_new_bag () = []
  let throw_in_bag item bag = item :: bag

  let take_top_item bag =
    match bag with
    | item :: bag -> (item, bag)
    | _ -> failwith ("The backpack from" ^ brand ^ "is empty!!!")
end

module BlackHole : Bag = struct
  type 'a bag = unit

  let get_new_bag () = ()
  let throw_in_bag _ _ = ()
  let take_top_item = failwith "Sorry, physics won't let you!"
end

let f a b = a + b
let f a b = a + b
let f a b = a + b

module type PersonFromTwoBags = functor (WorkBag : Bag) (LeisureBag : Bag) -> sig
  val work_bag : int WorkBag.bag
  val work_bag : string WorkBag.bag
end

module PersonWithTwoBags (WorkBag : Bag) (LeisureBag : Bag) = struct
  let work_bag = WorkBag.get_new_bag ()
  let leisure_bag = LeisureBag.get_new_bag ()
end

module PersonWithTwoBags : PersonFromTwoBags =
functor
  (WorkBag : Bag)
  (LeisureBag : Bag)
  ->
  struct
    let name = "Somebody"
    let work_bag = WorkBag.get_new_bag ()
    let leisure_bag = LeisureBag.get_new_bag ()
  end

module PersonWithTwoBags =
functor
  (WorkBag : Bag)
  (LeisureBag : Bag)
  ->
  struct
    let work_bag = WorkBag.get_new_bag ()
    let leisure_bag = LeisureBag.get_new_bag ()
  end

module PersonWithBackpack = PersonWithTwoBags (Backpack)
module NormalStudent = PersonWithTwoBags (Backpack) (BlackHole)
module RichPerson = PersonWithTwoBags (BlackHole) (BlackHole)

module CreateCombinedBag =
functor
  (BagA : Bag)
  (BagB : Bag)
  ->
  (
     struct
       type 'a bag = unit

       let get_new_bag () = ()
       let throw_in_bag _ _ = ()
       let take_top_item = failwith "Sorry, physics won't let you!"
     end :
       Bag)
