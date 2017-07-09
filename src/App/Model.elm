module App.Model exposing (..)

import App.PageType exposing (..)
import JsonApi
import RemoteData exposing (WebData)
import Material
import DictList exposing (DictList)


type Msg
    = SetActivePage Page
      -- # Homepage
    | PromotedRecipesLoaded (WebData (List JsonApi.Resource))
    | PromotedArticlesLoaded (WebData (List JsonApi.Resource))
    | HomepageRecipesLoaded (WebData (List JsonApi.Resource))
      -- # Recipes page
    | RecipeLoaded (WebData JsonApi.Resource)
    | RecipeRecipesLoaded (WebData (List JsonApi.Resource))
      -- # Recipes per category
    | GetRecipesPerCategories
    | RecipesPerCategoryLoaded String (WebData (List JsonApi.Resource))
      -- # Features / Articles page
    | GetArticles
    | ArticlesLoaded (WebData (List JsonApi.Resource))
      -- # Recipes per tag
    | RecipesPerTagLoaded String (WebData (List JsonApi.Resource))
      -- # Recipes per difficulty
    | RecipesPerDifficultyLoaded String (WebData (List JsonApi.Resource))
      -- # Recipes shorter than a certain time
    | RecipesShorterThanLoaded Int (WebData (List JsonApi.Resource))
      -- Contact
    | ContactM ContactMsg
    | ContactPostResult
    | PostContactForm
      -- MDL
    | Mdl (Material.Msg Msg)
    | ClickDrawerLink Page


type alias Recipe =
    { id : String
    , title : String
    , difficulty : String
    , ingredients : List String
    , totalTime : Int
    , prepTime : Int
    , recipeInstruction : String
    , image : Maybe String
    , category : Maybe Term
    , tags : List Term
    , owner : Maybe Owner
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


type alias Owner =
    { id : Int
    , name : String
    }


type alias File =
    { url : String
    }


type alias Media =
    { uuid : String
    }


type alias Flags =
    { baseUrl : String
    , apiBaseUrl : String
    }


type alias Model =
    { flags : Flags
    , currentPage : Page
    , pageHome : PageHomeModel
    , pageAboutUs : PageAboutUsModel
    , pageRecipes : PageRecipesModel
    , pageArticles : PageArticlesModel
    , pageRecipeDetail : PageRecipeDetailModel
    , pageRecipesPerTag : PageRecipesPerTagModel
    , pageRecipesPerCategory : PageRecipesPerCategoryModel
    , pageRecipesPerDifficulty : PageRecipesPerDifficultyModel
    , pageRecipesShorterThan : PageRecipesShorterThanModel
    , pageContact : ContactForm
    , mdl : Material.Model
    }


type alias PageHomeModel =
    { promotedArticles : WebData (List Article)
    , promotedRecipes : WebData (List Recipe)
    , recipes : WebData (List Recipe)
    }


type alias PageAboutUsModel =
    {}


type alias CategoryName =
    String


type alias PageRecipesModel =
    DictList CategoryName (WebData (List Recipe))


type alias PageArticlesModel =
    WebData (List Article)


type alias PageRecipesPerTagModel =
    ( String, WebData (List Recipe) )


type alias PageRecipesPerCategoryModel =
    ( String, WebData (List Recipe) )


type alias PageRecipesPerDifficultyModel =
    ( String, WebData (List Recipe) )


type alias PageRecipesShorterThanModel =
    ( Int, WebData (List Recipe) )


type alias PageRecipeDetailModel =
    { recipe : WebData Recipe
    , recipes : WebData (List Recipe)
    }


type Difficulty
    = Easy
    | Medium
    | Hard


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
