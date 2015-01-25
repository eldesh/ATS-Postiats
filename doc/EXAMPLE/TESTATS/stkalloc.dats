//
// Test code for stack allocation
//
(* ****** ****** *)

#include
"share/atspre_staload.hats"

(* ****** ****** *)

val () =
{
var x: int = 0
prval () = showviewtype (x)
} (* end of [val] *)

(* ****** ****** *)

val () =
{
var !p_x: int = 0
prval () = showviewtype (!p_x)
} (* end of [val] *)

(* ****** ****** *)

val () =
{
//
var A = @[int][3]()
prval () = showviewtype (A)
//
} (* end of [val] *)

(* ****** ****** *)

val () =
{
//
var A = @[int][3](1)
prval () = showviewtype (A)
//
val out = stdout_ref
//
val () =
(
  fprint (out, "A = "); fprint (out, A, 3); fprint_newline (out)
)
//
} (* end of [val] *)

(* ****** ****** *)

val () =
{
//
var A = @[int](0, 0, 0)
val () = A[1] := 1 and () = A[2] := 2
//
val out = stdout_ref
//
val () =
(
  fprint (out, "A = "); fprint (out, A, 3); fprint_newline (out)
)
//
} (* end of [val] *)

(* ****** ****** *)

val () =
{
//
val out = stdout_ref
//
var square =
lam@ (x: int): int => x * x
//
prval () = showviewtype (square)
//
val ((*void*)) = fprintln! (out, "square(", 10, ") = ", square(10))
//
} (* end of [val] *)

(* ****** ****** *)

val () =
{
//
val out = stdout_ref
//
var factorial =
fix@ f (x: int): int => if x > 0 then x * f(x-1) else 1
//
prval () = showviewtype (factorial)
//
val ((*void*)) = fprintln! (out, "factorial(", 10, ") = ", factorial(10))
//
} (* end of [val] *)

(* ****** ****** *)

fun
factorial2 (n: int): int = let
//
var
factorial2_loop =
fix@ f
(
  i: int, res: int
) : int => if i < n then f (i+1, (i+1)*res) else res
//
prval () = showviewtype (factorial2_loop)
//
in
  factorial2_loop (0, 1)
end // end of [factorial2]

(* ****** ****** *)

val () = fprintln! (stdout_ref, "factorial2(10) = ", factorial2(10))

(* ****** ****** *)

implement main0 () = ()

(* ****** ****** *)

(* end of [stkalloc.dats] *)
