from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinValueValidator, MaxValueValidator


# ─────────────────────────────────────────────
#  CUSTOM USER
# ─────────────────────────────────────────────
class User(AbstractUser):
    """Extended user that supports phone-based auth (OTP) as well as password."""
    phone_number = models.CharField(max_length=15, unique=True, null=True, blank=True)
    profile_picture = models.ImageField(upload_to='profiles/', null=True, blank=True)
    is_verified = models.BooleanField(default=False)
    otp = models.CharField(max_length=6, null=True, blank=True)
    otp_created_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    REQUIRED_FIELDS = ['email']

    def __str__(self):
        return self.phone_number or self.username or self.email


# ─────────────────────────────────────────────
#  ADDRESS
# ─────────────────────────────────────────────
class Address(models.Model):
    ADDRESS_TYPES = [
        ('home', 'Home'),
        ('work', 'Work'),
        ('other', 'Other'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='addresses')
    label = models.CharField(max_length=20, choices=ADDRESS_TYPES, default='home')
    full_address = models.TextField()
    flat_house = models.CharField(max_length=100, blank=True)
    area = models.CharField(max_length=200, blank=True)
    city = models.CharField(max_length=100, default='')
    state = models.CharField(max_length=100, default='')
    pincode = models.CharField(max_length=10, default='')
    latitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    longitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    is_default = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = 'Addresses'

    def __str__(self):
        return f"{self.user} — {self.label}: {self.full_address[:40]}"

    def save(self, *args, **kwargs):
        # Ensure only one default address per user
        if self.is_default:
            Address.objects.filter(user=self.user, is_default=True).update(is_default=False)
        super().save(*args, **kwargs)


# ─────────────────────────────────────────────
#  CATEGORY
# ─────────────────────────────────────────────
class Category(models.Model):
    name = models.CharField(max_length=100)
    slug = models.SlugField(unique=True)
    image = models.ImageField(upload_to='categories/', null=True, blank=True)
    description = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)
    sort_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['sort_order', 'name']
        verbose_name_plural = 'Categories'

    def __str__(self):
        return self.name


# ─────────────────────────────────────────────
#  PRODUCT
# ─────────────────────────────────────────────
class Product(models.Model):
    MEAT_TYPES = [
        ('chicken', 'Chicken'),
        ('beef', 'Beef'),
        ('lamb', 'Lamb'),
        ('pork', 'Pork'),
        ('fish', 'Fish'),
        ('seafood', 'Seafood'),
        ('turkey', 'Turkey'),
        ('none', 'Not Applicable'),
    ]

    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, related_name='products')
    name = models.CharField(max_length=255)
    slug = models.SlugField(unique=True)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    original_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # for strike-through
    weight = models.CharField(max_length=50, default='1 unit')  # "1 kg", "500 g", etc.
    delivery_time = models.CharField(max_length=30, default='16 MINS')
    shelf_life = models.CharField(max_length=50, default='5 days')
    manufacturer_name = models.CharField(max_length=100, default='WayToFresh')
    energy = models.CharField(max_length=30, default='450 KCal')
    size = models.CharField(max_length=30, default='Medium')
    is_veg = models.BooleanField(default=True)
    is_active = models.BooleanField(default=True)
    in_stock = models.BooleanField(default=True)
    stock_quantity = models.PositiveIntegerField(default=100)
    rating = models.DecimalField(max_digits=3, decimal_places=1, default=4.5,
                                  validators=[MinValueValidator(0), MaxValueValidator(5)])
    review_count = models.PositiveIntegerField(default=0)
    meat_type = models.CharField(max_length=20, choices=MEAT_TYPES, default='none')
    is_gold_promotion = models.BooleanField(default=False)  # for Gold Promotion Screen
    is_trending = models.BooleanField(default=False)
    is_daily_essential = models.BooleanField(default=False)
    sort_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['sort_order', 'name']

    def __str__(self):
        return f"{self.name} — ₹{self.price}"

    @property
    def discount_percentage(self):
        if self.original_price and self.original_price > self.price:
            return int(((self.original_price - self.price) / self.original_price) * 100)
        return 0


