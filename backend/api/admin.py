from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.html import format_html
from django.urls import reverse
from django.db.models import Count, Sum, Avg
from django.utils import timezone
from .models import (
    User, Address, Category, Product, ProductImage, Banner,
    Coupon, Order, OrderItem, Cart, CartItem,
    Notification, Review, Complaint, GoldMembership, SearchHistory,
    DeliveryStaff
)


# ─────────────────────────────────────────────
#  INLINE ADMINS
# ─────────────────────────────────────────────
class AddressInline(admin.TabularInline):
    model = Address
    extra = 0
    fields = ('label', 'full_address', 'city', 'pincode', 'is_default')
    readonly_fields = ('created_at',)


class GoldMembershipInline(admin.TabularInline):
    model = GoldMembership
    extra = 0
    fields = ('plan', 'is_active', 'expires_at')


class ProductImageInline(admin.TabularInline):
    model = ProductImage
    extra = 5
    fields = ('image', 'image_preview', 'caption', 'is_primary', 'sort_order')
    readonly_fields = ('image_preview',)

    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" style="height:60px;border-radius:6px;" />', obj.image.url)
        return "—"
    image_preview.short_description = "Preview"


class ProductInline(admin.TabularInline):
    model = Product
    extra = 0
    fields = ('name', 'price', 'weight', 'stock_quantity', 'in_stock', 'is_active')
    show_change_link = True


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0
    readonly_fields = ('product_name', 'unit_price', 'quantity', 'subtotal_display')
    fields = ('product_name', 'unit_price', 'quantity', 'subtotal_display')

    def subtotal_display(self, obj):
        return f"₹{obj.subtotal:.2f}"
    subtotal_display.short_description = "Subtotal"


class CartItemInline(admin.TabularInline):
    model = CartItem
    extra = 0
    readonly_fields = ('subtotal_display',)

    def subtotal_display(self, obj):
        return f"₹{obj.subtotal:.2f}"
    subtotal_display.short_description = "Subtotal"


# ─────────────────────────────────────────────
#  USER ADMIN
# ─────────────────────────────────────────────
@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ('id', 'username', 'phone_number', 'email', 'is_verified',
                    'is_active', 'is_staff', 'profile_pic_preview', 'created_at')
    list_filter = ('is_verified', 'is_active', 'is_staff', 'created_at')
    search_fields = ('username', 'phone_number', 'email', 'first_name', 'last_name')
    ordering = ('-created_at',)
    inlines = [AddressInline, GoldMembershipInline]

    fieldsets = BaseUserAdmin.fieldsets + (
        ('WayToFresh Profile', {
            'fields': ('phone_number', 'profile_picture', 'is_verified', 'otp'),
        }),
    )

    def profile_pic_preview(self, obj):
        if obj.profile_picture:
            return format_html('<img src="{}" style="height:40px;width:40px;border-radius:50%;" />', obj.profile_picture.url)
        return format_html('<span style="color:#ccc;">No pic</span>')
    profile_pic_preview.short_description = "Photo"


# ─────────────────────────────────────────────
#  CATEGORY ADMIN
# ─────────────────────────────────────────────
@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'slug', 'image_preview', 'is_active',
                    'sort_order', 'product_count_display')
    list_filter = ('is_active',)
    search_fields = ('name', 'slug')
    prepopulated_fields = {'slug': ('name',)}
    list_editable = ('sort_order', 'is_active')
    ordering = ('sort_order',)
    inlines = [ProductInline]

    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" style="height:45px;border-radius:8px;" />', obj.image.url)
        return "—"
    image_preview.short_description = "Image"

    def product_count_display(self, obj):
        count = obj.products.filter(is_active=True).count()
        return format_html('<b style="color:#1a73e8;">{}</b>', count)
    product_count_display.short_description = "Products"


