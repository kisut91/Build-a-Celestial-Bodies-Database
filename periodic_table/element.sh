#!/bin/bash

# Define the PSQL variable for queries
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Check if the input is a number (atomic_number)
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # Query by atomic number
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    # Query by symbol or name
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  fi

  # If the query result is empty
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    # Parse the result and display the formatted output
    echo "$ELEMENT_INFO" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME MASS MELT BOIL TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi