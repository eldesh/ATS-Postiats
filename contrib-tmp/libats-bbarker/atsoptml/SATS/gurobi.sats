(* ****** ****** *)
//
// API in ATS for GUROBI
//
(* ****** ****** *)

(*
** Permission to use, copy, modify, and distribute this software for any
** purpose with or without fee is hereby granted, provided that the above
** copyright notice and this permission notice appear in all copies.
** 
** THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
** WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
** MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
** ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
** WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
** ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
** OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*)

(* ****** ****** *)
//
// Start time: January, 2014
//
(* ****** ****** *)

(*
** Author: Brandon Barker 
** Authoremail: brandonDOTbarkerATgmailDOTcom)
*)

(* ****** ****** *)

(*
** Author: Hongwei Xi (gmhwxiDOTgmailDOTcom)
*)

(* ****** ****** *)

#define ATS_PACKNAME "ATSCNTRB.gurobi" // package name
#define ATS_EXTERN_PREFIX "atscntrb_gurobi_" // prefix for external names"

(* ****** ****** *)

typedef NSH(x:type) = x // for commenting: no sharing
typedef NONZERO(x:type) = x // for commenting: non-zero values only

(* ****** ****** *)

typedef interr(i:int) = int(i)
typedef Interr = [i:nat] interr(i)

(* ****** ****** *)
//
absvtype
GRBenvptr (l:addr) = ptr (l)
//
vtypedef GRBenvptr0 = [l:addr] GRBenvptr(l)
vtypedef GRBenvptr1 = [l:addr | l > null] GRBenvptr(l)
//
(* ****** ****** *)
//
absvtype
GRBmodelptr(l:addr) = ptr (l)
//
vtypedef
GRBmodelptr0 = [l:addr] GRBmodelptr(l)
vtypedef
GRBmodelptr1 = [l:addr | l > null] GRBmodelptr(l)
//
typedef
GRB_VARTYPE = char
//
(* ****** ****** *)

// numnz has associtated values that shouldn't be zero:
// I believe ATS doesn't offer any static typing for doubles,
// and I'm not yet sure if gurobi does dynamic checking.
//
// Relatedly, numnz and other arrays (currently cPtr(T)s) 
// could be converted to dependent types.


// constants
(* ****** ****** *)
//
macdef GRB_BINARY = $extval (char, "GRB_BINARY")
//
macdef
GRB_INT_ATTR_MODELSENSE =
  $extval (string, "GRB_INT_ATTR_MODELSENSE")
//
macdef GRB_MAXIMIZE = $extval(int, "GRB_MAXIMIZE")
macdef GRB_MINIMIZE = $extval(int, "GRB_MINIMIZE")
//
(* ****** ****** *)
//
macdef GRB_EQUAL = $extval(char, "GRB_EQUAL")
macdef GRB_LESS_EQUAL = $extval(char, "GRB_LESS_EQUAL")
macdef GRB_GREATER_EQUAL = $extval(char, "GRB_GREATER_EQUAL")
//
(* ****** ****** *)

fun GRBloadenv
(
  envP: &ptr? >> opt(GRBenvptr1, i==0), logfilename: stropt
) : #[i:nat] interr (i) = "mac#%"

(* ****** ****** *)

fun GRBloadclientenv
(
  envP: &ptr? >> opt(GRBenvptr1, i==0), logfilename: stropt
, server: stropt, port: int, passwd: stropt, priority: int, timeout: double
) : #[i:nat] interr (i) = "mac#%"

(* ****** ****** *)

fun GRBfreeenv (env: GRBenvptr0): void = "mac#%"

(* ****** ****** *)
//
praxi GRBfreemodel_null (GRBmodelptr(null)): void
//
(* ****** ****** *)

//
// Ideally we do not call the following functions
// directly but develop other abstractions.
//

//absvtype varname = string

fun
GRBloadmodel
  {nv,nc:int}{nx:int}
(
  env		: !GRBenvptr1
, modelP	: &ptr? >> opt(GRBmodelptr1, i==0)
, Pname		: string
, numvars	: int(nv)
, numconstrs	: int(nc)
, objsense	: int // 1(min) or -1(max)
, objcon	: double
, obj		: carrayptr0(double, nv)
, sense		: carrayptr1(char, nc)
, rhs		: carrayptr0(double, nc)
, vbeg		: carrayptr1(int, nv)
, vlen		: carrayptr1(int, nv)
, vind		: carrayptr1(int, nx) // HX: indefinite [nx]
, vval		: carrayptr1(int, nx) // HX: indefinite [nx]
, lbound	: carrayptr0(double, nv)
, ubound	: carrayptr0(double, nv)
, vtype		: carrayptr0(GRB_VARTYPE, nv)
, varnames	: carrayptr0(string, nv)
, constrnames	: carrayptr0(string, nc)
) : #[i:nat] interr (i) = "mac#%"

(* ****** ****** *)

fun
GRBnewmodel
  {nv,nc:int}{nx:int}
