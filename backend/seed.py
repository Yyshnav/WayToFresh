import os
import django
from decimal import Decimal
from datetime import timedelta
from django.utils import timezone

# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'waytofresh_backend.settings')
django.setup()

from api.models import Category, Product, Coupon, Banner, User

def seed_data():
    print("Seeding WayToFresh database...")

    # 1. Categories
    categories_data = [
        ("Vegetables & Fruits", "vegetables-fruits"),
        ("Chips & Namkeen", "chips-namkeen"),
        ("Bakery & Snacks", "bakery-snacks"),
        ("Dairy, Bread & Eggs", "dairy-bread-eggs"),
        ("Drinks & Juices", "drinks-juices"),
        ("Sweets & Chocolates", "sweets-chocolates"),
        ("Meat & Fish", "meat-fish"),
    ]

    categories = {}
    for name, slug in categories_data:
        cat, _ = Category.objects.get_or_create(name=name, slug=slug)
        categories[name] = cat
        print(f"  Category: {name}")

    # 2. Products
    products_data = [
        # Vegetables
        {
            "category": "Vegetables & Fruits",
            "name": "Organic Onion",
            "price": Decimal("33.00"),
            "weight": "1 kg",
            "is_veg": True,
            "description": "Fresh organic onions directly from the farm.",
            "is_daily_essential": True
        },
        {
            "category": "Vegetables & Fruits",
            "name": "Fresh Tomato",
            "price": Decimal("25.00"),
            "weight": "1 kg",
            "is_veg": True,
            "description": "Juicy red tomatoes.",
            "is_daily_essential": True
        },
        # Dairy
        {
            "category": "Dairy, Bread & Eggs",
            "name": "Farm Fresh Milk",
            "price": Decimal("32.00"),
            "weight": "500 ml",
            "is_veg": True,
            "description": "Pasteurized fresh milk.",
            "is_daily_essential": True
        },
        # Snacks
        {
            "category": "Chips & Namkeen",
            "name": "Lay's Classic",
            "price": Decimal("20.00"),
            "weight": "50 g",
            "is_veg": True,
            "description": "Classic salted potato chips.",
            "is_trending": True
        },
        # Meat & Fish
        {
            "category": "Meat & Fish",
            "name": "Premium Wagyu",
            "price": Decimal("1200.00"),
            "weight": "1 kg",
            "is_veg": False,
            "meat_type": "beef",
            "description": "Highly marbled raw Wagyu beef, tender and flavorful.",
            "is_gold_promotion": True
        },
        {
            "category": "Meat & Fish",
            "name": "Beef Tenderloin",
            "price": Decimal("850.00"),
            "weight": "500 g",
            "is_veg": False,
            "meat_type": "beef",
            "description": "Lean and tender beef cut, perfect for steaks.",
            "is_gold_promotion": True
        },
        {
            "category": "Meat & Fish",
            "name": "Beef Ribs",
            "price": Decimal("950.00"),
            "weight": "1 kg",
            "is_veg": False,
            "meat_type": "beef",
            "description": "Prime beef short ribs, perfect for slow cooking.",
            "is_gold_promotion": True
        },
        {
            "category": "Meat & Fish",
            "name": "Lamb Chops",
            "price": Decimal("750.00"),
            "weight": "500 g",
            "is_veg": False,
            "meat_type": "lamb",
            "description": "Succulent raw lamb chops.",
            "is_gold_promotion": True
        },
        {
            "category": "Meat & Fish",
            "name": "Chicken Breast Boneless",
            "price": Decimal("450.00"),
            "weight": "1 kg",
            "is_veg": False,
            "meat_type": "chicken",
            "description": "Lean and healthy chicken breast.",
            "is_gold_promotion": True
        },
        {
            "category": "Meat & Fish",
            "name": "Chicken Curry Cut",
            "price": Decimal("550.00"),
            "weight": "500 g",
            "is_veg": False,
            "meat_type": "chicken",
            "description": "Fresh chicken curry cut."
        },
        {
            "category": "Meat & Fish",
            "name": "Lamb Leg",
            "price": Decimal("1100.00"),
            "weight": "2 kg",
            "is_veg": False,
            "meat_type": "lamb",
            "description": "Juicy and tender whole lamb leg."
        }
    ]

    for p in products_data:
        cat_name = p.pop('category')
        Product.objects.get_or_create(
            name=p['name'],
            defaults={
                'category': categories[cat_name],
                'slug': p['name'].lower().replace(" ", "-").replace("'", ""),
                **p
            }
        )
        print(f"  Product: {p['name']}")

    # 3. Coupons
    coupons_data = [
        {
            "code": "TRYNEW",
            "title": "TRYNEW",
            "description": "20% off on orders above ₹699. Max discount ₹200",
            "discount_value": 20,
            "is_percentage": True,
            "min_order_value": 699,
            "max_discount": 200
        },
        {
            "code": "FREED100",
            "title": "FREED100",
            "description": "Flat ₹100 off on all orders.",
            "discount_value": 100,
            "is_percentage": False,
            "min_order_value": 0
        },
        {
            "code": "SALE50",
            "title": "SALE50",
            "description": "Big Sale - Flat 50% off on everything on orders above ₹1000. Maximum discount ₹550",
            "discount_value": 50,
            "is_percentage": True,
            "min_order_value": 1000,
            "max_discount": 550
        },
        {
            "code": "NEW50",
            "title": "NEW50",
            "description": "New customer offer - Flat 50% off on everything on orders above ₹299. Maximum discount ₹250",
            "discount_value": 50,
            "is_percentage": True,
            "min_order_value": 299,
            "max_discount": 250
        },
        {
            "code": "GIFTPROMO4",
            "title": "GIFTPROMO4",
            "description": "Save 50% off. For any product in grocery store.",
            "discount_value": 50,
            "is_percentage": True,
            "min_order_value": 0,
            "max_discount": 500
        }
    ]

    for c in coupons_data:
        Coupon.objects.get_or_create(code=c['code'], defaults=c)
        print(f"  Coupon: {c['code']}")

    # 4. Banners
    Banner.objects.get_or_create(
        title="Diwali Sale",
        banner_type="home",
        defaults={
            "subtitle": "Get up to 50% off",
            "is_active": True,
        }
    )
    print("  Banner: Diwali Sale")

    print("\nDatabase seeded successfully!")

if __name__ == "__main__":
    seed_data()
