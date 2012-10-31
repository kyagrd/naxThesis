%include lhs2TeX.fmt
%include includelhs2tex.lhs

\section{TODO discussion}

\subsection{Universes, kinds, and well-sortedness}

In all three languages, the datatype |Val| has the kind annotation |Ty -> *|,
which means that |Val| is a unary type constructor that expects a term of
type |Ty|, rather than a type (c.f., a unary type constructor that expects
a type has kind |* -> *|). Although the textual form of the kind, (|Ty -> *|),
coincides in the three languages, each language has its own
universe structure, kind syntax, and justifications for well-sortedness
(\aka\ kind validity) as illustrated in Fig.\;\ref{fig:sorting}.

In a nutshell, the mechanism that allow types at kind level in Nax
is closely related to \emph{universe subtyping} in Agda, and,
the datatype promotion in Haskell is closely related to
\emph{universe polymorphism} in Agda.


Term index types mean that we have to extend how we form both types and kinds.
Several approaches. a typer like (List Int Zero) will not be well formed.
we can lift Zero to a type (Haskell), Extend what is a type and kind (Nax),
unify terms and types and kinds, and use a hierarchy of universes. Nax is
particularly simple.

Haskell Types are promoted (|T : * -> *|) promoted to (|T : BOX -> BOX|)
limits the promotion of types with term-indexes, unless |* : *|

Nax, add an additional constructor for kinds, a specail kind of kind-arrow
to |Nat => *| is a kind. Everything else follows logically from this.

Agda. A hieracrhy of universers allows types and kinds to be prom ....


\begin{figure}
\hspace*{-3ex} \centering
\begin{tabular}{ccc}
\textsc{Haskell} \textcolor{gray}{\texttt{+ DataKinds}} &
\textsc{Nax} &
\textsc{Agda} 
\\
\\
|* : BOX| &
|* : BOX| &
$\star_0 : \star_1 : \star_2 : \star_3 : \cdots$ \\ & &
$\stackrel{\parallel}{|*|}~\,\stackrel{\parallel}{|BOX|}~~\quad\qquad\qquad$
\\ \\
|kappa ::= * || kappa -> kappa | $\mid$
  \textcolor{magenta}{$T\,$}$\overline{\kappa}$
& \qquad
|kappa ::= * || kappa -> kappa | $\mid$
   \textcolor{magenta}{|{A}|}\,|-> kappa|
& \quad
\begin{minipage}{.37\linewidth}\small\centering
term/type/kind/sort syntax are\\ merged into one pseudo-term
\end{minipage}
\\
\begin{minipage}{.25\linewidth}
\[ \inference{\Jki |kappa1 : BOX| & \Jki |kappa2 : BOX|}{
              \Jki |kappa1 -> kappa2 : BOX|} \]
\[ \inference{\Jty T : |*|^n -> |*| }{\Jki T : |BOX|^n -> |BOX|} \]
\end{minipage}
&
\begin{minipage}{.25\linewidth}
\[ \inference{\Jty |A : *| & \Jki |kappa : BOX|}{\Jki |{A} -> kappa : BOX|} \]
\[ \phantom{\inference{||- \kappa : s & s \leq s'}{||- \kappa : s'} } \]
\end{minipage}
&
\begin{minipage}{.25\linewidth}
\[ \inference{||- \kappa_1 : \star_i & ||- \kappa_2 : \star_i}{
              ||- \kappa_1 -> \kappa_2 : \star_i} \]
\[ \inference{||- \kappa : s & s \leq s'}{||- \kappa : s'} \]
\end{minipage}
\end{tabular}

\caption{The universe structure, kind syntax, and some selected sorting rules
   of the three different languages, Haskell, Nax, and Agda.}
\label{fig:sorting}
\end{figure}
 and
   justifications for well-sortedness of the kind |List Ty -> *|
   in three different languages.


{ \inference{ \!\!\!\!\!\!\!\!\!\!\!\!
              \inference{ \!\!\!\!\!\!\!
                        \inference{\Jty |List: * -> *|}{
                             \Jki |List: BOX -> BOX|}
                        & \inference{\Jty |Ty : *|}{\Jki |Ty : BOX|} }{
              \Jki |List Ty : BOX|}
            & \Jki |* : BOX| }{
    \Jki |{List Ty} -> * : BOX| }
}

