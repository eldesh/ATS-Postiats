(* ****** ****** *)
//
#include
"share/atspre_define.hats"
//
staload
"{$LIBATSCC2JS}/SATS/Worker/channel.sats"
//
(* ****** ****** *)
(*
typedef
P_ssn =
chsnd(int)::chsnd(int)::chrcv(bool)::chnil
*)
//
typedef
Q_ssn =
chrcv(int)::chrcv(int)::chsnd(bool)::chnil
//
(* ****** ****** *)

(* end of [introxmpl1_prot.sats] *)