class ProductImage(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='products/')
    caption = models.CharField(max_length=200, blank=True)
    is_primary = models.BooleanField(default=False)
    sort_order = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['sort_order']

    def __str__(self):
        return f"{self.product.name} — image {self.sort_order}"


# ─────────────────────────────────────────────
#  BANNER (Promo Carousel)
# ─────────────────────────────────────────────
class Banner(models.Model):
    BANNER_TYPES = [
        ('home', 'Home Carousel'),
        ('gold', 'Gold Promotion'),
        ('category', 'Category Banner'),
    ]

    title = models.CharField(max_length=200, blank=True)
    subtitle = models.CharField(max_length=300, blank=True)
    image = models.ImageField(upload_to='banners/')
    banner_type = models.CharField(max_length=20, choices=BANNER_TYPES, default='home')
    link_url = models.CharField(max_length=255, blank=True)  # deep link like "/gold", "/category/2"
    is_active = models.BooleanField(default=True)
    sort_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['sort_order']

    def __str__(self):
        return f"{self.banner_type} — {self.title or self.pk}"


# ─────────────────────────────────────────────
#  COUPON
# ─────────────────────────────────────────────
class Coupon(models.Model):
    code = models.CharField(max_length=30, unique=True)
    title = models.CharField(max_length=100)
    description = models.TextField()
    discount_value = models.DecimalField(max_digits=10, decimal_places=2)
    is_percentage = models.BooleanField(default=True)  # True = %, False = flat ₹
    min_order_value = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    max_discount = models.DecimalField(max_digits=10, decimal_places=2, default=9999)
    is_active = models.BooleanField(default=True)
    valid_from = models.DateTimeField(null=True, blank=True)
    valid_until = models.DateTimeField(null=True, blank=True)
    usage_limit = models.PositiveIntegerField(null=True, blank=True)  # null = unlimited
    used_count = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.code

    def calculate_discount(self, order_value):
        if order_value < float(self.min_order_value):
            return 0
        if self.is_percentage:
            discount = (order_value * float(self.discount_value)) / 100
            return min(discount, float(self.max_discount))
        else:
            return min(float(self.discount_value), order_value)


