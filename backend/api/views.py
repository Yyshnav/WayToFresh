import random
from datetime import timedelta

from django.contrib.auth import get_user_model
from django.utils import timezone
from rest_framework import generics, status, permissions, viewsets, filters
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAdminUser
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django_filters.rest_framework import DjangoFilterBackend

from .models import (
    Address, Category, Product, ProductImage, Banner,
    Coupon, Order, OrderItem, Cart, CartItem,
    Notification, Review, Complaint, GoldMembership, SearchHistory,
    DeliveryStaff
)
from .serializers import (
    UserRegistrationSerializer, UserSerializer,
    OTPRequestSerializer, OTPVerifySerializer, ChangePasswordSerializer,
    AddressSerializer, CategorySerializer,
    ProductListSerializer, ProductDetailSerializer, ProductImageSerializer,
    BannerSerializer, CouponSerializer, ApplyCouponSerializer,
    CartSerializer, CartItemSerializer,
    OrderSerializer, CreateOrderSerializer, UpdateOrderStatusSerializer,
    NotificationSerializer, ReviewSerializer, ComplaintSerializer,
    GoldMembershipSerializer, SearchHistorySerializer,
)

User = get_user_model()


# ─────────────────────────────────────────────
#  HELPERS
# ─────────────────────────────────────────────
def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }


# ─────────────────────────────────────────────
#  AUTH VIEWS
# ─────────────────────────────────────────────
class RegisterView(APIView):
    """POST /api/auth/register/"""
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = UserRegistrationSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            tokens = get_tokens_for_user(user)
            return Response({
                'user': UserSerializer(user).data,
                'tokens': tokens,
                'message': 'Registration successful.',
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LoginView(APIView):
    """POST /api/auth/login/  — accepts phone_number or username + password."""
    permission_classes = [AllowAny]

    def post(self, request):
        identifier = request.data.get('phone_number') or request.data.get('username')
        password = request.data.get('password')

        if not identifier or not password:
            return Response({'error': 'Credentials required.'}, status=400)

        # Try phone_number first, then username
        user = (
            User.objects.filter(phone_number=identifier).first()
            or User.objects.filter(username=identifier).first()
        )

        if user and user.check_password(password):
            tokens = get_tokens_for_user(user)
            return Response({
                'user': UserSerializer(user).data,
                'tokens': tokens,
            })
        return Response({'error': 'Invalid credentials.'}, status=status.HTTP_401_UNAUTHORIZED)


class OTPRequestView(APIView):
    """POST /api/auth/otp/request/ — send OTP to phone."""
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = OTPRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        phone = serializer.validated_data['phone_number']

        user, _ = User.objects.get_or_create(
            phone_number=phone,
            defaults={'username': phone}
        )
        otp = str(random.randint(1000, 9999))
        user.otp = otp
        user.otp_created_at = timezone.now()
        user.save()

        # In production: integrate SMS gateway here
        print(f"[OTP] {phone} → {otp}")  # Dev log

        return Response({'message': f'OTP sent to {phone}.', 'otp': otp})  # Remove otp in prod


class OTPVerifyView(APIView):
    """POST /api/auth/otp/verify/ — verify OTP and return JWT."""
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = OTPVerifySerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        phone = serializer.validated_data['phone_number']
        otp = serializer.validated_data['otp']

        user = User.objects.filter(phone_number=phone).first()
        if not user:
            return Response({'error': 'User not found.'}, status=404)

        if user.otp != otp:
            return Response({'error': 'Invalid OTP.'}, status=400)

        # OTP expiry: 10 minutes
        if user.otp_created_at and timezone.now() > user.otp_created_at + timedelta(minutes=10):
            return Response({'error': 'OTP expired.'}, status=400)

        user.is_verified = True
        user.otp = None
        user.save()

        tokens = get_tokens_for_user(user)
        return Response({
            'user': UserSerializer(user).data,
            'tokens': tokens,
            'message': 'Login successful.',
        })


class LogoutView(APIView):
    """POST /api/auth/logout/ — blacklist refresh token."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data['refresh']
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({'message': 'Logged out successfully.'})
        except Exception:
            return Response({'error': 'Invalid token.'}, status=400)


class ProfileView(generics.RetrieveUpdateAPIView):
    """GET/PATCH /api/auth/profile/"""
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return self.request.user


class ChangePasswordView(APIView):
    """POST /api/auth/change-password/"""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = request.user
        if not user.check_password(serializer.validated_data['old_password']):
            return Response({'error': 'Old password is incorrect.'}, status=400)
        user.set_password(serializer.validated_data['new_password'])
        user.save()
        return Response({'message': 'Password updated successfully.'})


# ─────────────────────────────────────────────
#  HOME DATA
# ─────────────────────────────────────────────
class HomeDataView(APIView):
    """GET /api/home/ — aggregated data for the home screen."""
    permission_classes = [AllowAny]

    def get(self, request):
        ctx = {'request': request}
        data = {
            'banners': BannerSerializer(
                Banner.objects.filter(is_active=True, banner_type='home'),
                many=True, context=ctx
            ).data,
            'categories': CategorySerializer(
                Category.objects.filter(is_active=True),
                many=True, context=ctx
            ).data,
            'daily_essentials': ProductListSerializer(
                Product.objects.filter(is_active=True, is_daily_essential=True)[:10],
                many=True, context=ctx
            ).data,
            'trending_products': ProductListSerializer(
                Product.objects.filter(is_active=True, is_trending=True)[:10],
                many=True, context=ctx
            ).data,
            'gold_promotions': ProductListSerializer(
                Product.objects.filter(is_active=True, is_gold_promotion=True)[:10],
                many=True, context=ctx
            ).data,
        }
        return Response(data)


# ─────────────────────────────────────────────
#  CATEGORY VIEWS
# ─────────────────────────────────────────────
class CategoryListView(generics.ListAPIView):
    """GET /api/categories/"""
    queryset = Category.objects.filter(is_active=True)
    serializer_class = CategorySerializer
    permission_classes = [AllowAny]


class CategoryDetailView(generics.RetrieveAPIView):
    """GET /api/categories/<id>/"""
    queryset = Category.objects.filter(is_active=True)
    serializer_class = CategorySerializer
    permission_classes = [AllowAny]


# ─────────────────────────────────────────────
#  PRODUCT VIEWS
# ─────────────────────────────────────────────
class ProductListView(generics.ListAPIView):
    """GET /api/products/?category=&is_veg=&search=&meat_type=&ordering=price"""
    serializer_class = ProductListSerializer
    permission_classes = [AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['category', 'is_veg', 'in_stock', 'meat_type',
                        'is_trending', 'is_daily_essential', 'is_gold_promotion']
    search_fields = ['name', 'description', 'category__name']
    ordering_fields = ['price', 'rating', 'name', 'created_at']

    def get_queryset(self):
        return Product.objects.filter(is_active=True).prefetch_related('images')


class ProductDetailView(generics.RetrieveAPIView):
    """GET /api/products/<id>/"""
    queryset = Product.objects.filter(is_active=True)
    serializer_class = ProductDetailSerializer
    permission_classes = [AllowAny]


# ─────────────────────────────────────────────
#  BANNER VIEWS
# ─────────────────────────────────────────────
class BannerListView(generics.ListAPIView):
    """GET /api/banners/?banner_type=home"""
    serializer_class = BannerSerializer
    permission_classes = [AllowAny]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['banner_type']

    def get_queryset(self):
        return Banner.objects.filter(is_active=True)


# ─────────────────────────────────────────────
#  ADDRESS VIEWS
# ─────────────────────────────────────────────
class AddressListCreateView(generics.ListCreateAPIView):
    """GET /api/addresses/   POST /api/addresses/"""
    serializer_class = AddressSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Address.objects.filter(user=self.request.user)


class AddressDetailView(generics.RetrieveUpdateDestroyAPIView):
    """GET/PATCH/DELETE /api/addresses/<id>/"""
    serializer_class = AddressSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Address.objects.filter(user=self.request.user)


class SetDefaultAddressView(APIView):
    """POST /api/addresses/<id>/set-default/"""
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        address = Address.objects.filter(pk=pk, user=request.user).first()
        if not address:
            return Response({'error': 'Address not found.'}, status=404)
        Address.objects.filter(user=request.user).update(is_default=False)
        address.is_default = True
        address.save()
        return Response({'message': 'Default address updated.'})


# ─────────────────────────────────────────────
#  COUPON VIEWS
# ─────────────────────────────────────────────
class CouponListView(generics.ListAPIView):
    """GET /api/coupons/"""
    serializer_class = CouponSerializer
    permission_classes = [AllowAny]

    def get_queryset(self):
        return Coupon.objects.filter(is_active=True)


class ApplyCouponView(APIView):
    """POST /api/coupons/apply/"""
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = ApplyCouponSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        code = serializer.validated_data['code'].upper()
        order_value = float(serializer.validated_data['order_value'])

        coupon = Coupon.objects.filter(code=code, is_active=True).first()
        if not coupon:
            return Response({'error': 'Invalid or expired coupon code.'}, status=400)

        # Date check
        now = timezone.now()
        if coupon.valid_from and now < coupon.valid_from:
            return Response({'error': 'Coupon is not yet valid.'}, status=400)
        if coupon.valid_until and now > coupon.valid_until:
            return Response({'error': 'Coupon has expired.'}, status=400)

        # Usage check
        if coupon.usage_limit and coupon.used_count >= coupon.usage_limit:
            return Response({'error': 'Coupon usage limit reached.'}, status=400)

        discount = coupon.calculate_discount(order_value)
        if discount == 0:
            return Response({
                'error': f'Add ₹{float(coupon.min_order_value) - order_value:.0f} more to use this coupon.',
            }, status=400)

        return Response({
            'code': coupon.code,
            'title': coupon.title,
            'discount_amount': round(discount, 2),
            'grand_total': round(order_value - discount, 2),
            'message': f'Coupon applied! You saved ₹{discount:.0f}.',
        })


# ─────────────────────────────────────────────
#  CART VIEWS
# ─────────────────────────────────────────────
class CartView(APIView):
    """GET /api/cart/ — fetch user's cart."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        return Response(CartSerializer(cart, context={'request': request}).data)


class CartAddItemView(APIView):
    """POST /api/cart/add/ — add or update item."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        product_id = request.data.get('product_id')
        quantity = int(request.data.get('quantity', 1))

        product = Product.objects.filter(pk=product_id, is_active=True, in_stock=True).first()
        if not product:
            return Response({'error': 'Product not found or out of stock.'}, status=400)

        item, created = CartItem.objects.get_or_create(cart=cart, product=product)
        if not created:
            item.quantity += quantity
        else:
            item.quantity = quantity
        item.save()

        return Response(CartSerializer(cart, context={'request': request}).data)


class CartUpdateItemView(APIView):
    """PATCH /api/cart/items/<id>/ — set exact quantity."""
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        item = CartItem.objects.filter(pk=pk, cart=cart).first()
        if not item:
            return Response({'error': 'Item not in cart.'}, status=404)

        quantity = int(request.data.get('quantity', 1))
        if quantity <= 0:
            item.delete()
        else:
            item.quantity = quantity
            item.save()

        return Response(CartSerializer(cart, context={'request': request}).data)


class CartRemoveItemView(APIView):
    """DELETE /api/cart/items/<id>/"""
    permission_classes = [IsAuthenticated]

    def delete(self, request, pk):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        CartItem.objects.filter(pk=pk, cart=cart).delete()
        return Response(CartSerializer(cart, context={'request': request}).data)


class CartClearView(APIView):
    """DELETE /api/cart/clear/"""
    permission_classes = [IsAuthenticated]

    def delete(self, request):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        cart.cart_items.all().delete()
        return Response({'message': 'Cart cleared.'})


# ─────────────────────────────────────────────
#  ORDER VIEWS
# ─────────────────────────────────────────────
class OrderListView(generics.ListAPIView):
    """GET /api/orders/"""
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).prefetch_related('items')


class OrderDetailView(generics.RetrieveAPIView):
    """GET /api/orders/<id>/"""
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user)


class CreateOrderView(APIView):
    """POST /api/orders/create/ — convert cart to order."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = CreateOrderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        # Validate address
        # Address lookup with dev-friendly fallback
        address = Address.objects.filter(pk=data.get('address_id'), user=request.user).first()
        
        if not address:
            # Fallback 1: Try default address
            address = Address.objects.filter(user=request.user, is_default=True).first()
        
        if not address:
            # Fallback 2: Try any address for the user
            address = Address.objects.filter(user=request.user).first()

        if not address:
            return Response({'error': 'Delivery address not found. Please add an address to your profile.'}, status=400)

        # Get cart
        cart = Cart.objects.filter(user=request.user).first()
        if not cart or not cart.cart_items.exists():
            return Response({'error': 'Cart is empty.'}, status=400)

        # Coupon
        coupon = None
        coupon_discount = 0
        if data.get('coupon_code'):
            coupon = Coupon.objects.filter(code=data['coupon_code'].upper(), is_active=True).first()
            if coupon:
                coupon_discount = coupon.calculate_discount(float(cart.total))
                coupon.used_count += 1
                coupon.save()

        items_total = cart.total
        
        order = Order.objects.create(
            user=request.user,
            address=address,
            coupon=coupon,
            payment_method=data['payment_method'],
            items_total=items_total,
            delivery_charge=0,
            coupon_discount=coupon_discount,
            grand_total=0,  # auto-computed in save()
            delivery_instructions=data.get('delivery_instructions', ''),
            estimated_delivery_time='25 - 35 mins',
        )

        # Snapshot cart items into order items
        for cart_item in cart.cart_items.select_related('product').all():
            img = cart_item.product.images.filter(is_primary=True).first()
            OrderItem.objects.create(
                order=order,
                product=cart_item.product,
                product_name=cart_item.product.name,
                product_image=request.build_absolute_uri(img.image.url) if img else '',
                product_weight=cart_item.product.weight,
                unit_price=cart_item.product.price,
                quantity=cart_item.quantity,
            )

        # Clear cart
        cart.cart_items.all().delete()

        # Create placement notification
        Notification.objects.create(
            user=request.user,
            order=order,
            notification_type='order_placed',
            title='Order Placed! 🎉',
            body=f'Your order #{order.id} has been placed successfully.',
        )

        return Response(OrderSerializer(order, context={'request': request}).data,
                        status=status.HTTP_201_CREATED)


class CancelOrderView(APIView):
    """POST /api/orders/<id>/cancel/"""
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        order = Order.objects.filter(pk=pk, user=request.user).first()
        if not order:
            return Response({'error': 'Order not found.'}, status=404)
        if order.status in ('packed', 'rider_assigned', 'out_for_delivery', 'delivered'):
            return Response({'error': 'Order cannot be cancelled at this stage.'}, status=400)
        order.status = 'cancelled'
        order.save()
        return Response({'message': 'Order cancelled.', 'order_id': order.id})


class TrackOrderView(APIView):
    """GET /api/orders/<id>/track/ — status + rider location."""
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        order = Order.objects.filter(pk=pk, user=request.user).first()
        if not order:
            return Response({'error': 'Order not found.'}, status=404)
        
        # safely access rider details
        rider_name = order.rider.user.get_full_name() or order.rider.user.username if order.rider else ''
        rider_phone = order.rider.user.phone_number if order.rider else ''
        rider_lat = str(order.rider.latitude) if order.rider and order.rider.latitude else None
        rider_lng = str(order.rider.longitude) if order.rider and order.rider.longitude else None

        # destination from order address
        dest_lat = str(order.address.latitude) if order.address and order.address.latitude else None
        dest_lng = str(order.address.longitude) if order.address and order.address.longitude else None

        return Response({
            'order_id': order.id,
            'status': order.status,
            'status_display': order.get_status_display(),
            'grand_total': float(order.grand_total),
            'customer_name': order.user.get_full_name() or order.user.username,
            'customer_phone': order.user.phone_number,
            'delivery_address': order.address.full_address if order.address else '',
            'rider_name': rider_name,
            'rider_phone': rider_phone,
            'rider_location': {
                'latitude': rider_lat,
                'longitude': rider_lng,
            },
            'destination_location': {
                'latitude': dest_lat,
                'longitude': dest_lng,
            },
            'estimated_delivery_time': order.estimated_delivery_time,
            'delivery_instructions': order.delivery_instructions,
            'items_summary': ", ".join([f"{item.quantity} x {item.product_name}" for item in order.items.all()[:2]])
        })


class UpdateDeliveryInstructionsView(APIView):
    """PATCH /api/orders/<id>/instructions/"""
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        order = Order.objects.filter(pk=pk, user=request.user).first()
        if not order:
            return Response({'error': 'Order not found.'}, status=404)
        order.delivery_instructions = request.data.get('delivery_instructions', '')
        order.save()
        return Response({'message': 'Instructions updated.'})


# Admin-only: update order status (for rider tracking simulation)
class AdminUpdateOrderStatusView(APIView):
    """PATCH /api/admin/orders/<id>/status/ — rider app / delivery agent."""
    permission_classes = [IsAdminUser]

    def patch(self, request, pk):
        order = Order.objects.filter(pk=pk).first()
        if not order:
            return Response({'error': 'Order not found.'}, status=404)

        serializer = UpdateOrderStatusSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        d = serializer.validated_data

        order.status = d['status']
        if 'rider_id' in d:
            rider = DeliveryStaff.objects.filter(pk=d['rider_id']).first()
            if rider:
                order.rider = rider
        order.save()

        # Safely get rider name for notification
        rider_name_str = "a rider"
        if order.rider:
            rider_name_str = order.rider.user.get_full_name() or order.rider.user.username

        # Push notification to user
        notification_map = {
            'shop_confirmed': ('Shop Confirmed ✅', 'Your order has been accepted by the shop.'),
            'preparing': ('We\'re Preparing Your Order 👨‍🍳', 'Your order is being prepared.'),
            'packed': ('Order Packed 📦', 'Your order is packed and ready.'),
            'rider_assigned': ('Rider Assigned 🛵', f'Rider {rider_name_str} is picking up your order.'),
            'out_for_delivery': ('Out for Delivery 🚀', 'Your order is on the way!'),
            'near': ('Almost There! 📍', 'Your rider is nearby. Be ready!'),
            'delivered': ('Order Delivered! 🎉', f'Order #{order.id} delivered. Enjoy!'),
        }
        msg = notification_map.get(d['status'])
        if msg:
            Notification.objects.create(
                user=order.user,
                order=order,
                notification_type=d['status'] if d['status'] in dict(Notification.NOTIFICATION_TYPES) else 'general',
                title=msg[0],
                body=msg[1],
            )

        return Response(OrderSerializer(order, context={'request': request}).data)


# ─────────────────────────────────────────────
#  NOTIFICATION VIEWS
# ─────────────────────────────────────────────
class NotificationListView(generics.ListAPIView):
    """GET /api/notifications/"""
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Notification.objects.filter(user=self.request.user)


class MarkNotificationReadView(APIView):
    """POST /api/notifications/<id>/read/"""
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        Notification.objects.filter(pk=pk, user=request.user).update(is_read=True)
        return Response({'message': 'Notification marked as read.'})


class MarkAllNotificationsReadView(APIView):
    """POST /api/notifications/read-all/"""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        Notification.objects.filter(user=request.user, is_read=False).update(is_read=True)
        return Response({'message': 'All notifications marked as read.'})


# ─────────────────────────────────────────────
#  REVIEW VIEWS
# ─────────────────────────────────────────────
class ReviewListCreateView(generics.ListCreateAPIView):
    """GET /api/products/<product_id>/reviews/   POST ..."""
    serializer_class = ReviewSerializer

    def get_permissions(self):
        if self.request.method == 'POST':
            return [IsAuthenticated()]
        return [AllowAny()]

    def get_queryset(self):
        return Review.objects.filter(product_id=self.kwargs['product_id'])

    def perform_create(self, serializer):
        serializer.save(product_id=self.kwargs['product_id'], user=self.request.user)


# ─────────────────────────────────────────────
#  COMPLAINT VIEWS
# ─────────────────────────────────────────────
class ComplaintListCreateView(generics.ListCreateAPIView):
    """GET /api/complaints/    POST /api/complaints/"""
    serializer_class = ComplaintSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Complaint.objects.filter(user=self.request.user)


class ComplaintDetailView(generics.RetrieveAPIView):
    """GET /api/complaints/<id>/"""
    serializer_class = ComplaintSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Complaint.objects.filter(user=self.request.user)


# ─────────────────────────────────────────────
#  GOLD MEMBERSHIP
# ─────────────────────────────────────────────
class GoldMembershipView(APIView):
    """GET /api/gold/    POST /api/gold/subscribe/"""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        membership = GoldMembership.objects.filter(user=request.user).first()
        if not membership:
            return Response({'is_active': False, 'plan': None})
        return Response(GoldMembershipSerializer(membership).data)

    def post(self, request):
        plan = request.data.get('plan', 'monthly')
        durations = {'monthly': 30, 'quarterly': 90, 'yearly': 365}
        days = durations.get(plan, 30)

        membership, _ = GoldMembership.objects.update_or_create(
            user=request.user,
            defaults={
                'plan': plan,
                'is_active': True,
                'expires_at': timezone.now() + timedelta(days=days),
            }
        )
        return Response(GoldMembershipSerializer(membership).data)


# ─────────────────────────────────────────────
#  SEARCH VIEWS
# ─────────────────────────────────────────────
class SearchView(APIView):
    """GET /api/search/?q=chicken"""
    permission_classes = [AllowAny]

    def get(self, request):
        query = request.query_params.get('q', '').strip()
        if not query:
            return Response({'results': [], 'query': ''})

        products = Product.objects.filter(
            is_active=True,
        ).filter(
            models.Q(name__icontains=query) |
            models.Q(description__icontains=query) |
            models.Q(category__name__icontains=query)
        )[:20]

        # Save to search history if user is authenticated
        if request.user.is_authenticated:
            SearchHistory.objects.get_or_create(user=request.user, query=query)

        return Response({
            'query': query,
            'results': ProductListSerializer(products, many=True, context={'request': request}).data,
        })


class SearchHistoryView(generics.ListAPIView):
    """GET /api/search/history/"""
    serializer_class = SearchHistorySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return SearchHistory.objects.filter(user=self.request.user)[:20]


class ClearSearchHistoryView(APIView):
    """DELETE /api/search/history/clear/"""
    permission_classes = [IsAuthenticated]

    def delete(self, request):
        SearchHistory.objects.filter(user=request.user).delete()
        return Response({'message': 'Search history cleared.'})


# ─────────────────────────────────────────────
#  PRIVACY / TERMS (static)
# ─────────────────────────────────────────────
class PrivacyPolicyView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        return Response({
            'title': 'Privacy Policy',
            'content': (
                'WayToFresh is committed to protecting your privacy. '
                'We collect personal information to provide and improve our services. '
                'Your data is never sold to third parties.'
            ),
            'last_updated': '2024-01-01',
        })


class TermsView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        return Response({
            'title': 'Terms & Conditions',
            'content': (
                'By using WayToFresh you agree to our terms of service. '
                'Orders cannot be cancelled once packed. '
                'Refunds are processed within 5-7 business days.'
            ),
            'last_updated': '2024-01-01',
        })


# Need to import models.Q for search
from django.db import models
