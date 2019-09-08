// tslint:disable-next-line: no-use-before-declare
export { User, UserFields,Drink, Food, Order, Products, Product }

interface User {
  nominative: string
  fcmToken: string
}
class UserFields {
  static ID = 'users'
}

interface Drink {
  title: string
  price: number
}

interface Food {
  title: string
  price: number
}

interface Order {
  chargerToken: string

  tableId: string
  chairId: string
}

interface Products {
  drinks: {[idDrink: string]: Product[]}
  foods:  {[idDrink: string]: Product[]}
}

interface Product {
  countProducts: number
}