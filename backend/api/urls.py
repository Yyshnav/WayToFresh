from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from . import views

urlpatterns = [

    # ─── AUTH ───────────────────────────────────────────────────────
    path('auth/register/', views.RegisterView.as_view(), name='register'),
    path('auth/login/', views.LoginView.as_view(), name='login'),
    path('auth/logout/', views.LogoutView.as_view(), name='logout'),
    path('auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('auth/otp/request/', views.OTPRequestView.as_view(), name='otp_request'),
    path('auth/otp/verify/', views.OTPVerifyView.as_view(), name='otp_verify'),
    path('auth/profile/', views.ProfileView.as_view(), name='profile'),
    path('auth/change-password/', views.ChangePasswordView.as_view(), name='change_password'),

    # ─── HOME ───────────────────────────────────────────────────────
    path('home/', views.HomeDataView.as_view(), name='home_data'),

    # ─── CATEGORIES ─────────────────────────────────────────────────
    path('categories/', views.CategoryListView.as_view(), name='category_list'),
    path('categories/<int:pk>/', views.CategoryDetailView.as_view(), name='category_detail'),

    # ─── PRODUCTS ───────────────────────────────────────────────────
    path('products/', views.ProductListView.as_view(), name='product_list'),
    path('products/<int:pk>/', views.ProductDetailView.as_view(), name='product_detail'),

    # Product Reviews
    path('products/<int:product_id>/reviews/', views.ReviewListCreateView.as_view(), name='product_reviews'),

    # ─── BANNERS ────────────────────────────────────────────────────
    path('banners/', views.BannerListView.as_view(), name='banner_list'),

    # ─── ADDRESSES ──────────────────────────────────────────────────
    path('addresses/', views.AddressListCreateView.as_view(), name='address_list'),
    path('addresses/<int:pk>/', views.AddressDetailView.as_view(), name='address_detail'),
    path('addresses/<int:pk>/set-default/', views.SetDefaultAddressView.as_view(), name='address_set_default'),

    # ─── COUPONS ────────────────────────────────────────────────────
    path('coupons/', views.CouponListView.as_view(), name='coupon_list'),
    path('coupons/apply/', views.ApplyCouponView.as_view(), name='coupon_apply'),

    # ─── CART ───────────────────────────────────────────────────────
    path('cart/', views.CartView.as_view(), name='cart'),
    path('cart/add/', views.CartAddItemView.as_view(), name='cart_add'),
    path('cart/items/<int:pk>/', views.CartUpdateItemView.as_view(), name='cart_update'),
    path('cart/items/<int:pk>/remove/', views.CartRemoveItemView.as_view(), name='cart_remove'),
    path('cart/clear/', views.CartClearView.as_view(), name='cart_clear'),

    # ─── ORDERS ─────────────────────────────────────────────────────
    path('orders/', views.OrderListView.as_view(), name='order_list'),
    path('orders/create/', views.CreateOrderView.as_view(), name='order_create'),
    path('orders/<int:pk>/', views.OrderDetailView.as_view(), name='order_detail'),
    path('orders/<int:pk>/cancel/', views.CancelOrderView.as_view(), name='order_cancel'),
    path('orders/<int:pk>/track/', views.TrackOrderView.as_view(), name='order_track'),
    path('orders/<int:pk>/instructions/', views.UpdateDeliveryInstructionsView.as_view(), name='order_instructions'),

    # Admin-only order status update (used by rider/delivery apps)
    path('admin/orders/<int:pk>/status/', views.AdminUpdateOrderStatusView.as_view(), name='admin_order_status'),

    # ─── NOTIFICATIONS ──────────────────────────────────────────────
    path('notifications/', views.NotificationListView.as_view(), name='notification_list'),
    path('notifications/<int:pk>/read/', views.MarkNotificationReadView.as_view(), name='notification_read'),
    path('notifications/read-all/', views.MarkAllNotificationsReadView.as_view(), name='notification_read_all'),

    # ─── COMPLAINTS ─────────────────────────────────────────────────
    path('complaints/', views.ComplaintListCreateView.as_view(), name='complaint_list'),
    path('complaints/<int:pk>/', views.ComplaintDetailView.as_view(), name='complaint_detail'),

    # ─── GOLD MEMBERSHIP ────────────────────────────────────────────
    path('gold/', views.GoldMembershipView.as_view(), name='gold_membership'),

    # ─── SEARCH ─────────────────────────────────────────────────────
    path('search/', views.SearchView.as_view(), name='search'),
    path('search/history/', views.SearchHistoryView.as_view(), name='search_history'),
    path('search/history/clear/', views.ClearSearchHistoryView.as_view(), name='search_history_clear'),

    # ─── STATIC PAGES ───────────────────────────────────────────────
    path('privacy-policy/', views.PrivacyPolicyView.as_view(), name='privacy_policy'),
    path('terms/', views.TermsView.as_view(), name='terms'),
]