(
  env		: !GRBenvptr1
, modelP	: &ptr? >> opt(GRBmodelptr1, i==0)
, Pname		: string
, numvars	: int(nv)
, obj		: carrayptr0(double, nv)
, lb		: carrayptr0(double, nv)
, ub		: carrayptr0(double, nv)
, vtype		: carrayptr0(GRB_VARTYPE, nv)
, varnames	: carrayptr0(string, nv)
) : #[i:nat] interr (i) = "mac#%"

fun
GRBnewmodel_null
(
  env		: !GRBenvptr1
, modelP	: &ptr? >> opt(GRBmodelptr1, i==0)
, Pname		: string
) : #[i:nat] interr (i) = "mac#%"

(* ****** ****** *)

fun GRBcopymodel
  (model: !GRBmodelptr1): GRBmodelptr0 = "mac#%"

(* ****** ****** *)

fun
GRBaddvar{nx:int}
(
  model: !GRBmodelptr1
, numnz: int (nx)
, vind: carrayptr1 (int, nx)
, vval: carrayptr1 (double, nx)
, obj: double, lb: double, ub: double
, vtype: GRB_VARTYPE, varname: stropt
) : Interr = "mac#%"

(* ****** ****** *)

//vbeg should be assigned a different, more specialized
//type than carrayptr: see gurobi docs 

fun
GRBaddvars
  {nv:int}{nx:int}
(
  model		: !GRBmodelptr1
, numvars	: int(nv)
, numnz		: int(nx)
, vbeg		: carrayptr1(int, nv)
, vind		: carrayptr1(int, nx) // HX: indefinite [nx]
, vval		: carrayptr1(int, nx) // HX: indefinite [nx]
, obj		: carrayptr0(double, nv)
, lbound	: carrayptr0(double, nv)
, ubound	: carrayptr0(double, nv)
, vtype		: carrayptr0(GRB_VARTYPE, nv)
, varnames	: carrayptr0(string, nv)
) : Interr = "mac#%"

(* ****** ****** *)

fun
GRBaddvars_nocon
  {nv:int}{nx:int}
(
  model		: !GRBmodelptr1
, numvars	: int(nv)
, numnz		: int(nx)
, obj		: carrayptr0(double, nv)
, vtype		: carrayptr0(GRB_VARTYPE, nv)
, varnames	: carrayptr0(string, nv)
) : Interr = "mac#%"

(* ****** ****** *)

fun
GRBaddvars_nocon_noname
  {nv:int}{nx:int}
(
  model		: !GRBmodelptr1
, numvars	: int(nv)
, numnz		: int(nx)
, obj		: carrayptr0(double, nv)
, vtype		: carrayptr0(GRB_VARTYPE, nv)
) : Interr = "mac#%"

(* ****** ****** *)

fun
GRBaddconstr
  {nx:int}
(
  model         : !GRBmodelptr1
, numnz         : int(nx)
, cind          : carrayptr0(int, nx)
, cval          : carrayptr0(double, nx)
, sense         : char
, rhs           : double
, constrname    : NSH(string) 
) : Interr = "mac#%"
  
(* ****** ****** *)

fun
GRBsetintattr
(
  model: !GRBmodelptr1, name: NSH(string), value: int
) : Interr = "mac#%"

(* ****** ****** *)
//
fun
GRBupdatemodel (model: !GRBmodelptr1): Interr = "mac#%"
//
(* ****** ****** *)

fun GRBfreemodel (model: GRBmodelptr1): Interr = "mac#%"

(* ****** ****** *)
//
fun GRBoptimize (model: !GRBmodelptr1): Interr = "mac#%"
//
(* ****** ****** *)

fun
GRBreadmodel (
  env: !GRBenvptr1
, filename: NSH(string), modelP: &ptr? >> opt(GRBmodelptr1, i==0)
) : #[i:nat] interr (i) = "mac#%"

(* ****** ****** *)

fun GRBread (model: !GRBmodelptr1, filename: NSH(string)
): Interr  = "mac#%"
fun GRBwrite (model: !GRBmodelptr1, filename: NSH(string)
): Interr = "mac#%"

(* ****** ****** *)

fun
GRBversion
(
  majorP: &int? >> _, minorP: &int? >> _, technicalP: &int? >> _
) : void = "mac#%" // end of [GRBversion]
                
(* ****** ****** *)
//
fun GRBgeterrormsg (env: !GRBenvptr1): vStrptr1 = "mac#%"
//
(* ****** ****** *)
//
// HX-2014-01: Some convenience functions
//
(* ****** ****** *)
//
fun{}
fprint_GRBerrormsg (out: FILEref, env: !GRBenvptr1): void
//
(* ****** ****** *)
//
fun{}
fprint_GRBerrormsg_if (out: FILEref, env: !GRBenvptr1, errno: int): void
//

(* ****** ****** *)

// Include at end to prevent problems with ATS2 Mode in emacs:
%{^
//
#include "./../CATS/gurobi.cats"
//
%} // end of [%{#]

(* ****** ****** *)

(* end of [gurobi.sats] *)
