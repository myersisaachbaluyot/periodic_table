#!/usr/bin/env bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no argument provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Search element by atomic number, symbol, or name
ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
FROM elements 
INNER JOIN properties USING(atomic_number) 
INNER JOIN types USING(type_id) 
WHERE atomic_number::text='$1' OR symbol='$1' OR name='$1';")

# If no result found
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Parse and display result
echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done

