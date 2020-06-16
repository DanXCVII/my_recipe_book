# My RecipeBible

My RecipeBible is a cookbook app developed with flutter. The app was created because the alternative apps with a similar purpose seem to either be overpriced or not visually appealing (and to get myself more familiar with flutter❤). I've only tested this app for Android so far, so I can't guarantee that it's fully working on iOS. However, if adjustments need to be made to make this app work on iOS, it shouldn't be hard. (Sadly I don't own a Mac to quickly test it out)

## About the implementation

I tried some different state management solutions during the development of the app and at the end stuck with the **Bloc Pattern** (also recommended by Google).
In this App, every screen has it's own Bloc and additional Blocs exist. The most interesting one may be the <em>RecipeManager</em> which is placed above the <em>MaterialApp</em> because recipes are shown on many different places in the app and therefore, it's easiest to implement one top Bloc of which all other screen-specific Blocs are listening when changes are made.

## What still needs to be done?

- <em>tests, tests, tests ... </em>: I know how important test-driven development is, but due to my lack of time, I had to decide, whether I want to publish the app in the near future or let it take much more time which I may not have. It's a bit sad however, due to the implementation of Bloc, must functionality shouldn't be so hard to test.

## About the App

With the My RecipeBible App, you can store your recipes digitally on your mobile phone and always have them with you. This probably raises the question:

What added value do I have compared to a conventional cookbook?

• INTELLIGENT SUGGESTIONS: When adding ingredients that are already contained in other added recipes speed up the saving of new recipes.

• SHARE: You can share recipes with friends. if you have this app, you can add it to it and if not, you can also share the recipe in text form, so you don't have to bother typing it again

• EXPORT: in case your device is lost, you can export your recipes as a file and save them wherever you want.

• PICTURES: You can easily add pictures about the preparation of a recipe

• SMART SEARCH: Thanks to the built-in search it is easy to find a specific recipe and thanks to the sorting function you can arrange the recipes according to your own taste.

Why should I choose this app and not another one with similar features?

• THEMES: Night mode? Yes of course! There are 3 different "themes" built-in. For those who like it light the day mode, for those who prefer it darker the night mode and for those who like it black to save energy the midnight mode.

• "Feeling lucky?!": If you don't know what you want to cook, you can swipe through random recipes you've entered. Just like certain dating-apps but with your beloved recipes❤

• INGREDIENT FILTER: You finally want to get rid of the leftovers from the fridge? Then the ingredient filter will be a great help!

• NO SUBSCRIPTION: There is no subscription model in this app. Of course, I still have to finance my life and therefore I have included some advertising, but preferably in a way that doesn't disturb you. You are welcome to buy the full version for little money where you pay for it once and I will gladly provide you with further updates.
