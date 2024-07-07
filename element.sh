#!/bin/bash

export PGPASSWORD='System!23'
PSQL="psql -X --username=postgres --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    else
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1'")
    fi

    if [[ -z $ATOMIC_NUMBER ]]
    then
        echo "I could not find that element in the database."
    else
        ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
        echo "$ELEMENT_INFO" | while read ATOMIC_NUM BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELT_POINT BAR BOIL_POINT
        do
            echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
        done
    fi
fi
