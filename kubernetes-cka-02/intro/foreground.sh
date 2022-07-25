#!/bin/bash

echo waiting for init-background-script to finish
while [ ! -f /tmp/background0 ]; do sleep 1; done
echo Bonjour et Bienvuenue sur ce Challenge CKA 002 !