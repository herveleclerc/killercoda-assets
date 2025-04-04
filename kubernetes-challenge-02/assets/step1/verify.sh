#!/bin/bash

  
function verify_step() {


  content="KUBE{3sc4p3d_Th3_S4ndb0x_Successfully}"

  if [ -f "/tmp/flag.txt" ]; then
    flag=$(cat < "/tmp/flag.txt")
  else 
    return 2
  fi
  
  if [[ "$content" == "$flag" ]]
  then
    echo "Verification passed"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
