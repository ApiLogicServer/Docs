class Product:
    def __init__(self, product_id, unit_price):
        self.product_id = product_id
        self.unit_price = unit_price


class Item:
    def __init__(self, product, quantity):
        self.product = product
        self.unit_price = product.unit_price  # Copy unit_price from Product
        self.quantity = quantity
        self.amount = self.calculate_amount()  # Calculate Item.amount

    def calculate_amount(self):
        return self.quantity * self.unit_price

    def update_quantity(self, new_quantity):
        self.quantity = new_quantity
        self.amount = self.calculate_amount()


class Order:
    def __init__(self):
        self.items = []
        self.amount_total = 0

    def add_item(self, item):
        self.items.append(item)
        self.update_amount_total()

    def update_amount_total(self):
        self.amount_total = sum(item.amount for item in self.items)

    def update_item(self, item, new_quantity):
        item.update_quantity(new_quantity)
        self.update_amount_total()

    def remove_item(self, item):
        self.items.remove(item)
        self.update_amount_total()


class Customer:
    def __init__(self, credit_limit):
        self.credit_limit = credit_limit
        self.balance = 0
        self.orders = []

    def add_order(self, order, date_shipped=None):
        self.orders.append({"order": order, "date_shipped": date_shipped})
        self.update_balance()

    def update_balance(self):
        self.balance = sum(
            order["order"].amount_total for order in self.orders if order["date_shipped"] is None
        )

    def check_credit_limit(self):
        if self.balance > self.credit_limit:
            raise ValueError("Customer balance exceeds credit limit!")
        else:
            print("Balance is within credit limit.")

    def process_order(self, order):
        self.update_balance()
        self.check_credit_limit()


# Example usage:

# Create a product
product = Product(product_id=1, unit_price=20.0)

# Create an order
order = Order()

# Insert an item
item1 = Item(product, quantity=5)  # Insert an item with quantity 5
order.add_item(item1)  # Add the item to the order

# Create a customer with a credit limit
customer = Customer(credit_limit=500)

# Add the order to the customer
customer.add_order(order)

# Process and check credit limit after insertion
customer.process_order(order)

# Update the item
order.update_item(item1, new_quantity=10)  # Update the item's quantity to 10

# Process and check credit limit after update
customer.process_order(order)

# Delete the item
order.remove_item(item1)  # Remove the item from the order

# Process and check credit limit after deletion
customer.process_order(order)