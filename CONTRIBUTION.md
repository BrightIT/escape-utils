# How to develop this package

I always forget how to start development on this package, as the issues are reported very seldom.
Here is how I did this today:

  git clone ...
  cd escape-utils
  apm develop # this will link the escape-utils to atom in development version
  atom -d . # start atom in development mode

  # Then run test using atom cmd-shift-p spec
  # or with
  apm test

To publish

  apm publish patch
