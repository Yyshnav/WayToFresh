from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import (
    Address, Category, Product, ProductImage, Banner,
    Coupon, Order, OrderItem, Cart, CartItem,
    Notification, Review, Complaint, GoldMembership, SearchHistory,
    DeliveryStaff
)

User = get_user_model()


# ─────────────────────────────────────────────
#  AUTH
# ─────────────────────────────────────────────
class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'phone_number', 'password', 'confirm_password']

    def validate(self, data):
        if data['password'] != data.pop('confirm_password'):
            raise serializers.ValidationError("Passwords do not match.")
        return data

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user


class UserSerializer(serializers.ModelSerializer):
    profile_picture_url = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'phone_number', 'first_name',
                  'last_name', 'profile_picture', 'profile_picture_url',
                  'is_verified', 'created_at']
        read_only_fields = ['id', 'is_verified', 'created_at']

    def get_profile_picture_url(self, obj):
        request = self.context.get('request')
        if obj.profile_picture and request:
            return request.build_absolute_uri(obj.profile_picture.url)
        return None


class OTPRequestSerializer(serializers.Serializer):
    phone_number = serializers.CharField(max_length=15)


class OTPVerifySerializer(serializers.Serializer):
    phone_number = serializers.CharField(max_length=15)
    otp = serializers.CharField(max_length=6)


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField()
    new_password = serializers.CharField(min_length=6)


# ─────────────────────────────────────────────
#  ADDRESS
# ─────────────────────────────────────────────
class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = ['id', 'label', 'full_address', 'flat_house', 'area',
                  'city', 'state', 'pincode', 'latitude', 'longitude',
                  'is_default', 'created_at']
        read_only_fields = ['id', 'created_at']

    def create(self, validated_data):
        user = self.context['request'].user
        return Address.objects.create(user=user, **validated_data)


# ─────────────────────────────────────────────
#  CATEGORY
# ─────────────────────────────────────────────
class CategorySerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    product_count = serializers.SerializerMethodField()

    class Meta:
        model = Category
        fields = ['id', 'name', 'slug', 'image', 'image_url', 'description',
                  'is_active', 'sort_order', 'product_count']

    def get_image_url(self, obj):
        request = self.context.get('request')
        if obj.image and request:
            return request.build_absolute_uri(obj.image.url)
        return None

    def get_product_count(self, obj):
        return obj.products.filter(is_active=True).count()


# ─────────────────────────────────────────────
#  PRODUCT
# ─────────────────────────────────────────────
class ProductImageSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = ProductImage
        fields = ['id', 'image', 'image_url', 'caption', 'is_primary', 'sort_order']

    def get_image_url(self, obj):
        request = self.context.get('request')
        if obj.image and request:
            return request.build_absolute_uri(obj.image.url)
        return None


class ProductListSerializer(serializers.ModelSerializer):
    """Lightweight serializer for list views."""
    category_name = serializers.CharField(source='category.name', read_only=True)
    images = ProductImageSerializer(many=True, read_only=True)
    primary_image = serializers.SerializerMethodField()
    discount_percentage = serializers.IntegerField(read_only=True)

    class Meta:
        model = Product
        fields = [
            'id', 'name', 'slug', 'description', 'price', 'original_price', 'weight',
            'delivery_time', 'shelf_life', 'manufacturer_name', 'energy', 'size',
            'is_veg', 'in_stock', 'rating', 'review_count',
            'category', 'category_name', 'primary_image', 'images', 'discount_percentage',
            'is_trending', 'is_daily_essential', 'is_gold_promotion', 'meat_type',
        ]

    def get_primary_image(self, obj):
        request = self.context.get('request')
        img = obj.images.filter(is_primary=True).first() or obj.images.first()
        if img and request:
            return request.build_absolute_uri(img.image.url)
        return None


class ProductDetailSerializer(serializers.ModelSerializer):
    """Full serializer for detail view."""
    category = CategorySerializer(read_only=True)
    images = ProductImageSerializer(many=True, read_only=True)
    discount_percentage = serializers.IntegerField(read_only=True)
    reviews = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = [
            'id', 'name', 'slug', 'description', 'price', 'original_price',
            'weight', 'delivery_time', 'shelf_life', 'manufacturer_name',
            'energy', 'size', 'is_veg', 'in_stock', 'stock_quantity',
            'rating', 'review_count', 'category', 'images',
            'discount_percentage', 'meat_type', 'is_gold_promotion',
            'is_trending', 'is_daily_essential', 'created_at',
            'reviews',
        ]

    def get_reviews(self, obj):
        qs = obj.reviews.all()[:5]
        return ReviewSerializer(qs, many=True, context=self.context).data


# ─────────────────────────────────────────────
#  BANNER
# ─────────────────────────────────────────────
class BannerSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = Banner
        fields = ['id', 'title', 'subtitle', 'image', 'image_url',
                  'banner_type', 'link_url', 'sort_order']

    def get_image_url(self, obj):
        request = self.context.get('request')
        if obj.image and request:
            return request.build_absolute_uri(obj.image.url)
        return None


