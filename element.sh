#!/bin/bash

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

ARGUMENT=$1;

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#If not a number
if [[ ! $1  =~ ^[0-9]+$  ]]
then
#If name
  if [[ ${#ARGUMENT} -gt 2 ]]
  then
    RESULT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
    FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types on properties.type_id = types.type_id
    WHERE elements.name ILIKE '$1';")

  #If Symbol
  else
  RESULT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
    FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types on properties.type_id = types.type_id
    WHERE elements.symbol = '$1';")
  fi
else
  RESULT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
    FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types on properties.type_id = types.type_id
    WHERE elements.atomic_number = '$1';")
fi

if [ -z "$RESULT" ]; then
    echo "I could not find that element in the database."
else
    IFS='|' read -r atomic_number symbol name atomic_mass melting_point boiling_point type <<< "$RESULT"
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
fi