{-# LANGUAGE TemplateHaskell #-}

module RestackTag where

import           Control.Lens
import           Data.ByteString.Lazy    as BS
import           Data.Monoid
import           Data.Text.Lazy          (Text)
import qualified Data.Text.Lazy          as T
import           Data.Text.Lazy.Encoding (decodeUtf8)
import           Network.Wreq
import qualified System.FilePath.Posix   as FP

(</>) :: Text -> Text -> Text
a </> b = T.pack $ (FP.</>) (T.unpack a) (T.unpack b)

type RTagId = Text

data RTag = RTag { _uid  :: RTagId
                 , _name :: Text
                 } deriving (Show, Eq)

data Format = Latex | Html
data ProofType = IncludeProof | ExcludeProof

data ReqType = ReqType Format ProofType

defaultReqType :: ReqType
defaultReqType = ReqType Latex ExcludeProof

makeLenses ''RTag

mkTag :: RTagId -> RTag
mkTag i = RTag i ""

fetchTag :: RTag -> ReqType -> IO Text
fetchTag tag req = decodeUtf8 . (^. responseBody) <$> resp
  where
    resp = get . T.unpack $ requestUrl tag req

fetchTagId :: RTagId -> ReqType -> IO Text
fetchTagId = fetchTag . mkTag

requestUrl :: RTag -> ReqType -> Text
requestUrl tag (ReqType f p) =
  let uid' = tag ^. uid
      prefixUrl = "http://stacks.math.columbia.edu/data/tag"
  in prefixUrl </> uid' </> "content" </> proofSegment p </> formatSegment f

proofSegment :: ProofType -> Text
proofSegment IncludeProof = "full"
proofSegment ExcludeProof = "statement"

formatSegment :: Format -> Text
formatSegment Latex = "raw"
formatSegment Html  = ""
