(*
** for testing [libats/bitvec]
*)

(* ****** ****** *)
//
// Author: Hongwei Xi
// Authoremail: gmhwxiDOTgmailDOTcom
// Start time: December, 2014
//
(* ****** ****** *)
//
#include "share/atspre_staload.hats"
//
(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload "libats/SATS/bitvec.sats"
staload _(*anon*) = "libats/DATS/bitvec.dats"

(* ****** ****** *)

implement
main0 () =
{
//
#define nbit 80
//
val
out = stdout_ref
//
val () = fprintln! (out, "[libats_bitvec] starts!")
//
val bvp1 = bitvecptr_make_none (nbit)
val () = fprint (out, "bvp1 = ")
val () = fprint_bitvecptr (out, bvp1, nbit)
val ((*newln*)) = fprint_newline (out)
//
val () = bitvecptr_lnot(bvp1, nbit)
val () = fprint (out, "bvp1 = ")
val () = fprint_bitvecptr (out, bvp1, nbit)
val ((*newln*)) = fprint_newline (out)
//
val bvp2 = bitvecptr_make_full (nbit)
val () = fprint (out, "bvp2 = ")
val () = fprint_bitvecptr (out, bvp2, nbit)
val ((*newln*)) = fprint_newline (out)
//
val () =
  assertloc(bitvecptr_equal(bvp1, bvp2, nbit))
//
val () = bitvecptr_lor (bvp1, bvp2, nbit)
val () = fprint (out, "bvp1 = ")
val () = fprint_bitvecptr (out, bvp1, nbit)
val ((*newln*)) = fprint_newline (out)
//
val () = bitvecptr_lxor (bvp1, bvp2, nbit)
val () = fprint (out, "bvp1 = ")
val () = fprint_bitvecptr (out, bvp1, nbit)
val ((*newln*)) = fprint_newline (out)
//
val () = bitvecptr_land (bvp1, bvp2, nbit)
val () = fprint (out, "bvp1 = ")
val () = fprint_bitvecptr (out, bvp1, nbit)
val ((*newln*)) = fprint_newline (out)
//
local
implement
bitvec_tabulate$fopr<> (i) = g1int_nmod(i, 2)
in(*in-of-local*)
val bvp3 = bitvecptr_tabulate (nbit)
end // end of [local]
val () = fprint (out, "bvp3 = ")
val () = fprint_bitvecptr (out, bvp3, nbit)
val ((*newln*)) = fprint_newline (out)
//
val ((*freed*)) = bitvecptr_free (bvp1)
val ((*freed*)) = bitvecptr_free (bvp2)
val ((*freed*)) = bitvecptr_free (bvp3)
//
val () = fprintln! (out, "[libats_bitvec] is done!")
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [libats_bitvec.dats] *)
