module App.Model exposing (..)

import App.PageType exposing (..)
import Http
import JsonApi
import RemoteData exposing (WebData)
import Dict exposing (Dict)


type Msg
    = SetActivePage Page
      -- # Homepage
    | PromotedRecipesLoaded (WebData (List JsonApi.Resource))
    | PromotedArticlesLoaded (WebData (List JsonApi.Resource))
      -- # Recipes page
    | GetRecipe String
    | RecipeLoaded (WebData JsonApi.Resource)
      -- # Recipes per category
    | GetRecipesPerCategories
    | RecipesPerCategoryLoaded String (WebData (List JsonApi.Resource))
      -- # Features / Articles page
    | GetArticles
    | ArticlesLoaded (WebData (List JsonApi.Resource))
      -- Contact
    | ContactM ContactMsg
    | PostContactForm


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
    = ArticleRef Article
    | RecipeRef Recipe


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


type alias Flags =
    { baseUrl : String
    , apiBaseUrl : String
    }


type alias Model =
    { currentPage : Page
    , flags : Flags
    , pages :
        { home :
            { promotedArticles : WebData (List Article)
            , promotedRecipes : WebData (List Recipe)
            }
        , articles : WebData (List Article)
        , recipes : Dict String (WebData (List Recipe))
        , recipe : WebData Recipe
        , contact : ContactForm
        }
    }


type ContactMsg
    = SetName String
    | SetEmail String
    | SetTelephone String
    | SetSubject String
    | SetMessage String
    | SubmitForm

type alias ContactForm =
    { name : String
    , email : String
    , telephone : String
    , subject : String
    , message : String
    }
