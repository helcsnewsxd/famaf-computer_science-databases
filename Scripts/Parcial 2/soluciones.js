/**
 * SEGUNDO PARCIAL DE BASE DE DATOS - LABORATORIO
 * ALUMNO: Emanuel Nicolás Herrador
 * DNI: 44.898.601
 * FECHA: 17/11/2023
 */

use('supplies');

/**
 * ======================================== EJERCICIO 1 ========================================
 * 
 *    Buscar las ventas realizadas en "London", "Austin" o "San Diego"; a un customer con
 *    edad mayor-igual a 18 años que tengan productos que hayan salido al menos 1000
 *    y estén etiquetados (tags) como de tipo "school" o "kids" (pueden tener más
 *    etiquetas).
 * 
 *    Mostrar el id de la venta con el nombre "sale", la fecha (“saleDate"), el storeLocation,
 *    y el "email del cliente. No mostrar resultados anidados.
 * 
 * =============================================================================================
 */

/**
 * Respecto a este ejercicio, se toma como consideración que AMBAS CONDICIONES para los items
 * deben ser correctas para AL MENOS UN item del customer.
 * Además, se considera que la condición de que el producto haya salido al menos 1000, hace
 * referencia al precio del producto independientemente de la cantidad que lleve.
 */

db.sales.find(
  {
    // Filtros
    storeLocation: {
      // Condición: ventas realizadas en "London", "Austin" o "San Diego"
      $in: ['London', 'Austin', 'San Diego']
    },
    'customer.age': {
      // Condición: customer con edad mayor-igual a 18 años 
      $gte: 18
    },
    items: {
      // Condición: que tengan productos que hayan salido al menos 1000 y estén
      // etiquetados (tags) como de tipo "school" o "kids" (pueden tener más etiquetas).
      $elemMatch: {
        price: {
          $type: 'number',
          $gte: 1000
        },
        $or: [
          {
            tags: 'school'
          },
          {
            tags: 'kids'
          }
        ]
      }
    }
  },
  {
    // Proyección
    _id: 0,
    sale: '$_id',
    saleDate: 1,
    storeLocation: 1,
    customer_email: '$customer.email',
    age: '$customer.age',
    items: '$items'
  }
);

/**
 * ======================================== EJERCICIO 2 ========================================
 * 
 *    Buscar las ventas de las tiendas localizadas en Seattle, donde el método de compra
 *    sea ‘In store’ o ‘Phone’ y se hayan realizado entre 1 de febrero de 2014 y 31 de enero
 *    de 2015 (ambas fechas inclusive). Listar el email y la satisfacción del cliente, y el
 *    monto total facturado, donde el monto de cada item se calcula como 'price *
 *    quantity'. Mostrar el resultado ordenados por satisfacción (descendente), frente a
 *    empate de satisfacción ordenar por email (alfabético).
 * 
 * =============================================================================================
 */

/**
 * Respecto a este ejercicio, se toma como consideración que la compra se hace "por carrito",
 * es decir, una compra es un solo documento sales haciendo referencia a TODOS los items que
 * estén en el array.
 * 
 * Es decir, si alguien compró 3 tijeras de $50 y 100 papeles de $1, considero que la compra
 * de esa persona es de 3 * $50 + 100 * $1 = $250
 */

