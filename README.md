# voronoi-of-segments-and-points

These functions and scripts create the Voronoi graph of input points and line segments.

All the functions and scripts are called from the script 'Main'

The input is created in the script create_sites_2 

The main script produces WaveFront files of the resulting graphs.
The file 'voronoi5.obj' has the Voronoi graph of the input segments and points.
The file 'voronoi6.obj' has the medial axis graph of the input segments and points.
The file 'voronoi7.obj' has the input segments and points.
 
The scripts divide_segment_2 and conforming_triangulation have parameters that start with the letter 'Z' that can be adjusted to set the tolerance for how close Steiner points can be along the same segment.

These documents are listed as a MATLAB documents, but there may be a few commands that only work in Octave, 
especially commmands that involve the addition of mXn matrices with mX1 vectors. Octave automatically expands
mX1 vectors along the second dimension when adding to a mXn matrix, but MATLAB does not.
