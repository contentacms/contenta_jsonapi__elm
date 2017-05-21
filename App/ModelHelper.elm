module App.ModelHelper exposing (findFileByUuid)

import App.Model exposing (..)
import List.Extra


findFileByUuid : String -> List File -> Just File
findFileByUuid uuid =
    List.Extra.find (\file -> file.uuid == uuid)
