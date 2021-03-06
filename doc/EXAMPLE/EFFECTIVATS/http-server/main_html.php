<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>EFFECTIVATS-HttpServer</title>

<style type="text/css">
  .patsyntax {width:99%;margin:auto;}
  .patsyntax {color:#808080;background-color:#E0E0E0;}
  .patsyntax span.keyword {color:#000000;font-weight:bold;}
  .patsyntax span.comment {color:#787878;font-style:italic;}
  .patsyntax span.extcode {color:#A52A2A;}
  .patsyntax span.neuexp  {color:#800080;}
  .patsyntax span.staexp  {color:#0000F0;}
  .patsyntax span.prfexp  {color:#603030;}
  .patsyntax span.dynexp  {color:#F00000;}
  .patsyntax span.stalab  {color:#0000F0;font-style:italic}
  .patsyntax span.dynlab  {color:#F00000;font-style:italic}
  .patsyntax span.dynstr  {color:#008000;font-style:normal}
  .patsyntax span.stacstdec  {text-decoration:none;}
  .patsyntax span.stacstuse  {color:#0000CF;text-decoration:underline;}
  .patsyntax span.dyncstdec  {text-decoration:none;}
  .patsyntax span.dyncstuse  {color:#B80000;text-decoration:underline;}
  .patsyntax span.dyncst_implement  {color:#B80000;text-decoration:underline;}
</style>

<?php
include
"./SERVER/MYCODE/atslangweb_pats2xhtmlize.php";
?><!--php-->
</head>

<body>

<h1>
Effective ATS:<br>
<!--
Implementing a minimal http-server
-->
最小の HTTP サーバを実装する
</h1>

<p>
<!--
In this article, I would like to present an implementation
of a minimal http-server. This is also a good occasion for me
to advocate refinement-based programming.
-->
この記事では、最小の HTTP サーバの実装を紹介しようと思います。この実装は私にとって、改良を基本としたプログラミングを主張するための良い機会にもなりました。</p>

<h2>
<!--
A simplistic abstract server
-->
単純化した抽象サーバ
</h2>

<p>
<!--
As I have said repeatedly, I, like many others, feel that the most
challenging issue in programming (and many other forms of engineering) is
to keep the inherent complexity of the implemented system under
control. What may sound ironic is that keeping-it-simple is probably the
hardest thing to do. I hope that programmers can rely on the support for
abstract types in ATS to make this hardest thing significantly easier to
manage.
-->
繰り返しになりますが、多くの人々と同様、私とってプログラミングにおける最も挑戦的な課題は、実装されたシステム固有の複雑性を上手く制御することです。これは他の工学でも同様でしょう。皮肉にも、設計をシンプルに保つことは、時にとてつもなく困難です。この困難を軽減させるために、プログラマは ATS の抽象型を使うことができると思います。
</p>

<p>
<!--
Let us first take a look at the following self-explanatory implementation of a simplistic abstract server:
-->
はじめに、次のような単純化した抽象サーバの実装を見てみましょう:
</p>

<?php
$mycode = <<<EOT
//
extern
fun myserver (): void
extern
fun myserver_init (): void
extern
fun myserver_loop (): void

(* ****** ****** *)

implement
myserver () =
{
//
val () = myserver_init ()
val () = myserver_loop ()
//
} (* end of [myserver] *)

(* ****** ****** *)

implement
myserver_init () =
{
//
// HX: it is a dummy for now
//
val () = println! ("myserver_init: start")
val () = println! ("myserver_init: finish")
//
} (* end of [myserver_init] *)

(* ****** ****** *)

abstype request

(* ****** ****** *)
//
extern
fun myserver_waitfor_request (): request
extern
fun myserver_process_request (request): void
//
(* ****** ****** *)

implement
myserver_loop () =
{
//
val req =
myserver_waitfor_request ()
//
val () =
myserver_process_request (req)
//
val () = myserver_loop ((*void*))
//
} (* end of [myserver_loop] *)
//
EOT;
atslangweb_pats2xhtmlize_dynamic($mycode);
?><!--php-->

<p>
<!--
Basically, [myserver] implements a server; it does some form of
initializating by calling [myserver_init] and then starts a loop for
handling requests by calling [myserver_loop]. The function
[myserver_waitfor_request] is supposed to be blocked until a request
is available, and the function [myserver_process_request] processes a
given request.
-->
基本的に [myserver] は1つのサーバを実装しています;
つまり [myserver_init] 呼び出しでなんらかの初期化を行ない、その後 [myserver_loop] 呼び出しでリクエストを扱うループを開始します。関数 [myserver_waitfor_request] はリクエストが到着するまでブロックし、関数 [myserver_process_request] は与えられたリクエストを処理することになります。
</p>

<h2>
<!--
Turning abstract into concrete
-->
抽象を具体化する
</h2>

<p>
<!--
The three functions that need to be implemented
(in order to get a running server)
are [myserver_init], [myserver_waitfor_request], and
[myserver_waitfor_process]. For someone familiar with
BSD sockets, the following code should be readily accessible:
-->
実装すべき3つの関数は、サーバの実行順に、[myserver_init], [myserver_waitfor_request], [myserver_waitfor_process] ということになります。BSD ソケットに馴染みのあるプログラマにとって、次のコードは受け入れやすいものでしょう:
</p>

<?php
$mycode = <<<EOT
//
%{^
int theSockID = -1;
%} // end of [%{^]
//
(* ****** ****** *)

#define MYPORT 8888

(* ****** ****** *)

implement
myserver_init () =
{
//
val inport = in_port_nbo(MYPORT)
val inaddr = in_addr_hbo2nbo (INADDR_ANY)
//
var servaddr
  : sockaddr_in_struct
val ((*void*)) =
sockaddr_in_init
  (servaddr, AF_INET, inaddr, inport)
//
val
sockfd =
\$extfcall
(
  int, "socket", AF_INET, SOCK_STREAM, 0
) (* end of [val] *)
val ((*void*)) = assertloc (sockfd >= 0)
//
extvar "theSockID" = sockfd
//
val () =
\$extfcall
(
  void, "atslib_bind_exn", sockfd, addr@servaddr, socklen_in
) (* end of [val] *)
//
val () =
\$extfcall(void, "atslib_listen_exn", sockfd, 5(*LISTENQSZ*))
//
} (* end of [myserver_init] *)
//
EOT;
atslangweb_pats2xhtmlize_dynamic($mycode);
?><!--php-->

<p>
<!--
Essentially, [myserver_init] creates a server-side socket
that is allowed to accept connection from any party, and then
listens on the socket. Note that the file descriptor of the
created socket is stored in a global variable [theSockID].
The function [atslib_bind_exn] calls [bind]; it
exits if the call to [bind] results in an error; otherwise,
it returns normally.
Similarly, the function [atslib_listen_exn] calls [listen]; it
exits if the call to [listen] results in an error; otherwise,
it returns normally.
-->
本質的に [myserver_init] は、どこからでも接続を受け付けるサーバ側ソケットを生成し、そのソケットをリッスンします。生成したソケットのファイルディスクリプタはグローバル変数 [theSockID] に保管されていることに、注意してください。関数 [atslib_bind_exn] は [bind] を呼び出し、[bind] 呼び出しがエラーを返したらプログラムは終了し、そうでない場合にはこの関数は返ります。同様に、関数 [atslib_listen_exn] は [listen] を呼び出し、[listen] 呼び出しがエラーを返したらプログラムは終了し、そうでない場合にはこの関数は返ります。
</p>

<p>
<!--
The function [myserver_waitfor_request] can be implemented
as follows:
-->
関数 [myserver_waitfor_request] は次のように実装できます:
</p>

<?php
$mycode = <<<EOT
//
implement
myserver_waitfor_request
  ((*void*)) = let
//
val fd = \$extval(int, "theSockID")
val fd2 = \$extfcall(int, "accept", fd, 0(*addr*), 0(*addrlen*))
//
in
  \$UN.cast{request}(fd2)
end // end of [myserver_waitfor_request]
//
EOT;
atslangweb_pats2xhtmlize_dynamic($mycode);
?><!--php-->

<p>
<!--
A call to [accept] is blocked until a connection between the server and a
client is established. What is returned by [accept] is the file descriptor of
a socket that can be used to communicate with the client.
-->
[accept] 呼び出しは、サーバとクライアントの接続が確立されるまでブロックします。
[accept] は、クライアントと通信するためのソケットのファイルディスクリプタを返します。
</p>

<p>
<!--
The function [myserver_process_request] is implemented as follows:
-->
関数 [myserver_process_request] は次のように実装できます:
</p>

<?php
$mycode = <<<EOT
//
#define BUFSZ 1024
#define BUFSZ2 1280
//
(* ****** ****** *)

val
theRespFmt = "\\
HTTP/1.0 200 OK\\r\\n\\
Content-type: text/html\\r\\n\\r\\n\\
<!DOCTYPE html>
<html>
<head>
<meta charset=\\"UTF-8\\">
<meta http-equiv=\\"Content-Type\\" content=\\"text/html\\">
</head>
<body>
<h1>
Hello from myserver!
</h1>
<pre>
%s
</pre>
<pre>
<u>The time stamp</u>: <b>%s</b>
</pre>
</body>
</html>
" // end of [val]

(* ****** ****** *)

%{^
typedef char *charptr;
%} // end of [%{^]
abstype charptr = \$extype"charptr"

(* ****** ****** *)

implement
myserver_process_request
  (req) = let
//
val fd2 = \$UN.cast{int}(req)
//
var buf = @[byte][BUFSZ]()
var buf2 = @[byte][BUFSZ2]()
//
val bufp = addr@buf and bufp2 = addr@buf2
//
val nread = \$extfcall (ssize_t, "read", fd2, bufp, BUFSZ)
//
(*
val () = println! ("myserver_process_request: nread = ", nread)
*)
//
var time = time_get()
val tmstr = \$extfcall(charptr, "ctime", addr@time)
//
val () =
if
nread >= 0
then let
  val [n:int] n = \$UN.cast{Size}(nread)
  val () = \$UN.ptr0_set_at<char> (bufp, n, '\\000')
//
  val nbyte =
    \$extfcall(int, "snprintf", bufp2, BUFSZ2, theRespFmt, bufp, tmstr)
  // end of [val]
//
  val nwrit = \$extfcall(ssize_t, "write", fd2, bufp2, min(nbyte, BUFSZ2))
//
in
  // nothing
end // end of [then]
//
//
val err = \$extfcall (int, "close", fd2)
//
in
  // nothing
end // end of [myserver_process_request]
//
EOT;
atslangweb_pats2xhtmlize_dynamic($mycode);
?><!--php-->

<p>
<!--
The implementation of [myserver_process_request] reads from a
buffer whatever is sent by the client; it generates an HTML page
containing the content of the buffer plus a time stamp and then
sends the page to the client.
-->
[myserver_process_request] の実装は、クライアントから送信されたデータをバッファから読み込みます。そして、そのバッファの内容とタイムスタンプを含む HTML ページを生成し、そのページをクライアントに送信します。
</p>

<h2>
<!--
Testing
-->
テスト
</h2>

<p>
<!--
The entirety of the code for this implementation is contained in
<u>myserver.dats</u>. There is also a Makefile available for building
the server. Please click the link
<a href="http://127.0.0.1:8888">http://127.0.0.1:8888</a>
to test after the server is started running locally.
-->
この実装のコード全体は <u>myserver.dats</u> から入手できます。サーバをコンパイルするための Makefile もあります。ローカルにサーバを起動した後、リンク <a href="http://127.0.0.1:8888">http://127.0.0.1:8888</a> をクリックすればテストできます。
</p>

<h2>
<!--
A side note
-->
メモ
</h2>

<p>
<!--
For someone interested in <a href="http://www.zeromq.org">ZMQ</a>,
please find in the file <u>myserver2.dats</u> a ZMQ-based implementation
of a http-server that is essentially equivalent to the one given above.
-->
<a href="http://www.zeromq.org">ZMQ</a> に興味がある読者には、ZMQ を使った上記と本質的に等価な HTTP サーバの実装 <u>myserver2.dats</u> もあります。
</p>

<hr size="2">

<!--
This article is written by <a href="http://www.cs.bu.edu/~hwxi/">Hongwei Xi</a>.
-->
この記事は <a href="http://www.cs.bu.edu/~hwxi/">Hongwei Xi</a> によって書かれ、<a href="http://jats-ug.metasepi.org/">Japan ATS User Group</a> によって翻訳されています。

</body>
</html>
