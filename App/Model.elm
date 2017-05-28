module App.Model exposing (..)

import App.PageType exposing (..)
import Http
import JsonApi


type Msg
    = SetActivePage Page
      -- # Login
    | LoginFormState Bool
    | InputLoginName String
    | InputLoginPassword String
    | InputLoginSubmit
      -- | LoginCompleted
      -- # Homepage
    | PromotedRecipesLoaded (Result Http.Error (List JsonApi.Resource))
    | PromotedArticlesLoaded (Result Http.Error (List JsonApi.Resource))
      -- # Recipes page
    | GetRecipe String
    | RecipeLoaded (Result Http.Error JsonApi.Resource)
    | GetRecipes
    | RecipesLoaded (Result Http.Error (List JsonApi.Resource))
      -- # Features / Articles page
    | GetArticles
    | ArticlesLoaded (Result Http.Error (List JsonApi.Resource))
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
    , apiBaseUrl: String
    }


type alias Model =
    { recipes : Maybe (List Recipe)
    , selectedRecipe : Maybe String
    , currentPage : Page
    , loginFormActive : Bool
    , loginDetails : Maybe LoginDetails
    , flags : Flags
    , pages :
        { home :
            { promotedArticles : Maybe (List Article)
            , promotedRecipes : Maybe (List Recipe)
            }
        , articles :
            { articles : Maybe (List Article)
            }
        }
    }
