module Reader where
import           Control.Monad.Catch   hiding (try)
import qualified Data.ByteString.Char8 as BS
import qualified Data.HashMap.Lazy     as HM
import qualified Data.Text             as T
import qualified Data.Yaml             as Y
import           SitePipe

decodeYaml :: MonadThrow m => String -> m Value
decodeYaml yamlBlock =
  case Y.decodeEither (BS.pack yamlBlock) of
    Left err -> throwM (YamlErr yamlBlock err)
    Right (Object metaObj) -> return (Object metaObj)
    Right Null -> return (Object HM.empty)
    Right _ -> throwM (YamlErr yamlBlock "Top level yaml must be key-value pairs")