# ─────────────────────────────────────────────
#  DELIVERY STAFF
# ─────────────────────────────────────────────
class DeliveryStaff(models.Model):
    STATUS_CHOICES = [
        ('available', 'Available'),
        ('on_delivery', 'On Delivery'),
        ('offline', 'Offline'),
    ]

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='delivery_profile')
    vehicle_number = models.CharField(max_length=50)
    current_status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='offline')
    latitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    longitude = models.DecimalField(max_digits=10, decimal_places=7, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name_plural = 'Delivery Staff'

    def __str__(self):
        return f"{self.user.get_full_name() or self.user.username} ({self.vehicle_number})"


# ─────────────────────────────────────────────
#  ORDER
# ─────────────────────────────────────────────
class Order(models.Model):
    STATUS_CHOICES = [
        ('placed', 'Order Placed'),
        ('shop_confirmed', 'Shop Confirmed'),
        ('preparing', 'Preparing'),
        ('packed', 'Packed'),
        ('rider_assigned', 'Rider Assigned'),
        ('rider_picked_up', 'Rider Picked Up'),
        ('out_for_delivery', 'Out for Delivery'),
        ('near', 'Rider Nearby'),
        ('delivered', 'Delivered'),
        ('cancelled', 'Cancelled'),
    ]

    PAYMENT_METHODS = [
        ('cod', 'Cash on Delivery'),
        ('online', 'Online Payment'),
        ('upi', 'UPI'),
        ('card', 'Card'),
        ('wallet', 'Wallet'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='orders')
    address = models.ForeignKey(Address, on_delete=models.SET_NULL, null=True)
    coupon = models.ForeignKey(Coupon, on_delete=models.SET_NULL, null=True, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='placed')
    payment_method = models.CharField(max_length=20, choices=PAYMENT_METHODS, default='cod')
    items_total = models.DecimalField(max_digits=10, decimal_places=2)
    delivery_charge = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    coupon_discount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    grand_total = models.DecimalField(max_digits=10, decimal_places=2)
    delivery_instructions = models.TextField(blank=True)
    estimated_delivery_time = models.CharField(max_length=50, blank=True)
    # Rider / tracking
    rider = models.ForeignKey('DeliveryStaff', on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_orders')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Order #{self.pk} — {self.user} — {self.status}"

    def save(self, *args, **kwargs):
        # Auto-compute grand_total
        self.grand_total = (
            float(self.items_total)
            + float(self.delivery_charge)
            - float(self.coupon_discount)
        )
        super().save(*args, **kwargs)


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.SET_NULL, null=True)
    product_name = models.CharField(max_length=255)   # snapshot at time of order
    product_image = models.CharField(max_length=500, blank=True)
    product_weight = models.CharField(max_length=50, blank=True)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.PositiveIntegerField(default=1)

    def __str__(self):
        return f"{self.product_name} x{self.quantity}"

    @property
    def subtotal(self):
        return float(self.unit_price) * self.quantity


# ─────────────────────────────────────────────
#  CART
# ─────────────────────────────────────────────
class Cart(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='cart')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Cart of {self.user}"

    @property
    def total(self):
        return sum(item.subtotal for item in self.cart_items.all())

    @property
    def total_items(self):
        return sum(item.quantity for item in self.cart_items.all())


class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name='cart_items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    added_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('cart', 'product')

    def __str__(self):
        return f"{self.product.name} x{self.quantity}"

    @property
    def subtotal(self):
        return float(self.product.price) * self.quantity


# ─────────────────────────────────────────────
#  NOTIFICATION
# ─────────────────────────────────────────────
class Notification(models.Model):
    NOTIFICATION_TYPES = [
        ('order_placed', 'Order Placed'),
        ('shop_confirmed', 'Shop Confirmed'),
        ('preparing', 'Preparing'),
        ('packed', 'Packed'),
        ('rider_assigned', 'Rider Assigned'),
        ('out_for_delivery', 'Out for Delivery'),
        ('near', 'Rider Nearby'),
        ('delivered', 'Delivered'),
        ('promo', 'Promotion'),
        ('general', 'General'),
        ('invoice', 'Invoice'),
        ('rain_delay', 'Rain Delay'),
        ('refund', 'Refund'),
        ('rating', 'Rate Order'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    order = models.ForeignKey(Order, on_delete=models.SET_NULL, null=True, blank=True, related_name='notifications')
    notification_type = models.CharField(max_length=30, choices=NOTIFICATION_TYPES, default='general')
    title = models.CharField(max_length=200)
    body = models.TextField()
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user} — {self.title}"


# ─────────────────────────────────────────────
#  REVIEW
# ─────────────────────────────────────────────
class Review(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='reviews')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reviews')
    rating = models.PositiveIntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    comment = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('product', 'user')
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user} → {self.product} ({self.rating}★)"


# ─────────────────────────────────────────────
#  COMPLAINT (Customer Support)
# ─────────────────────────────────────────────
class Complaint(models.Model):
    STATUS_CHOICES = [
        ('open', 'Open'),
        ('in_progress', 'In Progress'),
        ('resolved', 'Resolved'),
        ('closed', 'Closed'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='complaints')
    order = models.ForeignKey(Order, on_delete=models.SET_NULL, null=True, blank=True)
    subject = models.CharField(max_length=255)
    description = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='open')
    admin_reply = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"#{self.pk} — {self.subject} [{self.status}]"


# ─────────────────────────────────────────────
#  GOLD MEMBERSHIP
# ─────────────────────────────────────────────
class GoldMembership(models.Model):
    PLAN_CHOICES = [
        ('monthly', 'Monthly'),
        ('quarterly', 'Quarterly'),
        ('yearly', 'Yearly'),
    ]

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='gold_membership')
    plan = models.CharField(max_length=20, choices=PLAN_CHOICES, default='monthly')
    is_active = models.BooleanField(default=True)
    started_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()

    def __str__(self):
        return f"{self.user} — Gold {self.plan}"


# ─────────────────────────────────────────────
#  SEARCH HISTORY
# ─────────────────────────────────────────────
class SearchHistory(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='search_history')
    query = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user} searched: {self.query}"
