# D3-ProjectR

A simple wrapper to call d3-project functions from inside R. Those functions can be useful if you're building web graphics in R.

Most R projections use gdal or other standard libraries that accurately reflect the shape of the geoid.

D3 assumes a spherical earth, but has some fun projections under that assumption.

Currently only one function: `d3project_tibble` that adds 'x' and 'y' columns to a dataframe.

```
data_frame(lat = c(10, 20), long = c(20, 30)) %>% d3project_tibble()
```

It would also be nice to have sf functions.
