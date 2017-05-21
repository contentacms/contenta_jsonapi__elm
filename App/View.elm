module App.View exposing (view)

import App.Model exposing (..)
import App.PageType exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)
import List
import List.Extra


view : Model -> Html Msg
view model =
    div []
        [ (viewHeader model)
        , (case model.currentPage of
            Home ->
                viewHome model

            AboutUs ->
                viewAboutUs model

            RecipeList ->
                viewRecipes model

            RecipeSelectionPage ->
                viewRecipeSelectionPage model
          )
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    ul []
        [ li [] [ a [ href "#", onClick (SetActivePage Home) ] [ text "Home" ] ]
        , li [] [ a [ href "#", onClick (SetActivePage RecipeList) ] [ text "Recipes" ] ]
        , li [] [ a [ href "#", onClick (SetActivePage (RecipeSelectionPage)) ] [ text "Recipe select" ] ]
        , li [] [ a [ href "#", onClick (SetActivePage AboutUs) ] [ text "About us" ] ]
        ]


viewRecipeSelectionPage : Model -> Html Msg
viewRecipeSelectionPage model =
    Html.form []
        [ label [] [ text "Select recipe" ]
        , Maybe.withDefault
            (text "No recipe available")
            (Maybe.andThen
                (\recipes ->
                    (Just
                        (select [ onInput SelectRecipe ] <|
                            List.append
                                [ option [] [ text "Nothing" ] ]
                            <|
                                (List.map
                                    (\recipe ->
                                        option [ value recipe.title ] [ text recipe.title ]
                                    )
                                    recipes
                                )
                        )
                    )
                )
                model.recipes
            )
        , model.selectedRecipe
            |> Maybe.andThen
                (\recipeTitle ->
                    Maybe.andThen
                        (\recipes ->
                            List.Extra.find (\recipe -> recipe.title == recipeTitle) recipes
                                |> Maybe.map viewRecipe
                        )
                        model.recipes
                )
            |> Maybe.withDefault (p [] [ text "Nothing selected yet" ])
        ]


viewHome : Model -> Html Msg
viewHome model =
    text "Home page"


viewAboutUs : Model -> Html Msg
viewAboutUs model =
    text "About us ... not implemented yet"


viewRecipes : Model -> Html Msg
viewRecipes model =
    case model.recipes of
        Nothing ->
            text "No content loaded yet"

        Just recipes ->
            ul []
                (List.map
                    (\recipe ->
                        (li [] [ viewRecipe recipe ])
                    )
                    recipes
                )


viewRecipe : Recipe -> Html Msg
viewRecipe recipe =
    div []
        [ h3 [] [ text "Title" ]
        , p [] [ text (toString recipe.title) ]
        , h3 [] [ text "Image" ]
        , Maybe.map (\url -> (img [ src url ] [])) recipe.image
            |> Maybe.withDefault (p [] [ text "No image" ])
        , h3 [] [ text "Difficulty" ]
        , p [] [ text (toString recipe.difficulty) ]
        , h3 [] [ text "Ingredients" ]
        , ul [] (List.map (\inc -> li [] [ text inc ]) recipe.ingredients)
        , h3 [] [ text "Preparation time" ]
        , p [] [ text (toString recipe.prepTime) ]
        , h3 [] [ text "Total time" ]
        , p [] [ text (toString recipe.totalTime) ]
        , h3 [] [ text "Instruction" ]
        , p [] [ text (toString recipe.recipeInstruction) ]
        ]
