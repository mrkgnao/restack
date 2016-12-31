module Main where

import qualified Data.Text.Lazy    as T
import qualified Data.Text.Lazy.IO as T
import           RestackTag

main :: IO ()
main = do
  putStr "Enter tag id: "
  uid <- getLine
  putStr "Choose format ([l]atex / [h]tml): "
  fmt <- getLine
  putStr "Include proof? (y/n): "
  proof <- getLine

  tdata <- fetchTagId (T.pack uid) (ReqType (toFormatType fmt) (toProofType proof))
  T.putStrLn tdata

toProofType "y" = IncludeProof
toProofType "n" = ExcludeProof

toFormatType "l" = Latex
toFormatType "h" = Html