{ \inference{ \!\!\!\!\!\!\!\!\!\!\!\!
            \inference{\Jty |List : * -> *| \\ \Jty |Ty : *| \qquad }{
              \Jty |List Ty : *| }
            & \Jki |* : BOX| }{
     \Jki |List Ty -> * : BOX| }
}

\[ \inference{ \!\!\!\!\!\!\!\!\!\!\!\!\!\!\!\!
              \inference{||- |Ty : *| & |* <= BOX|}{||- |Ty : BOX|}
            & ||- |* : BOX| }{
    ||- |Ty -> * : BOX| }
\]



The datatype promotion extension ({\small\texttt{DataKinds}}) for Haskell
works as follows:
(1) check if a type constructor |T| is well-kinded
    ($\Jty T : \overline{\star} -> \star$),
(2) promote |T| to the kind level
    (note $T\,\overline{\kappa}\,$ in the kind syntax), and
(3) check well-sortedness of the promoted |T| used in kinds
    ($\Jki T\,\overline{\kappa} : |BOX|$).
In our example, we need not worry about the arguments to the type constructor
since |Ty| is a just a type (\ie, nullary type constructor).
The justification for $\Jki |Ty -> * : BOX|$ in Haskell is illustrated at
the left bottom corner of Table\;\ref{fig:sorting}.
Note the promotion of |Ty|, from $\Jty |Ty : *|$ to $\Jki |Ty : BOX|$.
We can also view that |Ty| is a polymorphic definition across the type universe,
since |Ty| can be used at type level (|*|) as well as at kind level (|BOX|).

Types can appear in kinds in Nax as well as in Haskell. However, the mechanism
that allows types at kind level in Nax is quite different from the promotion of
type constructors in Haskell. Nax has a simple universe structure (|* : BOX|)
just like Haskell. But, unlike the promotion in Haskell, Nax provides a direct
way of forming arrow from types to kinds (note the |A -> kappa| syntax). There
are two ways of forming arrows at kind level in Nax:\vspace*{-1ex}
\begin{itemize}
\item[(1)] from a kind to another kind
   $\inference{\Jki |kappa1:BOX| & \Jki |kappa2:BOX|}{
        \Jki |kappa1 -> kappa2|}$,
and\vskip1ex
\item[(2)] from a type to a kind
   $\inference{\Jty |A : *| & \Jki |kappa : BOX|}{
        \Jki |A -> kappa|}$.
\end{itemize}
Note that types can only appear in the domain (\ie, left-hand-side of the arrow)
but not the range (\ie, right-hand-side of the arrow).
Modulo right associativity of arrows (\ie, |kappa1 -> kappa2 -> kappa3|
means |kappa1 -> (kappa2 -> kappa3)|), kinds in Nax always end up in |*|
(\eg, |* -> * -> *|, |Nat -> Nat -> *|, |(Nat -> *) -> Nat -> *|).
Note that we do not promote types or type constructors to kind level.
Type constructors must be fully applied to their type level arguments
to form a type of kind |*| before being used at kind level, which is
in opposite order from the promotion of type constructor in Haskell
where we first promote type constructors to kind level and then
apply kind level arguments. The second formation rule (2) could be
understood as a specific use of universe subtyping (|* <= BOX|) hard-wired
with arrow formation. Nax only needs to use universe subtyping in this rule
since the universe structure is simple and there is no full-fledged
dependent types. Agda needs a more general notion of universe subtyping
since Agda is a dependently typed language with stratified universes, which
we will shortly explain.