# ─────────────────────────────────────────────
#  PRODUCT ADMIN
# ─────────────────────────────────────────────
@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = (
        'id', 'thumbnail', 'name', 'category', 'price', 'weight',
        'is_veg_badge', 'in_stock', 'rating', 'edit_button',
    )
    list_display_links = ('id', 'name')
    list_filter = (
        'category', 'is_veg', 'in_stock', 'is_active',
        'is_trending', 'is_daily_essential', 'is_gold_promotion', 'meat_type',
    )
    search_fields = ('name', 'description', 'category__name')
    prepopulated_fields = {'slug': ('name',)}
    list_editable = ('price', 'in_stock')
    inlines = [ProductImageInline]
    ordering = ('category', 'sort_order', 'name')
    save_on_top = True

    def edit_button(self, obj):
        url = reverse('admin:api_product_change', args=[obj.pk])
        return format_html('<a class="button" href="{}" style="background:#007bff;color:white;padding:4px 12px;border-radius:4px;text-decoration:none;">EDIT</a>', url)
    edit_button.short_description = "Action"

    fieldsets = (
        ('Basic Info', {
            'fields': ('name', 'slug', 'category', 'description', 'meat_type'),
        }),
        ('Pricing & Stock', {
            'fields': ('price', 'original_price', 'weight', 'stock_quantity', 'in_stock'),
        }),
        ('Details', {
            'fields': ('delivery_time', 'shelf_life', 'manufacturer_name', 'energy', 'size', 'is_veg'),
        }),
        ('Promotion Flags', {
            'fields': ('is_active', 'is_trending', 'is_daily_essential', 'is_gold_promotion', 'sort_order'),
        }),
    )

    def thumbnail(self, obj):
        img = obj.images.filter(is_primary=True).first() or obj.images.first()
        if img:
            return format_html('<img src="{}" style="height:45px;border-radius:6px;" />', img.image.url)
        return "—"
    thumbnail.short_description = "Image"

    def is_veg_badge(self, obj):
        if obj.is_veg:
            return format_html('<span style="background:#4CAF50;color:white;padding:2px 8px;border-radius:12px;font-size:11px;">VEG</span>')
        return format_html('<span style="background:#F44336;color:white;padding:2px 8px;border-radius:12px;font-size:11px;">NON-VEG</span>')
    is_veg_badge.short_description = "Type"


# ─────────────────────────────────────────────
#  BANNER ADMIN
# ─────────────────────────────────────────────
@admin.register(Banner)
class BannerAdmin(admin.ModelAdmin):
    list_display = ('id', 'banner_preview', 'title', 'banner_type', 'is_active', 'sort_order')
    list_filter = ('banner_type', 'is_active')
    list_editable = ('is_active', 'sort_order')
    ordering = ('sort_order',)

    def banner_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" style="height:40px;border-radius:6px;max-width:120px;" />', obj.image.url)
        return "—"
    banner_preview.short_description = "Preview"


# ─────────────────────────────────────────────
#  COUPON ADMIN
# ─────────────────────────────────────────────
@admin.register(Coupon)
class CouponAdmin(admin.ModelAdmin):
    list_display = (
        'id', 'code', 'title', 'discount_display', 'min_order_value',
        'used_count', 'usage_limit', 'is_active', 'valid_until',
    )
    list_filter = ('is_active', 'is_percentage')
    search_fields = ('code', 'title')
    list_editable = ('is_active',)

    def discount_display(self, obj):
        val = f"{obj.discount_value:.0f}"
        if obj.is_percentage:
            return format_html('<b style="color:#9C27B0;">{}%</b> off', val)
        return format_html('<b style="color:#9C27B0;">₹{}</b> off', val)
    discount_display.short_description = "Discount"


# ─────────────────────────────────────────────
#  ORDER ADMIN
# ─────────────────────────────────────────────
@admin.register(DeliveryStaff)
class DeliveryStaffAdmin(admin.ModelAdmin):
    list_display = ('id', 'user_name', 'vehicle_number', 'current_status', 'latitude', 'longitude')
    list_filter = ('current_status',)
    search_fields = ('user__first_name', 'user__last_name', 'user__username', 'vehicle_number')
    list_editable = ('current_status',)

    def user_name(self, obj):
        return obj.user.get_full_name() or obj.user.username
    user_name.short_description = 'Name'

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = (
        'id', 'user', 'status_badge', 'payment_method', 'item_count',
        'grand_total_display', 'rider_name', 'created_at',
    )
    list_filter = ('status', 'payment_method', 'created_at')
    search_fields = ('user__username', 'user__phone_number', 'rider__user__username', 'id')
    inlines = [OrderItemInline]
    ordering = ('-created_at',)
    readonly_fields = ('grand_total', 'created_at', 'updated_at')

    fieldsets = (
        ('Order Info', {
            'fields': ('user', 'address', 'coupon', 'status', 'payment_method'),
        }),
        ('Financials', {
            'fields': ('items_total', 'delivery_charge', 'coupon_discount', 'grand_total'),
        }),
        ('Delivery', {
            'fields': ('delivery_instructions', 'estimated_delivery_time'),
        }),
        ('Rider Tracking', {
            'fields': ('rider',),
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
        }),
    )

    STATUS_COLORS = {
        'placed': '#2196F3', 'shop_confirmed': '#9C27B0',
        'preparing': '#FF9800', 'packed': '#FF5722',
        'rider_assigned': '#795548', 'rider_picked_up': '#607D8B',
        'out_for_delivery': '#03A9F4', 'near': '#00BCD4',
        'delivered': '#4CAF50', 'cancelled': '#F44336',
    }

    def status_badge(self, obj):
        color = self.STATUS_COLORS.get(obj.status, '#9E9E9E')
        return format_html(
            '<span style="background:{};color:white;padding:3px 10px;border-radius:12px;font-size:11px;">{}</span>',
            color, obj.get_status_display()
        )
    status_badge.short_description = "Status"

    def grand_total_display(self, obj):
        return format_html('<b>₹{}</b>', obj.grand_total)
    grand_total_display.short_description = "Total"

    def item_count(self, obj):
        return obj.items.count()
    item_count.short_description = "Items"

    def rider_name(self, obj):
        if obj.rider:
            return obj.rider.user.get_full_name() or obj.rider.user.username
        return "—"
    rider_name.short_description = "Rider"


