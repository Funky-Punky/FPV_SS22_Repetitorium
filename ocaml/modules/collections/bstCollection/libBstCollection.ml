open LibFoldable
open LibCollection

type 'a bst = Leaf | Node of 'a bst * 'a * 'a bst

module BstFoldable : Foldable = TODO_Foldable
module BstCollection = TODO_Collection
