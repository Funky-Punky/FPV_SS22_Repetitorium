let i = 3;;

print_int i;;

let get_number = fun n -> 5;;

print_int (get_number ());;


module Peter = struct
  type t = string

  let f = "asdf"
end

let asdf : Peter.t = Peter.f

module type BstModuleType = sig
  type bst = Leaf | Node of bst * int * bst

  val insert : int -> bst -> bst
end

module Bst : BstModuleType = struct
  type bst = Leaf | Node of bst * int * bst

  let insert _ = failwith "TODO"
end

module type MyListModuleType = sig
  type 'a t
  type b

  val empty : 'a t
  val cons : 'a -> 'a t -> 'a t
  val hd : 'a t -> 'a option
  val tl : 'a t -> 'a t option
  val my_amazing_function_for_world_domination : unit -> unit
end

module MyList : MyListModuleType with type 'a t = 'a list and type b = int = struct
  type 'a t = 'a list
  type b = int

  let my_amazing_function_for_world_domination () = ()
  let empty = []
  let cons = List.cons
  let hd = function [] -> None | x :: _ -> Some x
  let tl = function [] -> None | _ :: xs -> Some xs
end

let some_list : 'a MyList.t = MyList.empty
let asdf = MyList.cons 1 some_list

module AsdfFunctor (CoolList : MyListModuleType) = struct
  let my_cool_function () = CoolList.empty
end

module Asdf = AsdfFunctor (MyList)

let something = Asdf.my_cool_function ()

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
  let take_top_item = failwith "This will never succeed"
end;;

BlackHole.get_new_bag ();;

module AsdfStudent = functor (TheirBag : Bag) -> functor (TheirBagForLeisureTime: Bag) -> struct
  let name = "Michael"

  let bag = TheirBag.get_new_bag ();;
  let bag_for_fun = TheirBagForLeisureTime.get_new_bag ();;
end;;

module CSStudent = AsdfStudent (Backpack) (BlackHole)

module type Student = sig
  val name : string
  val age : int
end

module type MastersStudent = sig
  include Student

  val bachelor_grade : float
end

module LawStudent : Student = struct
  let name = "Friedrich"
  let age = 78
end

module LawFakeMastersStudent = struct
  include LawStudent
  include List

  let age = Int.max_int
  let bachelor_grade = 1.0

  let adsf _ = map
end;;


type my_function = int -> string
module type MyModuleType = Bag -> Student

let adsf = fun x -> ...

module OtherStudentFunctor: MyModuleType = functor (TheirBag : Bag) -> struct
  let name = "Michael"
  let age = 42

  let bag = TheirBag.get_new_bag ();
end