# ─────────────────────────────────────────────
#  CART ADMIN
# ─────────────────────────────────────────────
@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'total_display', 'item_count', 'updated_at')
    search_fields = ('user__username', 'user__phone_number')
    inlines = [CartItemInline]

    def total_display(self, obj):
        return f"₹{obj.total:.2f}"
    total_display.short_description = "Total"

    def item_count(self, obj):
        return obj.cart_items.count()
    item_count.short_description = "Items"


# ─────────────────────────────────────────────
#  NOTIFICATION ADMIN
# ─────────────────────────────────────────────
@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'notification_type', 'title', 'is_read', 'created_at')
    list_filter = ('notification_type', 'is_read', 'created_at')
    search_fields = ('user__username', 'title', 'body')
    list_editable = ('is_read',)
    ordering = ('-created_at',)
    actions = ['mark_as_read']

    def mark_as_read(self, request, queryset):
        queryset.update(is_read=True)
        self.message_user(request, "Selected notifications marked as read.")
    mark_as_read.short_description = "Mark selected as read"


# ─────────────────────────────────────────────
#  REVIEW ADMIN
# ─────────────────────────────────────────────
@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'product', 'stars_display', 'created_at')
    list_filter = ('rating', 'created_at')
    search_fields = ('user__username', 'product__name', 'comment')
    ordering = ('-created_at',)

    def stars_display(self, obj):
        stars = '★' * obj.rating + '☆' * (5 - obj.rating)
        color = '#FF9800' if obj.rating >= 4 else '#F44336'
        return format_html('<span style="color:{};">{}</span>', color, stars)
    stars_display.short_description = "Rating"


# ─────────────────────────────────────────────
#  COMPLAINT ADMIN
# ─────────────────────────────────────────────
@admin.register(Complaint)
class ComplaintAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'subject', 'status_badge', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('user__username', 'subject', 'description')
    list_editable = ()
    ordering = ('-created_at',)

    fieldsets = (
        ('Complaint', {'fields': ('user', 'order', 'subject', 'description')}),
        ('Resolution', {'fields': ('status', 'admin_reply')}),
    )

    STATUS_COLORS = {
        'open': '#F44336', 'in_progress': '#FF9800',
        'resolved': '#4CAF50', 'closed': '#9E9E9E',
    }

    def status_badge(self, obj):
        color = self.STATUS_COLORS.get(obj.status, '#9E9E9E')
        return format_html(
            '<span style="background:{};color:white;padding:3px 10px;border-radius:12px;font-size:11px;">{}</span>',
            color, obj.get_status_display()
        )
    status_badge.short_description = "Status"


# ─────────────────────────────────────────────
#  GOLD MEMBERSHIP ADMIN
# ─────────────────────────────────────────────
@admin.register(GoldMembership)
class GoldMembershipAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'plan', 'is_active', 'started_at', 'expires_at', 'days_left')
    list_filter = ('plan', 'is_active')
    search_fields = ('user__username', 'user__phone_number')

    def days_left(self, obj):
        if obj.is_active and obj.expires_at:
            diff = (obj.expires_at - timezone.now()).days
            if diff < 0:
                return format_html('<span style="color:#F44336;">Expired</span>')
            return format_html('<b style="color:#4CAF50;">{} days</b>', diff)
        return "—"
    days_left.short_description = "Days Left"


# ─────────────────────────────────────────────
#  SEARCH HISTORY ADMIN
# ─────────────────────────────────────────────
@admin.register(SearchHistory)
class SearchHistoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'query', 'created_at')
    search_fields = ('user__username', 'query')
    ordering = ('-created_at',)


# ─────────────────────────────────────────────
#  ADDRESS ADMIN (standalone)
# ─────────────────────────────────────────────
@admin.register(Address)
class AddressAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'label', 'city', 'pincode', 'is_default')
    list_filter = ('label', 'is_default')
    search_fields = ('user__username', 'city', 'pincode', 'full_address')
