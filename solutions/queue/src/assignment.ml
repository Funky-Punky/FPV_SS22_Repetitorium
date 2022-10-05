open Thread
open Event

module type Queue = sig
  type 'a t

  exception NoElementLeft

  val create_queue : unit -> 'a t
  val enqueue : 'a t -> 'a -> unit
  val dequeue_opt : 'a t -> 'a option
  val dequeue : 'a t -> 'a
  val empty : 'a t -> unit
  val reverse : 'a t -> unit
  val discard_queue : 'a t -> unit
end

module MyQueue : Queue = struct
  exception NoElementLeft

  type 'a request =
    | Enqueue of 'a
    | Dequeue of 'a option channel
    | Empty
    | Reverse
    | Kill

  type 'a t = 'a request channel

  let create_queue () =
    let chan = new_channel () in
    let rec help (left, right) =
      match sync (receive chan) with
      | Enqueue new_element -> help (new_element :: left, right)
      | Dequeue retchan -> (
          match right with
          | r :: rs ->
              sync (send retchan (Some r));
              help (left, rs)
          | [] -> (
              let right = List.rev left in
              match right with
              | r :: rs ->
                  sync (send retchan (Some r));
                  help ([], rs)
              | [] ->
                  sync (send retchan None);
                  help ([], [])))
      | Empty -> help ([], [])
      | Reverse -> help (right, left)
      | Kill -> ()
    in
    let _ = create help ([], []) in
    chan

  let enqueue queue new_element = sync (send queue (Enqueue new_element))

  let dequeue_opt queue =
    let chan = new_channel () in
    sync (send queue (Dequeue chan));
    sync (receive chan)

  let dequeue queue =
    match dequeue_opt queue with
    | Some element -> element
    | None -> raise NoElementLeft

  let empty queue = sync (send queue Empty)
  let reverse queue = sync (send queue Reverse)
  let discard_queue queue = sync (send queue Kill)
end
