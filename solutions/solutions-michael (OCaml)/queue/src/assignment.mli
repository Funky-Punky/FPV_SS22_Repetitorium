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

module MyQueue : Queue
