(*
** A test for atspkgreloc
*)
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
staload UN = $UNSAFE
//
(* ****** ****** *)

#define
ATS_PACKNAME "atspkgreloc_test03"

(* ****** ****** *)
//
require
"{http://www.ats-lang.org/LIBRARY}/contrib/pcre/CATS/pcre.cats"
//
(* ****** ****** *)
//
staload
"{http://www.ats-lang.org/LIBRARY}/contrib/pcre/SATS/pcre.sats"
staload
"{http://www.ats-lang.org/LIBRARY}/contrib/pcre/SATS/pcre_ML.sats"
//
staload _ =
"{http://www.ats-lang.org/LIBRARY}/contrib/pcre/DATS/pcre.dats"
staload _ =
"{http://www.ats-lang.org/LIBRARY}/contrib/pcre/DATS/pcre_ML.dats"
//
(* ****** ****** *)

local
//
#include "{http://www.ats-lang.org/LIBRARY}/contrib/pcre/DATS/pcre.dats"
#include "{http://www.ats-lang.org/LIBRARY}/contrib/pcre/DATS/pcre_ML.dats"
//
in (* in of [local] *)
//
// HX: it is intentionally left to be empty
//
end // end of [local]

(* ****** ****** *)

fun tally
(
  subject: string
) : int = let
//
val regstr = "(-?[0-9]+)"
//
fun loop
(
  p: ptr, sum: int
) : int = let
  var _beg: int
  and _end: int
  var err: int
  val res = regstr_match3_string (regstr, $UN.cast{String}(p), _beg, _end, err)
in
//
case+ res of
| ~list_vt_nil () => sum
| ~list_vt_cons
    (x, res) => let
    val-~list_vt_nil () = res
    val () = assertloc (strptr2ptr(x) > 0)
    val int = g0string2int ($UN.strptr2string(x))
    val () = strptr_free (x)
  in
    loop (ptr_add<char> (p, _end), sum + int)
  end // end of [loop]
//
end // end of [loop]
//
in
  loop (string2ptr(subject), 0)
end // end of [tally]

(* ****** ****** *)

implement
main0 () = () where
{
//
val subject0 = "-1,-2,-3,-4,-5,6,7,8,9,10"
//
val () = println! ("tally(", subject0, ") = ", tally(subject0))
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [test03.dats] *)
