(*
// ATS-texting
*)
(* ****** ****** *)
//
#include
"utils/atexting\
/atexting_include_all.dats"
//
(* ****** ****** *)
//
#include
"utils/atexting\
/DATS/SHARE/atexting_textdef_pre.dats"
//
#include
"utils/atexting\
/DATS/SHARE/atexting_textdef_xhtml.dats"
//
(* ****** ****** *)
//
extern
fun
libatsynmark_dynloadall(): void = "ext#"
val () = libatsynmark_dynloadall((*void*))
//
(* ****** ****** *)

(* end of [myatexting.dats] *)

