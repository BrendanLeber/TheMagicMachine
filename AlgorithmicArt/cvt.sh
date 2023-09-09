#!/bin/bash

avconv -framerate 24 -f image2 -i art-%06d.png -codec:v h264 -b 2560k -g 12 -bf 2 algorithmic_art.mp4
