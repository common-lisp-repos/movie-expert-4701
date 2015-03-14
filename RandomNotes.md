# Setting Path #

`(setf *DEFAULT-PATHNAME-DEFAULTS* (pathname "/Users/msukan/Documents/Courses/4701 AI/HW4/src/"))`

# Ideas/Possible Features #

Should our results somehow indicate, _why_ they were chosen?  For example, if we recommend "Speed Racer" and the reason was the user liked "Matrix", should we display something like "user likes director" next to "Speed Racer"?

The point is to make the results a little clearer for the TA/Pasik (if he ever looks at these things), because for all they know, we might be returning random movies.

# Other Movie Recommendation Engines #

We can check our results against these sites to see if they somehow align.  Obviously we don't know the rules they're using but its _a_ benchmark.

  * http://www.tastekid.com/
  * http://www.criticker.com/
  * http://www.jinni.com/movie-genome.html