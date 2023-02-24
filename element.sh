#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if argument empty
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else
  # if argument is number
  if [[ $1 =~ ^[1-9]+$ ]]
  then
    # get query
    QUERY_ELEMENT_RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  
  # if argumen is character
  else
    #get query
    QUERY_ELEMENT_RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
  fi

  # if query empty
  if [[ -z $QUERY_ELEMENT_RESULT ]]
  then
    # exit
    echo "I could not find that element in the database."
  
  # if query found
  else
    # read query
    echo $QUERY_ELEMENT_RESULT | while IFS=" | " read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE
  do
    # print the element info
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
  fi
fi
