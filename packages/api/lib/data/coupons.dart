final couponsDb = {
  "PORCENTAJE": {
    "id": 1,
    "code": "PORCENTAJE",
    "description": "10% de descuento en el total de tu compra",
    "type": "DISCOUNT_PERCENTAGE",
    "payload": {
      "value": 10,
      "minimum": 1000,
    },
  },
  "FIJO": {
    "id": 2,
    "code": "FIJO",
    "description": "100 de descuento en el total de tu compra",
    "type": "DISCOUNT_FIXED",
    "payload": {
      "value": 10,
      "minimum": 700,
    },
  },
};
