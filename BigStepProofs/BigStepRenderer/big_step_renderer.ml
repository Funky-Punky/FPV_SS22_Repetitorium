type operator = Plus | Minus | Times | Divide

(* TODO: Add Pattern match expression *)
(* TODO: Add global definitions *)
type expr =
  | Const of int
  | Tuple of expr list
  | List of expr list
  | Fun of (string * expr)
  | App of (expr * expr)
  | Var of string
  | Let of (string * expr * expr)
  | Op of (expr * operator * expr)

(* returns a pretty string representation of an expression *)
let rec pp_operator (op : operator) : string =
  match op with Plus -> "+" | Minus -> "-" | Times -> "*" | Divide -> "/"

(* returns a pretty string representation of an expression *)
let rec pp_expr (e : expr) : string =
  match e with
  | Const i -> string_of_int i
  | Tuple es -> "(" ^ String.concat ", " (List.map pp_expr es) ^ ")"
  | List es -> "[" ^ String.concat "; " (List.map pp_expr es) ^ "]"
  | Fun (x, e) -> "(fun " ^ x ^ " -> " ^ pp_expr e ^ ")"
  | App (e1, e2) -> "(" ^ pp_expr e1 ^ " " ^ pp_expr e2 ^ ")"
  | Var x -> x
  | Let (x, e1, e2) -> "let " ^ x ^ " = " ^ pp_expr e1 ^ " in " ^ pp_expr e2
  | Op (e1, op, e2) -> pp_expr e1 ^ " " ^ pp_operator op ^ " " ^ pp_expr e2

(* substitudes all instances of x inside the expression e with s *)
let rec substitude (e : expr) (x : string) (s : expr) : expr =
  match e with
  | Const i -> Const i
  | Tuple es -> Tuple (List.map (fun e -> substitude e x s) es)
  | List es -> List (List.map (fun e -> substitude e x s) es)
  | Fun (y, e) -> if x = y then Fun (y, e) else Fun (y, substitude e x s)
  | App (e1, e2) -> App (substitude e1 x s, substitude e2 x s)
  | Var y -> if x = y then s else Var y
  | Let (y, e1, e2) ->
      if x = y then Let (y, substitude e1 x s, e2)
      else Let (y, substitude e1 x s, substitude e2 x s)
  | Op (e1, op, e2) -> Op (substitude e1 x s, op, substitude e2 x s)

(* evaluates an expression to a value *)
let rec eval (e : expr) : expr =
  match e with
  | Const i -> Const i
  | Tuple es -> Tuple (List.map eval es)
  | List es -> (match es with [] -> List [] | hd :: tl -> List (eval hd :: tl) )
  | Fun (x, e) -> Fun (x, e)
  | App (e1, e2) -> (
      match eval e1 with
      | Fun (x, e) -> eval (substitude e x (eval e2))
      | _ -> failwith "not a function")
  | Var x -> Var x
  | Let (x, e1, e2) -> eval (substitude e2 x e1)
  | Op (e1, op, e2) -> (
      match (eval e1, eval e2) with
      | Const i1, Const i2 -> (
          match op with
          | Plus -> Const (i1 + i2)
          | Minus -> Const (i1 - i2)
          | Times -> Const (i1 * i2)
          | Divide -> Const (i1 / i2))
      | _ -> failwith "not a number")

(* spaghetti code pls don't look *)
(* renders a big-step evaluation tree *)
let render_bigstep_tree (e : expr) =
  let rec indent_helper (indent : int) (e : expr) =
    let indent_str = String.make indent ' ' in
    let e_str = pp_expr e in

    match e with
    | Const i -> indent_str ^ "  " ^ e_str ^ " => " ^ pp_expr (eval e) ^ "\n"
    | Var x -> indent_str ^ e_str ^ " => " ^ pp_expr (eval e) ^ "\n"
    | Tuple es ->
        indent_str ^ "+ TU " ^ e_str ^ "\n"
        ^ String.concat "" (List.map (fun e -> indent_helper (indent + 2) e) es)
        ^ indent_str ^ "=> "
        ^ pp_expr (eval e)
        ^ "\n"
    | List es ->
        (match es with
        | [] -> indent_str ^ "+ LI " ^ e_str ^ "\n"
        | hd :: tl ->
            indent_str ^ "+ LI " ^ e_str ^ "\n"
            ^ indent_helper (indent + 2) hd
            ^ indent_helper (indent + 2) (List tl))
        ^ indent_str ^ "=> "
        ^ pp_expr (eval e)
        ^ "\n"
    | Fun (x, e) -> indent_str ^ "  " ^ e_str ^ " => " ^ e_str ^ "\n"
    | App (e1, e2) -> (
        match e1 with
        | Fun (x, fe) ->
            indent_str ^ "+ APP " ^ e_str ^ "\n"
            ^ indent_helper (indent + 2) e1
            ^ indent_helper (indent + 2) e2
            ^ indent_helper (indent + 2) (substitude fe x (eval e2))
            ^ indent_str ^ "=> "
            ^ pp_expr (eval e)
            ^ "\n"
        | _ -> failwith "not a function")
    | Let (x, e1, e2) ->
        indent_str ^ "+ LD " ^ e_str ^ "\n"
        ^ indent_helper (indent + 2) e1
        ^ indent_helper (indent + 2) (substitude e2 x e1)
        ^ indent_str ^ "=> "
        ^ pp_expr (eval e)
        ^ "\n"
    | Op (e1, op, e2) ->
        indent_str ^ "+ OP " ^ e_str ^ "\n"
        ^ indent_helper (indent + 2) e1
        ^ indent_helper (indent + 2) e2
        ^ indent_str ^ "    "
        ^ pp_expr (eval e1)
        ^ " " ^ pp_operator op ^ " "
        ^ pp_expr (eval e2)
        ^ " => "
        ^ pp_expr (eval e)
        ^ "\n" ^ indent_str ^ "=> "
        ^ pp_expr (eval e)
        ^ "\n"
  in
  print_string (indent_helper 0 e)

(*                                                         *)
(* Here are some examples you can use to test this program *)
(*                                                         *)

(* tuple *)
let tuple : expr =
  Tuple [ Const 0; Const 1; Const 2; Op (Const 9, Divide, Const 3) ]

(* list *)
let list : expr =
  List [ Const 1; Const 2; Const 3; Op (Const 6, Minus, Const 2) ]

(* Simple Local definition *)
let simple : expr = Let ("x", Tuple [ Const 1; Const 2 ], Var "x")

(* Simple function application *)
let square : expr = App (Fun ("x", Op (Var "x", Times, Var "x")), Const 3)

(* Rather complicated expression *)
let complicated : expr =
  Let
    ( "f",
      Fun ("x", Op (Op (Var "x", Times, Var "x"), Plus, Const 7)),
      App
        ( Var "f",
          App
            ( Fun ("x", Op (Op (Var "x", Times, Var "x"), Plus, Const 7)),
              Const 3 ) ) )