# ─────────────────────────────────────────────
#  COUPON
# ─────────────────────────────────────────────
class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coupon
        fields = [
            'id', 'code', 'title', 'description', 'discount_value',
            'is_percentage', 'min_order_value', 'max_discount',
            'valid_from', 'valid_until',
        ]


class ApplyCouponSerializer(serializers.Serializer):
    code = serializers.CharField(max_length=30)
    order_value = serializers.DecimalField(max_digits=10, decimal_places=2)


# ─────────────────────────────────────────────
#  CART
# ─────────────────────────────────────────────
class CartItemSerializer(serializers.ModelSerializer):
    product = ProductListSerializer(read_only=True)
    product_id = serializers.PrimaryKeyRelatedField(
        queryset=Product.objects.filter(is_active=True), source='product', write_only=True
    )
    subtotal = serializers.FloatField(read_only=True)

    class Meta:
        model = CartItem
        fields = ['id', 'product', 'product_id', 'quantity', 'subtotal', 'added_at']
        read_only_fields = ['id', 'added_at', 'subtotal']


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(source='cart_items', many=True, read_only=True)
    total = serializers.FloatField(read_only=True)
    total_items = serializers.IntegerField(read_only=True)

    class Meta:
        model = Cart
        fields = ['id', 'items', 'total', 'total_items', 'updated_at']


# ─────────────────────────────────────────────
#  ORDER
# ─────────────────────────────────────────────
class OrderItemSerializer(serializers.ModelSerializer):
    subtotal = serializers.FloatField(read_only=True)

    class Meta:
        model = OrderItem
        fields = [
            'id', 'product', 'product_name', 'product_image',
            'product_weight', 'unit_price', 'quantity', 'subtotal',
        ]


class DeliveryStaffSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source='user.get_full_name', read_only=True)
    phone = serializers.CharField(source='user.phone_number', read_only=True)

    class Meta:
        model = DeliveryStaff
        fields = ['id', 'name', 'phone', 'vehicle_number', 'current_status', 'latitude', 'longitude']


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    address = AddressSerializer(read_only=True)
    coupon_code = serializers.CharField(source='coupon.code', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    rider = DeliveryStaffSerializer(read_only=True)

    class Meta:
        model = Order
        fields = [
            'id', 'status', 'status_display', 'payment_method', 'items',
            'address', 'coupon_code', 'items_total', 'delivery_charge',
            'coupon_discount', 'grand_total', 'delivery_instructions',
            'estimated_delivery_time', 'rider', 'created_at', 'updated_at',
        ]
        read_only_fields = ['id', 'created_at', 'updated_at', 'grand_total']


class CreateOrderSerializer(serializers.Serializer):
    address_id = serializers.IntegerField(required=False, allow_null=True)
    payment_method = serializers.ChoiceField(choices=['cod', 'online', 'upi', 'card', 'wallet'])
    coupon_code = serializers.CharField(required=False, allow_blank=True)
    delivery_instructions = serializers.CharField(required=False, allow_blank=True)


class UpdateOrderStatusSerializer(serializers.Serializer):
    status = serializers.ChoiceField(choices=[c[0] for c in Order.STATUS_CHOICES])
    rider_id = serializers.IntegerField(required=False)


# ─────────────────────────────────────────────
#  NOTIFICATION
# ─────────────────────────────────────────────
class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['id', 'notification_type', 'title', 'body', 'is_read', 'created_at', 'order']


# ─────────────────────────────────────────────
#  REVIEW
# ─────────────────────────────────────────────
class ReviewSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Review
        fields = ['id', 'product', 'user_name', 'username', 'rating', 'comment', 'created_at']
        read_only_fields = ['id', 'created_at']

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


# ─────────────────────────────────────────────
#  COMPLAINT
# ─────────────────────────────────────────────
class ComplaintSerializer(serializers.ModelSerializer):
    class Meta:
        model = Complaint
        fields = ['id', 'order', 'subject', 'description', 'status', 'admin_reply', 'created_at', 'updated_at']
        read_only_fields = ['id', 'status', 'admin_reply', 'created_at', 'updated_at']

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


# ─────────────────────────────────────────────
#  GOLD MEMBERSHIP
# ─────────────────────────────────────────────
class GoldMembershipSerializer(serializers.ModelSerializer):
    class Meta:
        model = GoldMembership
        fields = ['id', 'plan', 'is_active', 'started_at', 'expires_at']
        read_only_fields = ['id', 'started_at']


# ─────────────────────────────────────────────
#  SEARCH
# ─────────────────────────────────────────────
class SearchHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = SearchHistory
        fields = ['id', 'query', 'created_at']
        read_only_fields = ['id', 'created_at']


# ─────────────────────────────────────────────
#  HOME (aggregated screen data)
# ─────────────────────────────────────────────
class HomeDataSerializer(serializers.Serializer):
    banners = BannerSerializer(many=True)
    categories = CategorySerializer(many=True)
    daily_essentials = ProductListSerializer(many=True)
    trending_products = ProductListSerializer(many=True)
    gold_promotions = ProductListSerializer(many=True)
