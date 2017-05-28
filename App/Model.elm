module App.Model exposing (..)

import App.PageType exposing (..)
import Http
import JsonApi
import RemoteData exposing (WebData)


type Msg
    = SetActivePage Page
      -- # Login
    | LoginFormState Bool
    | InputLoginName String
    | InputLoginPassword String
    | InputLoginSubmit
      -- | LoginCompleted
      -- # Homepage
    | PromotedRecipesLoaded (WebData (List JsonApi.Resource))
    | PromotedArticlesLoaded (WebData (List JsonApi.Resource))
      -- # Recipes page
    | GetRecipe String
    | RecipeLoaded (WebData JsonApi.Resource)
    | GetRecipes
    | RecipesLoaded (WebData (List JsonApi.Resource))
      -- # Features / Articles page
    | GetArticles
    | ArticlesLoaded (WebData (List JsonApi.Resource))
      -- # Select recipe page.
    | SelectRecipe String


type alias Recipe =
    { id : String
    , title : String
    , difficulty : String
    , ingredients : List String
    , totalTime : Int
    , prepTime : Int
    , recipeInstruction : String
    , image : Maybe String
    , tags : List Term
    }


type ArticleOrRecipe
    = ArticleId String
    | RecipeId String


type alias Article =
    { id : String
    , title : String
    , body : String
    , image : Maybe String
    }


type alias Term =
    { id : Int
    , name : String
    }


type alias File =
    { uuid : String
    , url : String
    }


type alias Media =
    { uuid : String
    }


type alias LoginDetails =
    { name : String
    , password : String
    }


type alias Flags =
    { baseUrl : String
    , apiBaseUrl : String
    }


type alias Model =
    { recipes : WebData (List Recipe)
    , selectedRecipe : Maybe String
    , currentPage : Page
    , loginFormActive : Bool
    , loginDetails : Maybe LoginDetails
    , flags : Flags
    , pages :
        { home :
            { promotedArticles : WebData (List Article)
            , promotedRecipes : WebData (List Recipe)
            }
        , articles :
            { articles : WebData (List Article)
            }
        }
    }