Agda has stratified type universes. That is, there are countably many stars
$\star_0,\star_1,\dots$ such that $||- \star_n : \star_{1+n}$. When we
from an arrow in Agda, that is, $||- |kappa1 -> kappa2| : \star_n$,
its well-formedness condition is when $||- |kappa1| : \star_n$ and
$||- |kappa2| : \star_n$. However, requiring |kappa1|, |kappa2|, and
|kappa1 -> kappa2| to be in exactly the same universe can cause a lot of
code duplication. For example, if we have $||- |Ty| : \star_0$ and
we want to construct $|Ty| -> \star_0$, we cannot do this since
$||- \star_0:\star_1$. To work around the universe difference, we
would need to duplicate another datatype $||- |Ty'| : \star_1$,
which is isomorphic to |Ty| but at one higher level. Only then,
we can construct $|Ty'| -> \star_0$. Then, if one needs
$|Ty| -> \star_1$, we would need yet another duplicate |Ty''|
at yet another higher level. Universe subtyping provides a remedy
to this duplication problem by allowing objects at lower universe
to be considered as objects at higher universe -- in other words,
it is `promoted' to upper level. This gives us a notion of subtyping
such that $\star_i \leq \star_j$ where $i \leq j$.\footnote{
	This is not the only rule for subtyping in Agda.
 	Another important rule is subtyping between arrows.
	See Ulf Norell's thesis [TODO cite] (Sect.\;1.4) for details.}
With universe subtyping, we can form arrows from |Ty| to any level of universe
(\eg, $|Ty| -> \star_0$, $|Ty| -> \star_1$, $\dots$). Relating back to
the datatype promotion in Haskell, $\star_0$ and $\star_1$ corresponds to |*|
and |BOX| in Haskell. So, we wrote |*| and |BOX| instead of $\star_0$ and
$\star_1$ in the justification of well-formedness of |Ty -> *| in Agda
(at right bottom corner of Fig.\;\ref{fig:sorting}) to make the comparison
more apparent. In addition to universe subtyping, Agda also supports
universe polymorphism,\footnote{
\url{http://wiki.portal.chalmers.se/agda/agda.php?n=Main.UniversePolymorphism}}
which can be viewed as a generalization of the datatype promotion in Haskell.
But, we only rely on universe subtyping but not universe polymorphism in
our Agda example codes in Figs.\;\ref{fig:eval}, \ref{fig:glist}, and
\ref{fig:compile}.

\subsection{Kind polymorphism}
TODO

Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.


\subsection{Deeply indexed datatypes and datatypes containing types}

Examples in Sect.\;\ref{sec:example} consisted of rather simple
indexed datatypes, where the terms indices are of datatypes
without any term indices (\eg, |Unit|, |Nat|, |Bool|).
One can imagine more complex indexed datatypes, where some term indices
are themselves of indexed datatypes. Such deeply indexed datatypes are
often useful in dependently typed programming. For instance, \citet{BraHam10}
defines a datatype for environments that contain stateful resources in order
to implement their embedded domain specific language (EDSL) for verified
resource usage protocols. Figure \ref{fig:env} is a transcription of
their environment datatype (|Env|) in Idris into Nax. Note that the datatype
|Env| is indexed by a term of a length indexed list datatype, which is again
indexed by a natural number term. There is no Haskell transcription because
datatype promotion \cite{YorgeyWCJVM12} is limited to datatypes without any
term indices. That is, Nax supports deeply nested datatypes while Haskell's
datatype promotion does not.

\begin{figure}
\qquad\begin{minipage}{.8\linewidth}
%% %include Env.lagda
%% ~\\
%include Env.lnax
\end{minipage}
\caption{Environments of stateful resources
	indexed by the length indexed list of states}
\label{fig:env}
\end{figure}

On the contrary, Haskell supports datatypes that hold types as elements,
although limited to types without term indices, but Nax does not.
The heterogeneous list datatype (|HList|) in Fig.\;\ref{fig:hlist}
is a well-known example that makes use of datatypes containing types.
Note that |HList| is index by |List{-"\;"-}*|, which is a promoted
regular list whose elements are of kind |*| (\ie, element are types).
For instance, |hlist| in Fig.\;\ref{fig:hlist} contains
three elements |3 : Int|, |True : Bool|, and |(1 :.2 :. Nil) : List Int|,
and it has type |HList (Int :. Bool :. List Int :. Nil)|.

\begin{figure}
\qquad\begin{minipage}{.5\linewidth}
$\underline{
 \textsc{Haskell}
 \textcolor{gray}{
  \texttt{+}\;\texttt{GADTs},\;\texttt{DataKinds},\;\texttt{PolyKinds}}
 \phantom{_{g_g}} \qquad\qquad\qquad
 }$ \\ \vskip-1ex
\begin{code}
data List a = Nil | a :. List a{-"~"-};{-"~"-}infixr :.

data HList :: List {-"\;"-} * -> * where
  HNil  :: HList Nil
  HCons :: t -> HList ts -> HList (t :. ts)

hlist :: HList (Int :. Bool :. List Int :.  Nil)
hlist = HCons 3 (HCons True (HCons (1 :. 2 :. Nil) HNil))
\end{code}
\end{minipage}
\caption{Heterogeneous lists (|HList|) indexed by
	 the list of element types (|List{-"\;"-}*|).}
\label{fig:hlist}
\end{figure}

\subsection{Singleton types}
TODO

Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.
Write text here.  Write text here.  Write text here.  Write text here.