db.sales.aggregate([
  {
    // Filtros
    $match: {
      // Condición: ventas de las tiendas localizadas en Seattle
      storeLocation: 'Seattle',

      // Condición: método de compra sea ‘In store’ o ‘Phone’
      purchaseMethod: {
        $in: [
          'In store',
          'Phone'
        ]
      },

      // Condición: se hayan realizado entre 1 de febrero de 2014 y 31 de enero de 2015
      // (ambas fechas inclusive)
      saleDate: {
        $gte: new Date('2014-02-01'),
        $lte: new Date('2015-01-31')
      }
    }
  },
  {
    // Separo todos los ítems para luego poder hacer agregación con cada uno de ellos
    $unwind: '$items'
  },
  {
    // Agregación para contar el monto de cada compra (suma de los montos de price * quantity
    // para cada ítem de esa sale)
    $group: {
      _id: {
        sale_id: '$_id',
        email: '$customer.email',
        satisfaction: '$customer.satisfaction'
      },
      total: {
        // Sumar los price * quantity de todos los ítems de la compra
        $sum: {
          // Calcular el price * quantity para el ítem en particular
          $multiply: [
            // Por las dudas, convertimos ambos números a double
            { $toDouble: '$items.price' },
            { $toDouble: '$items.quantity' }
          ]
        }
      }
    }
  },
  {
    // Proyección
    $project: {
      _id: 0,
      email: '$_id.email',
      satisfaction: '$_id.satisfaction',
      total: 1
    }
  },
  {
    // Ordenar por satisfacción (descendente), frente a empate de satisfacción ordenar por 
    // email (alfabético)
    $sort: {
      satisfaction: -1,
      email: 1
    }
  }
]);

/**
 * ======================================== EJERCICIO 3 ========================================
 * 
 *    Crear la vista salesInvoiced que calcula el monto mínimo, monto máximo, monto
 *    total y monto promedio facturado por año y mes. Mostrar el resultado en orden
 *    cronológico. No se debe mostrar campos anidados en el resultado.
 * 
 * =============================================================================================
 */

/**
 * Al igual que en el ejercicio 2, es importante tener en cuenta que considero que una compra
 * hace referencia a TODOS los ítems que se lleva esa persona para la sale en particular
 */

// Pipeline de agregación
salesInvoicedPipeline = [
  {
    // Separo todos los ítems para luego poder hacer agregación con cada uno de ellos
    $unwind: '$items'
  },
  {
    // Agregación para contar el monto de cada compra (suma de los montos de price * quantity
    // para cada ítem de esa sale)
    $group: {
      _id: {
        sale_id: '$_id',
        year: {
          $year: '$saleDate'
        },
        month: {
          $month: '$saleDate'
        }
      },
      total: {
        // Sumar los price * quantity de todos los ítems de la compra
        $sum: {
          // Calcular el price * quantity para el ítem en particular
          $multiply: [
            // Por las dudas, convertimos ambos números a double
            { $toDouble: '$items.price' },
            { $toDouble: '$items.quantity' }
          ]
        }
      }
    }
  },
  {
    // Agregación para agrupar por año - mes
    $group: {
      _id: {
        year: '$_id.year',
        month: '$_id.month'
      },
      min: {
        $min: '$total'
      },
      max: {
        $max: '$total'
      },
      total: {
        $sum: '$total'
      },
      average: {
        $avg: '$total'
      }
    }
  },
  {
    // Proyección
    $project: {
      _id: 0,
      year: '$_id.year',
      month: '$_id.month',
      min: 1,
      max: 1,
      total: 1,
      average: 1
    }
  },
  {
    // Ordenar por orden cronológico
    $sort: {
      year: 1,
      month: 1
    }
  }
];

// Crear la vista con el pipeline considerado antes
db.createView(
  'salesInvoiced',
  'sales',
  salesInvoicedPipeline
);

/**
 * ======================================== EJERCICIO 4 ========================================
 * 
 *    Mostrar el storeLocation, la venta promedio de ese local, el objetivo a cumplir de
 *    ventas (dentro de la colección storeObjectives) y la diferencia entre el promedio y el
 *    objetivo de todos los locales.
 * 
 * =============================================================================================
 */

/**
 * Al igual que en el ejercicio 2 y 3, es importante tener en cuenta que considero que una compra
 * hace referencia a TODOS los ítems que se lleva esa persona para la sale en particular
 * 
 * En este caso, el join se hace DESDE storeObjectives porque podríamos agregar un nuevo
 * storeObjective que no tenga sales temporalmente pero del cual queramos saber toda esta información
 */

