#!/bin/bash
raco pollen publish

rsync -avz --delete ~/publish/ toddobryan@dupontmanual.org:/var/www/dupontmanual.org
