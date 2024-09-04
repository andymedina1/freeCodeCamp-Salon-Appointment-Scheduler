#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?"

# Servicios disponibles
SERVICES_LIST="\n1) cut\n2) color\n3) perm\n4) style\n5) trim"

echo -e "$SERVICES_LIST"
read SERVICE_ID_SELECTED

# Validación de servicio
while [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]; do
  echo -e "\nI could not find that service. What would you like today?"
  echo -e "$SERVICES_LIST"
  read SERVICE_ID_SELECTED
done

# Solicito número de teléfono
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

# Verifico si el cliente ya existe
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")



# Si no existe, solicito nombre y guardo
if [[ -z $CUSTOMER_NAME ]]; then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi

# Formateo
CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')

# Obtener el ID cliente
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

# Obtener nombre servicio
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
SERVICE_NAME=$(echo $SERVICE_NAME | sed -E 's/^ *| *$//g')

# Solicito hora de la cita
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

# Guardo en base de datos
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', $SERVICE_ID_SELECTED, $CUSTOMER_ID)")

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
