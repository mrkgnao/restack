# Restack

Restack is a (currently in the "still playing around" stage) Haskell interface to the [Stacks project](https://github.com/stacks/stacks-project).

It uses the Stacks Project API, which is documented [here](http://stacks.math.columbia.edu/api).

## Example

As of now, here is what can be done:

```latex
λ main
Enter tag id: 0D4X
Choose format ([l]atex / [h]tml): l
Include proof? (y/n): y

\begin{theorem}[Algebraicity of the stack of polarized schemes]
\label{theorem-polarized-algebraic}
The stack $\textit{Polarized}$ (Situation \ref{situation-polarized})
is algebraic. In fact, for any algebraic space $B$ the stack
$B\textit{-Polarized}$ (Remark \ref{remark-polarized-base-change})
is algebraic.
\end{theorem}

\begin{proof}
The absolute case follows from
Artin's Axioms, Lemma \ref{artin-lemma-diagonal-representable}
and Lemmas \ref{lemma-polarized-diagonal},
\ref{lemma-polarized-RS-star},
\ref{lemma-polarized-limits},
\ref{lemma-polarized-existence}, and
\ref{lemma-polarized-defo-thy}.
The case over $B$ follows from this, the description of
$B\textit{-Polarized}$ as a $2$-fibre product in
Remark \ref{remark-polarized-base-change}, and the fact
that algebraic stacks have $2$-fibre products, see
Algebraic Stacks, Lemma \ref{algebraic-lemma-2-fibre-product}.
\end{proof}
```
    
# Overview

Tags are stored in an `RTag` record type. One can retrieve the data of a tag by providing:

* a `Format`: the response format, either `LaTeX` or `HTML`
* a `ProofType`: whether or not the response should include the proof of the statement in the tag

This goes in a `ReqType` datatype, which represents the data of an API call. Based on this, we have the function

```haskell
fetchTagId :: RTagId -> ReqType -> IO Text
```

which performs an API call and returns the body of the response. 

# TODO

* `RTagId` is currently defined as a type synonym for `Text`. It would be beneficial to perform some validation on the tag ID before making the API call: for instance,
    * parsing the input to ensure it conforms to the [tag grammar](http://stacks.math.columbia.edu/tags)
    * looking the tag up in the official [tags file](https://github.com/stacks/stacks-project/blob/master/tags/tags)

# License

All code in this repo is licensed MIT.
