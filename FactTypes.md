#Structures of currently known facts


The idea here is to have all the fact types documented in an accessible place, to make rule-writing easier.

To that end...




# Known Fact Types #

## Base facts ##

Base facts are those that are added to the working memory only at start up.  No facts of these types should be created by any subsequent rule firing.

### movie ###

`(movie =mname =year  =rating (Action *) (Adventure *) (Animation *) (Biography *) (Comedy *) (Crime *) (Drama *) (Family *) (Fantasy *) (Film-Noir *) (History *) (Horror *) (Musical *) (Mystery *) (Romance *) (Sci-Fi *) (Sport *) (Thriller *) (War *) (Western *))`

The three captures in this demonstration model will capture the name, year, and IMDB user rating of this film.  All of the **entries can be changed to captures, or to 0 or 1 for explicit matching.**

### director ###


`(director =directorname =moviename)`

Indicates that the movie was directed at least in part by this person.  Note that not all movies have a listed director.

### actor ###

` (actor  =actorname =moviename =role =billing)`

The last two fields are optional, and missing on many actors.  Probably should always be specified as `* *`, but they're there if you want them.  Note that unless we do something to fix it, the "billing" field is a string that contains a number, not a number.

### user-likes ###

I think this is a base fact, since it's part of what we're reasoning from, not something that we infer.  I don't have a structure for it, though.

### movie-era ###

`(movie-era name begindate enddate)`

## Derived facts ##

### user-likes-genre ###

Has a genre and a weight.

### user-likes-director ###

Director name and weight.

### user-likes-director ###

### user-likes-era ###

Maybe?  Might require tweak to the match engine.  No, it doesn't, just some new start-up facts.

### recommend-movie ###

Movie name and strength of recommendation?

# Known unknowns #

Clearly, we need to expand at least the second part of the list above.  Ideas mentioned so far include:

  * user-likes-frodo
  * user-likes-genre
  * user-likes-director
  * recommendation