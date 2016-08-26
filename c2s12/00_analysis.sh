#!/bin/sh

cd ../c2s06
tree -L 1 --dirsfirst sportsball > ../c2s12/rails_structure.tree

cd ../c2s12
tree -L 2 --dirsfirst sportsball > structure.tree
