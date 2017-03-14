module Main where

import           Data.Maybe              (fromMaybe)
import qualified Data.Text.Lazy          as T
import qualified Data.Text.Lazy.IO       as T
import           RestackTag
import qualified System.Console.Readline as R (readline)

readText :: String -> IO (Maybe T.Text)
readText msg = fmap T.pack <$> R.readline msg

main :: IO ()
main = do
  putStrLn "Restack!"
  uid <- readText "Enter tag ID: "
  fmt <- readText "Choose format ([l]atex / [h]tml): "
  proof <- readText "Include proof? (y/n): "

  tdata <- fromMaybe (error "failed") $ do
    -- We are in Maybe here! :)
    fmt'   <- toFormatType <$> fmt
    proof' <- toProofType  <$> proof
    let req = ReqType fmt' proof'
    fetchTagId <$> uid
               <*> pure req
  T.putStrLn tdata

toProofType "y" = IncludeProof
toProofType "n" = ExcludeProof

toFormatType "l" = Latex
toFormatType "h" = Html