db.storeObjectives.aggregate(
  {
    // Join con las sales correspondientes al local del lugar marcado por storeLocation
    $lookup: {
      from: 'sales',
      localField: '_id',
      foreignField: 'storeLocation',
      as: 'store_info',
      pipeline: [
        {
          // Separo todos los ítems para luego poder hacer agregación con cada uno de ellos
          $unwind: '$items'
        },
        {
          // Agregación para contar el monto de cada compra (suma de los montos de price * quantity
          // para cada ítem de esa sale)
          $group: {
            _id: {
              sale_id: '$_id',
              storeLocation: '$storeLocation'
            },
            total: {
              // Sumar los price * quantity de todos los ítems de la compra
              $sum: {
                // Calcular el price * quantity para el ítem en particular
                $multiply: [
                  // Por las dudas, convertimos ambos números a double
                  { $toDouble: '$items.price' },
                  { $toDouble: '$items.quantity' }
                ]
              }
            }
          }
        },
        {
          // Agregación para calcular el promedio de venta por tienda
          $group: {
            _id: '$storeLocation',
            average: {
              $avg: '$total'
            }
          }
        }
      ]
    }
  },
  {
    // Saco el array de información y me quedo solo con el primer elemento (porque tiene
    // uno nomás y ese es el que me interesa)
    $set: {
      store_info: {
        $first: '$store_info'
      }
    }
  },
  {
    // Proyección
    $project: {
      _id: 0,
      storeLocation: '$_id',
      average_sales: '$store_info.average',
      objective: 1,
      difference: {
        // Considero diferencia NO ABSOLUTA, sino AVG - OBJECTIVE
        $subtract: [
          { $toDouble: '$store_info.average' },
          { $toDouble: '$objective' }
        ]
      }
    }
  }
);

/**
 * ======================================== EJERCICIO 5 ========================================
 * 
 *    Especificar reglas de validación en la colección sales utilizando JSON Schema.
 *      a. Las reglas se deben aplicar sobre los campos: saleDate, storeLocation,
 *      purchaseMethod, y customer ( y todos sus campos anidados ). Inferir los
 *      tipos y otras restricciones que considere adecuados para especificar las
 *      reglas a partir de los documentos de la colección.
 * 
 *      b. Para testear las reglas de validación crear un caso de falla en la regla de
 *      validación y un caso de éxito (Indicar si es caso de falla o éxito)
 * 
 * =============================================================================================
 */

/**
 * Respecto a las validaciones elegidas, voy a colocar en este comentario algunas de las queries
 * que utilizé para chequear que sean correctas (sobre las no obvias, claro).
 * 
 * Por ello, podemos ver:
 *    1.  Para chequear los posibles valores que storeLocation tiene y ver que se puede poner de tipo enum
 *        En particular, no hace falta sino que lo tenemos en storeObjectives pero para chequear por las dudas
 *          db.sales.aggregate([
 *            {$group:{_id:'$storeLocation'}},
 *            {$project:{_id:0,storeLocation:'$_id'}} 
 *          ]);
 *    
 *    2.  Para chequear los posibles valores que purchaseMethod tiene y ver que se puede poner de tipo enum
 *          db.sales.aggregate([
 *            {$group:{_id:'$purchaseMethod'}},
 *            {$project:{_id:0,purchaseMethod:'$_id'}}
 *          ]);
 * 
 *    3.  Para chequear los posibles valores que customer.gender tiene y ver que se puede poner de tipo enum
 *          db.sales.aggregate([
 *            {$group:{_id:'$customer.gender'}},
 *            {$project:{_id:0,gender:'$_id'}}
 *          ]);
 * 
 *    4.  Para chequear valores máximos y mínimos de customer.age
 *        De igual modo considero que está en [0, 200], pero por las dudas
 *          db.sales.aggregate([
 *            {$group:{_id:'',age_min:{$min:'$customer.age'},age_max:{$max:'$customer.age'}}},
 *            {$project:{_id:0,age_min:1,age_max:1}}
 *          ]);
 * 
 *    5.  Para corroborar que NO haya emails en los documentos actuales que no cumplan con el regex de mails
 *          db.sales.find(
 *            {'customer.email':{$not:{$regex: '^(.*)@(.*)\\.(.{2,4})'}}},
 *            {_id:0,email:'$customer.email'}
 *          );
 * 
 *    6.  Para corroborar los valores que se consideran para la escala de satisfaction
 *        De acá se saca que satisfaction es una escala del 1 al 5
 *          db.sales.aggregate([
 *            {$group:{_id:'$customer.satisfaction'}},
 *            {$project:{_id:0,satisfaction:'$_id'}}
 *          ]);
 * 
 *    7.  Para corroborar que NO haya compras sin ítems o con el arreglo vacío
 *        No tiene sentido que haya uno así pero por las dudas
 *          db.sales.find(
 *            {items:{$exists:false}},
 *            {_id:0,items:1}
 *          );
 *          db.sales.find(
 *            {items:{$size:0}},
 *            {_id:0,items:1}
 *          );
 */

