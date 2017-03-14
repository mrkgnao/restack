import           Control.Monad          (void)
import           Text.Megaparsec
import           Text.Megaparsec.Expr
import qualified Text.Megaparsec.Lexer  as L
import           Text.Megaparsec.String

import           Control.Applicative

import           Data.Text.Lazy         (Text)
import qualified Data.Text.Lazy         as T

import           Control.Lens

data TagId
  = LegacyId Text
  | NewId Text
  deriving (Show,Eq)

data Tag =
  Tag {_uid :: TagId, _name :: Text}

sc :: Parser ()
sc = L.space (void spaceChar) lineCmnt empty
  where lineCmnt  = L.skipLineComment "//"

symbol :: String -> Parser String
symbol = L.symbol sc

hyphen :: Parser String
hyphen = symbol "-"

word :: Parser String
word = some letterChar

tagName :: Parser [String]
tagName = word `sepBy1` hyphen

tagId :: Parser String
tagId = count 4 alphaNumChar

-- tag :: Parser TagId
-- tag = do
--   t <- count 4 alphaNumChar
--   if t < ""

mkTagId :: String -> Maybe TagId
mkTagId str
  | 'O' `elem` str =
    if str > "04DO"
      then Nothing
      else Just $ LegacyId (T.pack str)
  | otherwise = Just $ NewId (T.pack str)
