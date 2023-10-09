open LibBstCollection;;
open LibMap;;

module MyMap = MapFromCollection (BstCollection)
open MyMap

let my_map = MyMap.empty

type color = Orange | Red

let with_content = 
  MyMap.empty
  |> set "Michael" Orange
  |> set "Angel" Red

let angels_color = get_opt "Angel" with_content
let hugos_color = get_opt "Hugo" with_content