/**
 * Ítem A. Validaciones generadas
 */
db.runCommand({
  collMod: 'sales',
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: [
        'saleDate',
        'storeLocation',
        'purchaseMethod',
        'customer',
        'items'
      ],
      properties: {
        saleDate: {
          bsonType: 'date'
        },
        storeLocation: {
          bsonType: 'string',
          enum: [
            'London',
            'New York',
            'Denver',
            'San Diego',
            'Austin',
            'Seattle'
          ]
        },
        purchaseMethod: {
          bsonType: 'string',
          enum: [
            'Online',
            'Phone',
            'In store'
          ]
        },
        customer: {
          bsonType: 'object',
          required: [
            'gender',
            'age',
            'email',
            'satisfaction'
          ],
          properties: {
            gender: {
              bsonType: 'string',
              enum: [
                'M',
                'F'
              ]
            },
            age: {
              bsonType: 'int',
              minimum: 0,
              maximum: 200
            },
            email: {
              bsonType: 'string',
              pattern: '^(.*)@(.*)\\.(.{2,4})$'
            },
            satisfaction: {
              bsonType: 'int',
              minimum: 1,
              maximum: 5
            }
          }
        },
        items: {
          bsonType: 'array',
          minLength: 1,
          required: [
            'name',
            'price',
            'quantity'
          ],
          properties: {
            name: {
              bsonType: 'string'
            },
            tags: {
              bsonType: ['string'],
            },
            price: {
              bsonType: 'double',
              minimum: 0
            },
            quantity: {
              bsonType: 'int',
              minimum: 1
            }
          }
        },
        couponUsed: {
          bsonType: 'bool'
        }
      }
    }
  }
});

/**
 * Ítem B. Casos de insersión respecto a la validación considerada antes
 * Los casos considerados son:
 *    1.  Correcto
 *    2.  Incorrecto --> Es una venta pero no tiene ítems vendidos
 */

db.sales.insertOne({
  saleDate: new Date('2023-11-17'),
  items: [
    {
      name: "printer paper",
      tags: [
        "office",
        "stationary"
      ],
      price: 40.01,
      quantity: 2
    }
  ],
  storeLocation: 'London',
  customer: {
    gender: "M",
    age: 20,
    email: "emanuelherrador2@gmail.com",
    satisfaction: 5
  },
  couponUsed: false,
  purchaseMethod: 'Online'
});

db.sales.insertOne({
  saleDate: new Date('2023-11-17'),
  storeLocation: 'London',
  customer: {
    gender: "M",
    age: 20,
    email: "emanuelherrador2@gmail.com",
    satisfaction: 5
  },
  couponUsed: false,
  purchaseMethod: 'Online'
});
