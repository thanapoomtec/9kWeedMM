import os
import datetime
import uuid
import qrcode
from io import BytesIO
import base64
from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify,send_file
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
from sqlalchemy import func, desc, and_, or_, text
from sqlalchemy.exc import SQLAlchemyError
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')
import shutil
import random
import time
from threading import Lock


# Initialize Flask app
app = Flask(__name__)
app.config['SECRET_KEY'] = 'cannabis2090'

# Database configuration - Change to MySQL for production
# SQLite configuration (for development)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///marbo9k.db'

# MySQL configuration (for production)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/marbo9k'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# File upload configuration
UPLOAD_FOLDER = 'static'  # เปลี่ยนจาก 'static/uploads' เป็น 'static'
MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # 16MB max upload size
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Create upload directories if they don't exist
os.makedirs(os.path.join(UPLOAD_FOLDER, 'products'), exist_ok=True)
os.makedirs(os.path.join(UPLOAD_FOLDER, 'slips'), exist_ok=True)
os.makedirs(os.path.join(UPLOAD_FOLDER, 'qrcodes'), exist_ok=True)
os.makedirs(os.path.join(UPLOAD_FOLDER, 'logos'), exist_ok=True)
os.makedirs(os.path.join(UPLOAD_FOLDER, 'backups'), exist_ok=True)  # เพิ่มสำหรับ backups
# Initialize database
db = SQLAlchemy(app)


# Create a lock for concurrency control
stock_update_lock = Lock()

# Database Models
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(200), nullable=False)
    name = db.Column(db.String(100))
    role = db.Column(db.String(20), default='staff')
    created_at = db.Column(db.DateTime, default=datetime.datetime.now)

class Customer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    phone = db.Column(db.String(20))
    address = db.Column(db.Text)
    line_id = db.Column(db.String(50))
    created_at = db.Column(db.DateTime, default=datetime.datetime.now)
    orders = db.relationship('Order', backref='customer', lazy=True)

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    flavor = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    price = db.Column(db.Float, nullable=False)
    cost = db.Column(db.Float, nullable=False)
    wholesale_price = db.Column(db.Float)
    stock = db.Column(db.Integer, default=0)
    barcode = db.Column(db.String(50))
    image_path = db.Column(db.String(200))
    created_at = db.Column(db.DateTime, default=datetime.datetime.now)
    
    @property
    def profit_margin(self):
        if self.price > 0:
            return ((self.price - self.cost) / self.price) * 100
        return 0

class Order(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    customer_id = db.Column(db.Integer, db.ForeignKey('customer.id'), nullable=False)
    order_date = db.Column(db.DateTime, default=datetime.datetime.now)
    total_amount = db.Column(db.Float, default=0)
    shipping_address = db.Column(db.Text)
    payment_slip = db.Column(db.String(200))
    payment_date = db.Column(db.DateTime)
    payment_status = db.Column(db.String(20), default='pending')
    status = db.Column(db.String(20), default='pending')
    notes = db.Column(db.Text)
    qr_code_path = db.Column(db.String(200))
    pickup_location = db.Column(db.String(500))
    order_items = db.relationship('OrderItem', backref='order', lazy=True, cascade="all, delete-orphan")
    
    @property
    def item_count(self):
        return sum(item.quantity for item in self.order_items)

class OrderItem(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('order.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Float, nullable=False)
    product = db.relationship('Product')

class InventoryEntry(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    date = db.Column(db.DateTime, default=lambda: datetime.datetime.now(datetime.timezone.utc))
    notes = db.Column(db.Text)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)  # เพิ่มฟิลด์นี้
    product = db.relationship('Product')
    user = db.relationship('User')  # ความสัมพันธ์กับ User

class ActivityLog(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    action = db.Column(db.String(100), nullable=False)
    entity_type = db.Column(db.String(50))
    entity_id = db.Column(db.Integer)
    details = db.Column(db.Text)
    ip_address = db.Column(db.String(50))
    timestamp = db.Column(db.DateTime, default=datetime.datetime.now)
    user = db.relationship('User')

class Notification(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    message = db.Column(db.String(255), nullable=False)
    type = db.Column(db.String(50))
    related_id = db.Column(db.Integer)
    is_read = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.datetime.now)
    user = db.relationship('User')

class Settings(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    company_name = db.Column(db.String(100))
    company_logo = db.Column(db.String(200))
    company_address = db.Column(db.Text)
    company_phone = db.Column(db.String(20))
    company_email = db.Column(db.String(100))
    low_stock_threshold = db.Column(db.Integer, default=10)
    
class ShopSettings(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    hero_title = db.Column(db.String(200), default="ยินดีต้อนรับสู่ Marbo 9k Shop")
    hero_subtitle = db.Column(db.String(200), default="เลือกสินค้าคุณภาพที่คุณชื่นชอบ ส่งตรงถึงบ้านคุณ")
    hero_background = db.Column(db.String(200))
    hero_text_color = db.Column(db.String(20), default="#ffffff")
    hero_button_text = db.Column(db.String(50))
    featured_title = db.Column(db.String(100), default="สินค้าแนะนำ")
    featured_subtitle = db.Column(db.String(200))
    primary_color = db.Column(db.String(20), default="#0066cc")
    secondary_color = db.Column(db.String(20), default="#001f3f")
    accent_color = db.Column(db.String(20), default="#ffc107")
    text_color = db.Column(db.String(20), default="#333333")
    font_family = db.Column(db.String(50), default="Kanit")
    border_radius = db.Column(db.Integer, default=8)
    footer_text = db.Column(db.String(200), default="&copy; 2025 Marbo 9k Shop. สงวนลิขสิทธิ์ทุกประการ.")
    contact_phone = db.Column(db.String(20))
    contact_email = db.Column(db.String(100))
    social_facebook = db.Column(db.String(200))
    social_instagram = db.Column(db.String(200))
    social_line = db.Column(db.String(50))
    updated_at = db.Column(db.DateTime, default=datetime.datetime.now, onupdate=datetime.datetime.now)

class Banner(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    image_path = db.Column(db.String(200), nullable=False)
    link = db.Column(db.String(200))
    position = db.Column(db.String(20), default="top")
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.datetime.now)
    updated_at = db.Column(db.DateTime, default=datetime.datetime.now, onupdate=datetime.datetime.now)

class FeaturedProduct(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    position = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.datetime.now)
    product = db.relationship('Product')

# Helper functions
def allowed_file(filename):
    ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'gif', 'webp'}  # เพิ่ม webp
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def save_file(file, folder):
    if file and file.filename:
        # Check if the file has an allowed extension
        if not allowed_file(file.filename):
            return None
            
        filename = secure_filename(file.filename)
        # Add timestamp to filename to avoid duplicates
        timestamp = int(time.time())
        name, ext = os.path.splitext(filename)
        filename = f"{name}_{timestamp}{ext}"
        
        # Create folder path with normalized slashes
        folder_path = os.path.normpath(os.path.join(app.config['UPLOAD_FOLDER'], folder))
        folder_path = folder_path.replace('\\', '/')
        
        # Create file path with normalized slashes
        file_path = os.path.normpath(os.path.join(folder_path, filename))
        file_path = file_path.replace('\\', '/')
        
        try:
            # Ensure directory exists
            os.makedirs(folder_path, exist_ok=True)
            file.save(file_path)
            
            # Return path with forward slashes for URL (relative to static folder)
            relative_path = os.path.join(folder, filename).replace('\\', '/')
            print(f"Saved file at: {file_path}, URL path: {relative_path}")
            return relative_path
        except Exception as e:
            print(f"Error saving file: {e}")
            return None
    return None

def delete_file(file_path):
    if file_path:
        full_path = os.path.join(app.config['UPLOAD_FOLDER'], file_path)
        full_path = os.path.normpath(full_path)
        if os.path.exists(full_path):
            os.remove(full_path)

def log_activity(action, entity_type=None, entity_id=None, details=None):
    if 'user_id' in session:
        log = ActivityLog(
            user_id=session['user_id'],
            action=action,
            entity_type=entity_type,
            entity_id=entity_id,
            details=details,
            ip_address=request.remote_addr
        )
        db.session.add(log)
        db.session.commit()

def create_notification(message, notification_type, related_id=None):
    # Create notification for all admin users
    admins = User.query.filter_by(role='admin').all()
    for admin in admins:
        notification = Notification(
            user_id=admin.id,
            message=message,
            type=notification_type,
            related_id=related_id
        )
        db.session.add(notification)
    db.session.commit()

def generate_qr_code(order_id):
    """Generate QR code for payment and save it to file"""
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    
    # Add data to QR code (e.g., payment information or link)
    payment_data = f"https://example.com/pay/{order_id}"
    qr.add_data(payment_data)
    qr.make(fit=True)
    
    # Create QR code image
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Save to file
    filename = f"qrcode_{order_id}.png"
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], 'qrcodes', filename)
    img.save(file_path)
    
    # Return the path relative to static folder
    return os.path.join('qrcodes', filename)

def generate_qr_code_base64(order_id):
    """Generate QR code for payment and return as base64 string"""
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    
    # Add data to QR code (e.g., payment information or link)
    payment_data = f"https://example.com/pay/{order_id}"
    qr.add_data(payment_data)
    qr.make(fit=True)
    
    # Create QR code image
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Convert to base64
    buffered = BytesIO()
    img.save(buffered)
    img_str = base64.b64encode(buffered.getvalue()).decode()
    
    return f"data:image/png;base64,{img_str}"

# Routes
@app.route('/')
def index():
    if 'user_id' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('shop'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        user = User.query.filter_by(username=username).first()
        
        if user and check_password_hash(user.password, password):
            session['user_id'] = user.id
            session['username'] = user.username
            session['role'] = user.role
            
            log_activity('login')
            flash('เข้าสู่ระบบสำเร็จ', 'success')
            return redirect(url_for('dashboard'))
        
        flash('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง', 'danger')
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    if 'user_id' in session:
        log_activity('logout')
    
    session.clear()
    flash('ออกจากระบบสำเร็จ', 'success')
    return redirect(url_for('login'))

@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    # Get summary data
    total_sales = db.session.query(func.sum(Order.total_amount)).scalar() or 0
    pending_orders = Order.query.filter_by(payment_status='pending').count()
    
    # Get low stock products
    settings = Settings.query.first()
    low_stock_threshold = settings.low_stock_threshold if settings else 10
    low_stock_products = Product.query.filter(Product.stock < low_stock_threshold).count()
    low_stock_products_list = Product.query.filter(Product.stock < low_stock_threshold).all()
    
    # Get recent orders
    recent_orders = Order.query.order_by(Order.order_date.desc()).limit(5).all()
    
    return render_template('dashboard.html', 
                          total_sales=total_sales,
                          pending_orders=pending_orders,
                          low_stock_products=low_stock_products,
                          low_stock_products_list=low_stock_products_list,
                          recent_orders=recent_orders)

@app.route('/realtime_data')
def realtime_data():
    if 'user_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    period = request.args.get('period', 'day')
    
    # คำนวณช่วงวันที่ตาม period
    today = datetime.datetime.now().date()
    if period == 'day':
        start_date = today
        end_date = today
    elif period == 'week':
        start_date = today - datetime.timedelta(days=today.weekday())
        end_date = today
    elif period == 'month':
        start_date = today.replace(day=1)
        end_date = today
    elif period == 'year':
        start_date = today.replace(month=1, day=1)
        end_date = today
    else:
        return jsonify({'error': 'Invalid period'}), 400
    
    # ดึงข้อมูลการขายแบบแบ่งหน้า
    page = request.args.get('page', 1, type=int)
    per_page = 100  # ปรับตามความต้องการ
    
    orders_query = Order.query.filter(
        func.date(Order.order_date) >= start_date,
        func.date(Order.order_date) <= end_date
    ).order_by(Order.order_date.desc())
    
    orders_paginated = orders_query.paginate(page=page, per_page=per_page, error_out=False)
    orders = orders_paginated.items
    
    # คำนวณยอดขายรวมในช่วงนั้น
    total_sales = db.session.query(func.sum(Order.total_amount)).filter(
        func.date(Order.order_date) >= start_date,
        func.date(Order.order_date) <= end_date
    ).scalar() or 0
    total_sales = float(total_sales)  # แปลงเป็น float
    
    # คำนวณการเปลี่ยนแปลงยอดขายเทียบกับช่วงก่อนหน้า
    if period == 'day':
        prev_start_date = today - datetime.timedelta(days=1)
        prev_end_date = prev_start_date
    elif period == 'week':
        prev_start_date = start_date - datetime.timedelta(weeks=1)
        prev_end_date = start_date - datetime.timedelta(days=1)
    elif period == 'month':
        prev_month = start_date.month - 1
        prev_year = start_date.year
        if prev_month == 0:
            prev_month = 12
            prev_year -= 1
        prev_start_date = datetime.date(prev_year, prev_month, 1)
        if start_date.month == 1:
            prev_end_date = datetime.date(start_date.year - 1, 12, 31)
        else:
            prev_end_date = start_date - datetime.timedelta(days=1)
    elif period == 'year':
        prev_start_date = datetime.date(start_date.year - 1, 1, 1)
        prev_end_date = datetime.date(start_date.year - 1, 12, 31)
    
    prev_sales = db.session.query(func.sum(Order.total_amount)).filter(
        func.date(Order.order_date) >= prev_start_date,
        func.date(Order.order_date) <= prev_end_date
    ).scalar() or 0
    prev_sales = float(prev_sales)  # แปลงเป็น float
    
    sales_change = 0
    if prev_sales > 0:
        sales_change = ((total_sales - prev_sales) / prev_sales) * 100
    
    # ดึงยอดขายวันนี้
    today_sales = db.session.query(func.sum(Order.total_amount)).filter(
        func.date(Order.order_date) == today
    ).scalar() or 0
    today_sales = float(today_sales)  # แปลงเป็น float
    
    today_order_count = Order.query.filter(
        func.date(Order.order_date) == today
    ).count()
    
    # คำนวณข้อมูลกำไร
    order_items = db.session.query(
        OrderItem.product_id,
        func.sum(OrderItem.quantity).label('quantity'),
        func.sum(OrderItem.price * OrderItem.quantity).label('revenue')
    ).join(Order).filter(
        func.date(Order.order_date) >= start_date,
        func.date(Order.order_date) <= end_date
    ).group_by(OrderItem.product_id).limit(100).all()
    
    total_profit = 0
    total_cost = 0
    total_units_sold = 0
    
    for item in order_items:
        product = Product.query.get(item.product_id)
        if product:
            # แปลง Decimal เป็น float ถ้าจำเป็น
            quantity = float(item.quantity) if hasattr(item.quantity, 'as_integer_ratio') else item.quantity
            revenue = float(item.revenue) if hasattr(item.revenue, 'as_integer_ratio') else item.revenue
            cost = float(product.cost)  # แปลง cost เป็น float
            item_cost = cost * quantity
            item_profit = revenue - item_cost
            total_profit += item_profit
            total_cost += item_cost
            total_units_sold += quantity
    
    # คำนวณการเปลี่ยนแปลงกำไร
    prev_order_items = db.session.query(
        OrderItem.product_id,
        func.sum(OrderItem.quantity).label('quantity'),
        func.sum(OrderItem.price * OrderItem.quantity).label('revenue')
    ).join(Order).filter(
        func.date(Order.order_date) >= prev_start_date,
        func.date(Order.order_date) <= prev_end_date
    ).group_by(OrderItem.product_id).limit(100).all()
    
    prev_total_profit = 0
    prev_total_units = 0
    
    for item in prev_order_items:
        product = Product.query.get(item.product_id)
        if product:
            # แปลง Decimal เป็น float ถ้าจำเป็น
            quantity = float(item.quantity) if hasattr(item.quantity, 'as_integer_ratio') else item.quantity
            revenue = float(item.revenue) if hasattr(item.revenue, 'as_integer_ratio') else item.revenue
            cost = float(product.cost)  # แปลง cost เป็น float
            item_cost = cost * quantity
            item_profit = revenue - item_cost
            prev_total_profit += item_profit
            prev_total_units += quantity
    
    profit_change = 0
    if prev_total_profit > 0:
        profit_change = ((total_profit - prev_total_profit) / prev_total_profit) * 100
    
    units_change = 0
    if prev_total_units > 0:
        units_change = ((total_units_sold - prev_total_units) / prev_total_units) * 100
    
    # คำนวณอัตรากำไรเฉลี่ย
    avg_profit_margin = 0
    if total_sales > 0:
        avg_profit_margin = (total_profit / total_sales) * 100
    
    # คำนวณเปอร์เซ็นต์ต้นทุน
    cost_percentage = 0
    if total_sales > 0:
        cost_percentage = (total_cost / total_sales) * 100
    
    # เตรียมข้อมูลวิเคราะห์กำไร
    profit_analysis = {
        'total_sales': total_sales,
        'total_cost': total_cost,
        'total_profit': total_profit
    }
    
    # เตรียมข้อมูลยอดขายรายชั่วโมง
    hourly_sales = []
    hourly_labels = []
    
    for hour in range(24):
        hour_start = datetime.datetime.combine(today, datetime.time(hour, 0))
        hour_end = datetime.datetime.combine(today, datetime.time(hour, 59, 59))
        
        hour_sales = db.session.query(func.sum(Order.total_amount)).filter(
            Order.order_date >= hour_start,
            Order.order_date <= hour_end
        ).scalar() or 0
        hour_sales = float(hour_sales)  # แปลงเป็น float
        
        hourly_sales.append({
            'labels': f"{hour:02d}:00",
            'values': hour_sales
        })
        
        hourly_labels.append(f"{hour:02d}:00")
    
    # เตรียมข้อมูลยอดขายรายเดือน
    monthly_sales = {
        'labels': [],
        'current_year': [],
        'last_year': [],
        'target': []
    }
    
    # ดึงยอดขายรายเดือนของปีนี้
    current_year = today.year
    for month in range(1, 13):
        month_name = datetime.date(current_year, month, 1).strftime('%b')
        monthly_sales['labels'].append(month_name)
        
        month_start = datetime.date(current_year, month, 1)
        if month == 12:
            month_end = datetime.date(current_year, month, 31)
        else:
            month_end = datetime.date(current_year, month + 1, 1) - datetime.timedelta(days=1)
        
        month_sales = db.session.query(func.sum(Order.total_amount)).filter(
            func.date(Order.order_date) >= month_start,
            func.date(Order.order_date) <= month_end
        ).scalar() or 0
        month_sales = float(month_sales)  # แปลงเป็น float
        
        monthly_sales['current_year'].append(month_sales)
        
        # ยอดขายของปีที่แล้ว
        last_year_month_start = datetime.date(current_year - 1, month, 1)
        if month == 12:
            last_year_month_end = datetime.date(current_year - 1, month, 31)
        else:
            last_year_month_end = datetime.date(current_year - 1, month + 1, 1) - datetime.timedelta(days=1)
        
        last_year_month_sales = db.session.query(func.sum(Order.total_amount)).filter(
            func.date(Order.order_date) >= last_year_month_start,
            func.date(Order.order_date) <= last_year_month_end
        ).scalar() or 0
        last_year_month_sales = float(last_year_month_sales)  # แปลงเป็น float
        
        monthly_sales['last_year'].append(last_year_month_sales)
        
        # เป้าหมายยอดขาย (เช่น เพิ่ม 10% จากปีที่แล้ว)
        target_sales = last_year_month_sales * 1.1
        monthly_sales['target'].append(target_sales)
    
    # เตรียมข้อมูลสินค้าขายดี
    top_products_by_units = db.session.query(
        Product.id,
        Product.name,
        Product.flavor,
        func.sum(OrderItem.quantity).label('units_sold')
    ).join(OrderItem, Product.id == OrderItem.product_id)\
     .join(Order, OrderItem.order_id == Order.id)\
     .filter(
        func.date(Order.order_date) >= start_date,
        func.date(Order.order_date) <= end_date
     )\
     .group_by(Product.id)\
     .order_by(func.sum(OrderItem.quantity).desc())\
     .limit(5).all()
    
    top_products_by_revenue = db.session.query(
        Product.id,
        Product.name,
        Product.flavor,
        func.sum(OrderItem.price * OrderItem.quantity).label('revenue')
    ).join(OrderItem, Product.id == OrderItem.product_id)\
     .join(Order, OrderItem.order_id == Order.id)\
     .filter(
        func.date(Order.order_date) >= start_date,
        func.date(Order.order_date) <= end_date
     )\
     .group_by(Product.id)\
     .order_by(func.sum(OrderItem.price * OrderItem.quantity).desc())\
     .limit(5).all()
    
    # คำนวณกำไรสำหรับสินค้าแต่ละตัว
    top_products_by_profit = []
    for product in top_products_by_revenue:
        product_obj = Product.query.get(product.id)
        if product_obj:
            # ดึงจำนวนที่ขายได้ทั้งหมดสำหรับสินค้านี้
            quantity_sold = db.session.query(func.sum(OrderItem.quantity))\
                .join(Order, OrderItem.order_id == Order.id)\
                .filter(
                    OrderItem.product_id == product.id,
                    func.date(Order.order_date) >= start_date,
                    func.date(Order.order_date) <= end_date
                ).scalar() or 0
            
            # แปลงเป็น float ถ้าเป็น Decimal
            quantity_sold = float(quantity_sold) if hasattr(quantity_sold, 'as_integer_ratio') else quantity_sold
            revenue = float(product.revenue) if hasattr(product.revenue, 'as_integer_ratio') else product.revenue
            cost = float(product_obj.cost)  # แปลง cost เป็น float
            
            # คำนวณกำไร
            profit = revenue - (cost * quantity_sold)
            
            top_products_by_profit.append({
                'id': product.id,
                'name': product.name,
                'flavor': product.flavor,
                'profit': profit
            })
    
    # เรียงลำดับตามกำไร
    top_products_by_profit = sorted(top_products_by_profit, key=lambda x: x['profit'], reverse=True)[:5]
    
    # จัดรูปแบบข้อมูลสำหรับการตอบกลับ
    top_products = {
        'by_units': [{'name': p.name + ' ' + p.flavor, 'value': float(p.units_sold)} for p in top_products_by_units],
        'by_revenue': [{'name': p.name + ' ' + p.flavor, 'value': float(p.revenue)} for p in top_products_by_revenue],
        'by_profit': [{'name': p['name'] + ' ' + p['flavor'], 'value': float(p['profit'])} for p in top_products_by_profit]
    }
    
    # ส่งข้อมูลทั้งหมดกลับไป
    return jsonify({
        'sales_change': float(sales_change),
        'today_sales': float(today_sales),
        'today_order_count': today_order_count,
        'total_profit': float(total_profit),
        'profit_change': float(profit_change),
        'avg_profit_margin': float(avg_profit_margin),
        'total_units_sold': total_units_sold,
        'units_change': float(units_change),
        'total_cost': float(total_cost),
        'cost_percentage': float(cost_percentage),
        'profit_analysis': profit_analysis,
        'hourly_sales': {
            'labels': hourly_labels,
            'values': [float(h['values']) for h in hourly_sales]
        },
        'monthly_sales': monthly_sales,
        'top_products': top_products,
        'has_more': orders_paginated.has_next,
        'next_page': page + 1 if orders_paginated.has_next else None
    })

@app.route('/products')
def products():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    page = request.args.get('page', 1, type=int)
    per_page = 20
    settings = Settings.query.first()
    low_stock_threshold = settings.low_stock_threshold if settings else 10
    
    products_paginated = Product.query.paginate(page=page, per_page=per_page, error_out=False)
    products = products_paginated.items
    
    low_stock = [p for p in products if p.stock < low_stock_threshold]
    
    return render_template('products.html', products=products, pagination=products_paginated, low_stock=low_stock)


@app.route('/add_product', methods=['GET', 'POST'])
def add_product():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        name = request.form['name']
        flavor = request.form['flavor']
        description = request.form['description']
        price = float(request.form['price'])
        cost = float(request.form['cost'])
        wholesale_price = request.form.get('wholesale_price', '')
        stock = int(request.form['stock'])
        barcode = request.form.get('barcode', '')
        
        # Handle file upload with validation
        image_path = None
        if 'image' in request.files and request.files['image'].filename:
            file = request.files['image']
            
            # Validate file type
            if not allowed_file(file.filename):
                flash('รูปแบบไฟล์ไม่ถูกต้อง กรุณาอัปโหลดไฟล์รูปภาพเท่านั้น (JPG, PNG, GIF, WEBP)', 'danger')
                return render_template('add_product.html')
            
            # Save file
            image_path = save_file(file, 'products')
            if not image_path:
                flash('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ กรุณาลองใหม่อีกครั้ง', 'danger')
                return render_template('add_product.html')
        
        # Convert empty string to None for wholesale_price
        # Convert empty string to None for wholesale_price
        if wholesale_price == '':
            wholesale_price = None
        else:
            wholesale_price = float(wholesale_price)
        
        product = Product(
            name=name,
            flavor=flavor,
            description=description,
            price=price,
            cost=cost,
            wholesale_price=wholesale_price,
            stock=stock,
            barcode=barcode,
            image_path=image_path
        )
        
        db.session.add(product)
        db.session.commit()
        
        log_activity('add_product', 'product', product.id, f'Added product: {name} {flavor}')
        flash('เพิ่มสินค้าสำเร็จ', 'success')
        return redirect(url_for('products'))
    
    return render_template('add_product.html')


@app.route('/edit_product/<int:id>', methods=['GET', 'POST'])
def edit_product(id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    product = Product.query.get_or_404(id)
    
    if request.method == 'POST':
        product.name = request.form['name']
        product.flavor = request.form['flavor']
        product.description = request.form['description']
        product.price = float(request.form['price'])
        product.cost = float(request.form['cost'])
        
        wholesale_price = request.form.get('wholesale_price', '')
        if wholesale_price == '':
            product.wholesale_price = None
        else:
            product.wholesale_price = float(wholesale_price)
        
        product.stock = int(request.form['stock'])
        product.barcode = request.form.get('barcode', '')
        
        # Handle file upload with validation
        if 'image' in request.files and request.files['image'].filename:
            file = request.files['image']
            
            # Validate file type
            if not allowed_file(file.filename):
                flash('รูปแบบไฟล์ไม่ถูกต้อง กรุณาอัปโหลดไฟล์รูปภาพเท่านั้น (JPG, PNG, GIF, WEBP)', 'danger')
                return render_template('edit_product.html', product=product)
            
            # Delete old image if exists
            if product.image_path:
                delete_file(product.image_path)
            
            # Save file
            product.image_path = save_file(file, 'products')
            if not product.image_path:
                flash('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ กรุณาลองใหม่อีกครั้ง', 'danger')
                return render_template('edit_product.html', product=product)
        
        db.session.commit()
        
        log_activity('edit_product', 'product', product.id, f'Edited product: {product.name} {product.flavor}')
        flash('แก้ไขสินค้าสำเร็จ', 'success')
        return redirect(url_for('products'))
    
    return render_template('edit_product.html', product=product)

@app.route('/delete_product/<int:id>', methods=['POST'])
def delete_product(id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการลบสินค้า', 'danger')
        return redirect(url_for('products'))
    
    product = Product.query.get_or_404(id)
    
    # Delete product image if exists
    if product.image_path:
        delete_file(product.image_path)
    
    # Log before deleting
    log_activity('delete_product', 'product', product.id, f'Deleted product: {product.name} {product.flavor}')
    
    db.session.delete(product)
    db.session.commit()
    
    flash('ลบสินค้าสำเร็จ', 'success')
    return redirect(url_for('products'))

@app.route('/customers')
def customers():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    # Use pagination for better performance
    page = request.args.get('page', 1, type=int)
    per_page = 20  # Adjust based on your needs
    
    customers_paginated = Customer.query.paginate(page=page, per_page=per_page, error_out=False)
    customers = customers_paginated.items
    
    return render_template('customers.html', customers=customers, pagination=customers_paginated)

@app.route('/add_customer', methods=['GET', 'POST'])
def add_customer():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        name = request.form['name']
        phone = request.form.get('phone', '')
        address = request.form.get('address', '')
        line_id = request.form.get('line_id', '')
        
        customer = Customer(
            name=name,
            phone=phone,
            address=address,
            line_id=line_id
        )
        
        db.session.add(customer)
        db.session.commit()
        
        log_activity('add_customer', 'customer', customer.id, f'Added customer: {name}')
        flash('เพิ่มลูกค้าสำเร็จ', 'success')
        return redirect(url_for('customers'))
    
    return render_template('add_customer.html')

@app.route('/edit_customer/<int:id>', methods=['GET', 'POST'])
def edit_customer(id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    customer = Customer.query.get_or_404(id)
    
    if request.method == 'POST':
        customer.name = request.form['name']
        customer.phone = request.form.get('phone', '')
        customer.address = request.form.get('address', '')
        customer.line_id = request.form.get('line_id', '')
        
        db.session.commit()
        
        log_activity('edit_customer', 'customer', customer.id, f'Edited customer: {customer.name}')
        flash('แก้ไขข้อมูลลูกค้าสำเร็จ', 'success')
        return redirect(url_for('customers'))
    
    return render_template('edit_customer.html', customer=customer)

@app.route('/view_customer/<int:id>')
def view_customer(id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    customer = Customer.query.get_or_404(id)
    orders = Order.query.filter_by(customer_id=id).order_by(Order.order_date.desc()).all()
    
    return render_template('view_customer.html', customer=customer, orders=orders)

@app.route('/orders')
def orders():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    # Use pagination for better performance
    page = request.args.get('page', 1, type=int)
    per_page = 20  # Adjust based on your needs
    
    orders_paginated = Order.query.order_by(Order.order_date.desc()).paginate(page=page, per_page=per_page, error_out=False)
    orders = orders_paginated.items
    
    return render_template('orders.html', orders=orders, pagination=orders_paginated)

@app.route('/add_order', methods=['GET', 'POST'])
def add_order():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        customer_id = request.form['customer_id']
        shipping_address = request.form.get('shipping_address', '')
        notes = request.form.get('notes', '')
        
        current_time = datetime.datetime.now(datetime.timezone.utc)
        order = Order(
            customer_id=customer_id,
            shipping_address=shipping_address,
            notes=notes,
            order_date=current_time
        )
        db.session.add(order)
        db.session.flush()
        
        product_ids = request.form.getlist('product_id[]')
        quantities = request.form.getlist('quantity[]')
        total_amount = 0
        
        for i in range(len(product_ids)):
            product_id = int(product_ids[i])
            try:
                quantity = int(quantities[i])
                if quantity <= 0:
                    continue
            except ValueError:
                flash('จำนวนสินค้าต้องเป็นตัวเลข', 'danger')
                db.session.rollback()
                return redirect(url_for('add_order'))
            
            with stock_update_lock:
                product = Product.query.get(product_id)
                if not product:
                    continue
                if product.stock < quantity:
                    flash(f'สินค้า {product.name} {product.flavor} มีไม่เพียงพอ (มี {product.stock} ชิ้น)', 'danger')
                    db.session.rollback()
                    return redirect(url_for('add_order'))
                
                order_item = OrderItem(
                    order_id=order.id,
                    product_id=product_id,
                    quantity=quantity,
                    price=product.price
                )
                db.session.add(order_item)
                
                # บันทึกการลดสต็อกใน InventoryEntry
                entry = InventoryEntry(
                    product_id=product_id,
                    quantity=-quantity,  # จำนวนติดลบเพื่อระบุการลด
                    date=current_time,
                    notes=f'Order #{order.id}',
                    user_id=session['user_id']
                )
                db.session.add(entry)
                
                product.stock -= quantity
                total_amount += product.price * quantity
                
                # ตรวจสอบสต็อกต่ำ
                settings = Settings.query.first()
                if product.stock < settings.low_stock_threshold:
                    create_notification(
                        f'สินค้า {product.name} {product.flavor} เหลือ {product.stock} ชิ้น ต่ำกว่าขั้นต่ำ',
                        'low_stock',
                        product.id
                    )
        
        order.total_amount = total_amount
        qr_code_path = generate_qr_code(order.id)
        order.qr_code_path = qr_code_path
        db.session.commit()
        
        create_notification(f'มีคำสั่งซื้อใหม่ #{order.id} จากลูกค้า {order.customer.name}', 'new_order', order.id)
        log_activity('add_order', 'order', order.id, f'Added order for customer: {order.customer.name}')
        flash('เพิ่มคำสั่งซื้อสำเร็จ', 'success')
        return redirect(url_for('orders'))
    
    customers = Customer.query.all()
    products = Product.query.filter(Product.stock > 0).all()
    return render_template('add_order.html', customers=customers, products=products)

@app.route('/view_order/<int:id>')
def view_order(id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    order = Order.query.get_or_404(id)
    
    return render_template('view_order.html', order=order)

@app.route('/delete_order/<int:id>', methods=['POST'])
def delete_order(id):
    order = Order.query.get_or_404(id)
    
    try:
        # Begin transaction
        from datetime import datetime, timezone
        current_time = datetime.now(timezone.utc)
        
        # Get all order items to restore inventory
        order_items = OrderItem.query.filter_by(order_id=order.id).all()
        
        # Restore inventory for each item
        for item in order_items:
            product = Product.query.get(item.product_id)
            if product:
                # Restore stock
                product.stock += item.quantity
                
                # Create inventory entry for the restoration
                inventory_entry = InventoryEntry(
                    product_id=item.product_id,
                    quantity=item.quantity,  # Positive for restoring stock
                    date=current_time,
                    notes=f'Order #{order.id} deleted - Stock restored'
                )
                db.session.add(inventory_entry)
        
        # Delete order items first (due to foreign key constraints)
        for item in order_items:
            db.session.delete(item)
            
        # Delete the order
        db.session.delete(order)
        
        # Commit all changes
        db.session.commit()
        flash('คำสั่งซื้อถูกลบเรียบร้อยแล้ว', 'success')
    except Exception as e:
        db.session.rollback()
        flash(f'เกิดข้อผิดพลาดในการลบคำสั่งซื้อ: {str(e)}', 'danger')
    
    return redirect(url_for('orders'))

@app.route('/update_payment/<int:id>', methods=['POST'])
def update_payment(id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    order = Order.query.get_or_404(id)
    
    # Handle payment slip upload
    if 'payment_slip' in request.files and request.files['payment_slip'].filename:
        file = request.files['payment_slip']
        
        # Validate file type
        if not allowed_file(file.filename):
            flash('รูปแบบไฟล์ไม่ถูกต้อง กรุณาอัปโหลดไฟล์รูปภาพเท่านั้น (JPG, PNG, GIF)', 'danger')
            return redirect(url_for('view_order', id=id))
        
        # Validate file size
        if file.content_length and file.content_length > MAX_CONTENT_LENGTH:
            flash('ขนาดไฟล์ใหญ่เกินไป กรุณาอัปโหลดไฟล์ขนาดไม่เกิน 16MB', 'danger')
            return redirect(url_for('view_order', id=id))
        
        # Delete old slip if exists
        if order.payment_slip:
            delete_file(order.payment_slip)
        
        # Save new slip
        payment_slip = save_file(file, 'slips')
        order.payment_slip = payment_slip
        order.payment_date = datetime.datetime.now()
        order.payment_status = 'paid'
        
        db.session.commit()
        
        # Create notification
        create_notification(f'มีการชำระเงินสำหรับคำสั่งซื้อ #{order.id} จากลูกค้า {order.customer.name}', 'payment', order.id)
        
        log_activity('update_payment', 'order', order.id, f'Updated payment for order #{order.id}')
        flash('อัปเดตการชำระเงินสำเร็จ', 'success')
    
    return redirect(url_for('view_order', id=id))

@app.route('/generate_payment_qr/<int:order_id>')
def generate_payment_qr(order_id):
    if 'user_id' not in session and not request.args.get('public'):
        return redirect(url_for('login'))
    
    order = Order.query.get_or_404(order_id)
    
    # Generate QR code if not already generated
    if not order.qr_code_path:
        qr_code_path = generate_qr_code(order.id)
        order.qr_code_path = qr_code_path
        db.session.commit()
    
    # Get QR code URL
    qr_code = url_for('static', filename=order.qr_code_path)
    
    return render_template('payment_qr.html', order=order, qr_code=qr_code)

@app.route('/receipt/<int:order_id>')
def receipt(order_id):
    if 'user_id' not in session and not request.args.get('public'):
        return redirect(url_for('login'))
    
    order = Order.query.get_or_404(order_id)
    
    return render_template('receipt.html', order=order)

@app.route('/inventory')
def inventory():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    # Use pagination for better performance
    page = request.args.get('page', 1, type=int)
    per_page = 20  # Adjust based on your needs
    
    products_paginated = Product.query.paginate(page=page, per_page=per_page, error_out=False)
    products = products_paginated.items
    
    return render_template('inventory.html', products=products, pagination=products_paginated)

@app.route('/add_inventory', methods=['GET', 'POST'])
def add_inventory():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        product_id = request.form.get('product_id')
        if not product_id:
            name = request.form['name']
            flavor = request.form['flavor']
            product = Product.query.filter_by(name=name, flavor=flavor).first()
            if not product:
                flash('ไม่พบสินค้า', 'danger')
                return redirect(url_for('add_inventory'))
            product_id = product.id
        
        try:
            quantity = int(request.form['quantity'])
            if quantity <= 0:
                flash('จำนวนต้องมากกว่า 0', 'danger')
                return redirect(url_for('add_inventory'))
        except ValueError:
            flash('กรุณากรอกจำนวนเป็นตัวเลข', 'danger')
            return redirect(url_for('add_inventory'))
        
        notes = request.form.get('notes', '')
        
        with stock_update_lock:
            product = Product.query.get_or_404(product_id)
            # บันทึกเวลาที่แม่นยำใน UTC
            current_time = datetime.datetime.now(datetime.timezone.utc)
            
            entry = InventoryEntry(
                product_id=product_id,
                quantity=quantity,
                date=current_time,
                notes=notes,
                user_id=session['user_id']  # เพิ่มการบันทึกผู้ใช้
            )
            db.session.add(entry)
            product.stock += quantity
            db.session.commit()
        
        log_activity('add_inventory', 'product', product_id, 
                    f'Added {quantity} units to {product.name} {product.flavor} by user {session["username"]}')
        flash('เพิ่มสต็อกสำเร็จ', 'success')
        return redirect(url_for('inventory'))
    
    product_id = request.args.get('product_id')
    if product_id:
        product = Product.query.get_or_404(product_id)
        return render_template('add_inventory.html', selected_product=product)
    
    return render_template('add_inventory.html')

@app.route('/inventory_history')
def inventory_history():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    page = request.args.get('page', 1, type=int)
    per_page = 20
    history_paginated = InventoryEntry.query\
        .join(Product)\
        .join(User)\
        .order_by(InventoryEntry.date.desc())\
        .paginate(page=page, per_page=per_page, error_out=False)
    history = history_paginated.items
    
    return render_template('inventory_history.html', history=history, pagination=history_paginated)

@app.route('/add_inventory_barcode', methods=['GET', 'POST'])
def add_inventory_barcode():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    return render_template('add_inventory_barcode.html')

@app.route('/api/scan_barcode', methods=['POST'])
def scan_barcode():
    if 'user_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    data = request.json
    barcode = data.get('barcode')
    
    if not barcode:
        return jsonify({'error': 'No barcode provided'}), 400
    
    product = Product.query.filter_by(barcode=barcode).first()
    
    if not product:
        return jsonify({'found': False})
    
    return jsonify({
        'found': True,
        'product': {
            'id': product.id,
            'name': product.name,
            'flavor': product.flavor,
            'price': product.price,
            'stock': product.stock
        }
    })

@app.route('/reports')
def reports():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    return render_template('reports.html')

@app.route('/reports/customer_analysis')
def customer_analysis():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    return render_template('reports/customer_analysis.html')

@app.route('/reports/sales_trend')
def sales_trend():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    return render_template('reports/sales_trend.html')

@app.route('/reports/sales', methods=['GET', 'POST'])
def sales_report():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        start_date = request.form['start_date']
        end_date = request.form['end_date']
        
        if not start_date or not end_date:
            flash('กรุณาระบุวันที่เริ่มต้นและวันที่สิ้นสุด', 'danger')
            return redirect(url_for('sales_report'))
        
        # Convert string dates to datetime
        start_date = datetime.datetime.strptime(start_date, '%Y-%m-%d').date()
        end_date = datetime.datetime.strptime(end_date, '%Y-%m-%d').date()
        
        # Get orders within date range with pagination
        page = request.args.get('page', 1, type=int)
        per_page = 50  # Adjust based on your needs
        
        orders_query = Order.query.filter(
            func.date(Order.order_date) >= start_date,
            func.date(Order.order_date) <= end_date
        ).order_by(Order.order_date.desc())
        
        orders_paginated = orders_query.paginate(page=page, per_page=per_page, error_out=False)
        orders = orders_paginated.items
        
        # Calculate totals
        total_sales = db.session.query(func.sum(Order.total_amount)).filter(
            func.date(Order.order_date) >= start_date,
            func.date(Order.order_date) <= end_date
        ).scalar() or 0
        
        total_orders = orders_query.count()
        
        # Calculate product sales
        product_sales = {}
        
        # Use a more efficient query to get all order items at once
        order_items = db.session.query(
            OrderItem.product_id,
            func.sum(OrderItem.quantity).label('quantity'),
            func.sum(OrderItem.price * OrderItem.quantity).label('amount')
        ).join(Order).filter(
            func.date(Order.order_date) >= start_date,
            func.date(Order.order_date) <= end_date
        ).group_by(OrderItem.product_id).all()
        
        # Get all products in one query
        product_ids = [item.product_id for item in order_items]
        products = {p.id: p for p in Product.query.filter(Product.id.in_(product_ids)).all()}
        
        # Calculate product sales with cost and profit
        for item in order_items:
            product = products.get(item.product_id)
            if product:
                product_name = f"{product.name} ({product.flavor})"
                cost = product.cost * float(item.quantity)
                profit = item.amount - cost
                
                product_sales[product_name] = {
                    'quantity': item.quantity,
                    'amount': item.amount,
                    'cost': cost,
                    'profit': profit
                }
        
        # Calculate total profit
        total_profit = sum(item['profit'] for item in product_sales.values())
        
        return render_template('sales_report.html', 
                              orders=orders,
                              total_sales=total_sales,
                              total_orders=total_orders,
                              total_profit=total_profit,
                              product_sales=product_sales,
                              start_date=start_date,
                              end_date=end_date,
                              pagination=orders_paginated)
    
    return render_template('sales_report.html')

@app.route('/reports/product', methods=['GET', 'POST'])
def product_report():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    products = Product.query.all()
    
    if request.method == 'POST':
        product_id = request.form['product_id']
        
        if not product_id:
            flash('กรุณาเลือกสินค้า', 'danger')
            return redirect(url_for('product_report'))
        
        product = Product.query.get_or_404(product_id)
        
        # Get orders containing this product with pagination
        page = request.args.get('page', 1, type=int)
        per_page = 20  # Adjust based on your needs
        
        orders_query = Order.query.join(OrderItem).filter(OrderItem.product_id == product_id).distinct()
        orders_paginated = orders_query.paginate(page=page, per_page=per_page, error_out=False)
        orders = orders_paginated.items
        
        # Calculate totals
        order_items = OrderItem.query.filter_by(product_id=product_id).all()
        
        total_sold = sum(item.quantity for item in order_items)
        total_revenue = sum(item.price * item.quantity for item in order_items)
        total_profit = total_revenue - (product.cost * total_sold)
        
        return render_template('product_report.html',
                              products=products,
                              product=product,
                              orders=orders,
                              total_sold=total_sold,
                              total_revenue=total_revenue,
                              total_profit=total_profit,
                              pagination=orders_paginated)
    
    return render_template('product_report.html', products=products)

@app.route('/reports/profit')
def profit_analysis():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    # Get all products
    products = Product.query.all()
    
    # Initialize variables with default values
    total_value = 0
    total_cost = 0
    total_profit_potential = 0
    sample_product = None
    top_products_by_margin = []
    top_products_by_total_profit = []
    months = []
    revenue_data = []
    cost_data = []
    profit_data = []
    
    if products:
        # Calculate total inventory value and cost
        total_value = sum(p.price * p.stock for p in products)
        total_cost = sum(p.cost * p.stock for p in products)
        total_profit_potential = total_value - total_cost
        
        # Get sample product for detailed analysis
        sample_product = products[0]
        sample_product.profit = sample_product.price - sample_product.cost
        sample_product.profit_percentage = (sample_product.profit / sample_product.price) * 100 if sample_product.price > 0 else 0
        
        # Get top products by profit margin
        top_products_by_margin = sorted(products, key=lambda p: p.profit_margin, reverse=True)[:5]
        
        # Get top products by total profit potential
        top_products_by_total_profit = sorted(products, key=lambda p: (p.price - p.cost) * p.stock, reverse=True)[:5]
        
        # Generate historical data for the chart
        months = []
        revenue_data = []
        cost_data = []
        profit_data = []
        
        # Get current date
        now = datetime.datetime.now()
        
        # Generate data for the last 6 months
        for i in range(5, -1, -1):
            # Calculate month
            month_date = now - datetime.timedelta(days=30 * i)
            month_name = month_date.strftime('%b')
            months.append(month_name)
            
            # Get start and end date for the month
            month_start = datetime.datetime(month_date.year, month_date.month, 1)
            if month_date.month == 12:
                month_end = datetime.datetime(month_date.year + 1, 1, 1) - datetime.timedelta(days=1)
            else:
                month_end = datetime.datetime(month_date.year, month_date.month + 1, 1) - datetime.timedelta(days=1)
            
            # Get orders for the month
            orders = Order.query.filter(
                Order.order_date >= month_start,
                Order.order_date <= month_end
            ).all()
            
            # Calculate revenue, cost, and profit
            month_revenue = sum(o.total_amount for o in orders)
            
            # Calculate cost and profit
            month_cost = 0
            for order in orders:
                for item in order.order_items:
                    product = Product.query.get(item.product_id)
                    if product:
                        month_cost += product.cost * item.quantity
            
            month_profit = month_revenue - month_cost
            
            revenue_data.append(month_revenue)
            cost_data.append(month_cost)
            profit_data.append(month_profit)
    
    return render_template('profit_analysis.html',
                          products=products,
                          sample_product=sample_product,
                          total_value=total_value,
                          total_cost=total_cost,
                          total_profit_potential=total_profit_potential,
                          top_products_by_margin=top_products_by_margin,
                          top_products_by_total_profit=top_products_by_total_profit,
                          months=months,
                          revenue_data=revenue_data,
                          cost_data=cost_data,
                          profit_data=profit_data)

@app.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    user = User.query.get(session['user_id'])
    
    if request.method == 'POST':
        current_password = request.form['current_password']
        new_password = request.form['new_password']
        confirm_password = request.form['confirm_password']
        
        if not check_password_hash(user.password, current_password):
            flash('รหัสผ่านปัจจุบันไม่ถูกต้อง', 'danger')
            return redirect(url_for('profile'))
        
        if new_password != confirm_password:
            flash('รหัสผ่านใหม่ไม่ตรงกัน', 'danger')
            return redirect(url_for('profile'))
        
        user.password = generate_password_hash(new_password)
        db.session.commit()
        
        log_activity('change_password')
        flash('เปลี่ยนรหัสผ่านสำเร็จ', 'success')
        return redirect(url_for('profile'))
    
    return render_template('profile.html', user=user)

@app.route('/manage_users')
def manage_users():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการจัดการผู้ใช้', 'danger')
        return redirect(url_for('dashboard'))
    
    users = User.query.all()
    
    return render_template('admin/users.html', users=users)

@app.route('/add_user', methods=['GET', 'POST'])
def add_user():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการเพิ่มผู้ใช้', 'danger')
        return redirect(url_for('dashboard'))
    
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        name = request.form.get('name', '')
        role = request.form['role']
        
        # Check if username already exists
        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            flash('ชื่อผู้ใช้นี้มีอยู่แล้ว', 'danger')
            return redirect(url_for('add_user'))
        
        user = User(
            username=username,
            password=generate_password_hash(password),
            name=name,
            role=role
        )
        
        db.session.add(user)
        db.session.commit()
        
        log_activity('add_user', 'user', user.id, f'Added user: {username}')
        flash('เพิ่มผู้ใช้สำเร็จ', 'success')
        return redirect(url_for('manage_users'))
    
    return render_template('admin/add_user.html')

@app.route('/edit_user/<int:id>', methods=['GET', 'POST'])
def edit_user(id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการแก้ไขผู้ใช้', 'danger')
        return redirect(url_for('dashboard'))
    
    user = User.query.get_or_404(id)
    
    if request.method == 'POST':
        password = request.form.get('password', '')
        name = request.form.get('name', '')
        role = request.form['role']
        
        if password:
            user.password = generate_password_hash(password)
        
        user.name = name
        user.role = role
        
        db.session.commit()
        
        log_activity('edit_user', 'user', user.id, f'Edited user: {user.username}')
        flash('แก้ไขผู้ใช้สำเร็จ', 'success')
        return redirect(url_for('manage_users'))
    
    return render_template('admin/edit_user.html', user=user)

@app.route('/delete_user/<int:id>', methods=['POST'])
def delete_user(id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการลบผู้ใช้', 'danger')
        return redirect(url_for('dashboard'))
    
    if id == session['user_id']:
        flash('คุณไม่สามารถลบบัญชีของตัวเองได้', 'danger')
        return redirect(url_for('manage_users'))
    
    user = User.query.get_or_404(id)
    
    log_activity('delete_user', 'user', user.id, f'Deleted user: {user.username}')
    
    db.session.delete(user)
    db.session.commit()
    
    flash('ลบผู้ใช้สำเร็จ', 'success')
    return redirect(url_for('manage_users'))

@app.route('/storefront_sale', methods=['GET', 'POST'])
def storefront_sale():
    if request.method == 'POST':
        # Get form data
        customer_name = request.form.get('customer_name', 'Walk-in Customer')
        customer_phone = request.form.get('customer_phone', '')
        payment_method = request.form.get('payment_method', 'cash')
        notes = request.form.get('notes', '')
        
        # Add payment method to notes
        payment_notes = f"Payment Method: {payment_method}"
        if notes:
            combined_notes = f"{notes}\n{payment_notes}"
        else:
            combined_notes = payment_notes
        
        # Get product data
        product_ids = request.form.getlist('product_id[]')
        quantities = request.form.getlist('quantity[]')
        
        # Validate data
        if not product_ids or not quantities or len(product_ids) != len(quantities):
            flash('กรุณาเลือกสินค้าและระบุจำนวนให้ถูกต้อง', 'danger')
            return redirect(url_for('storefront_sale'))
        
        # Create or get customer
        customer = Customer.query.filter_by(name=customer_name).first()
        if not customer:
            customer = Customer(name=customer_name, phone=customer_phone)
            db.session.add(customer)
            db.session.flush()  # Get ID without committing
        
        # Create order with correct datetime usage
        from datetime import datetime, timezone
        current_time = datetime.now(timezone.utc)
        
        order = Order(
            customer_id=customer.id,
            order_date=current_time,
            status='completed',
            payment_status='paid',
            notes=combined_notes
        )
        db.session.add(order)
        db.session.flush()  # Get order ID
        
        total_amount = 0
        
        # Process each product
        for i in range(len(product_ids)):
            if not product_ids[i] or not quantities[i]:
                continue
                
            product_id = int(product_ids[i])
            quantity = int(quantities[i])
            
            if quantity <= 0:
                continue
                
            # Get product
            product = Product.query.get(product_id)
            if not product or product.stock < quantity:
                flash(f'สินค้า {product.name if product else "ไม่ทราบ"} มีไม่เพียงพอ', 'danger')
                continue
                
            # Create order item
            order_item = OrderItem(
                order_id=order.id,
                product_id=product_id,
                quantity=quantity,
                price=product.price
            )
            db.session.add(order_item)
            
            # Update product stock
            product.stock -= quantity
            
            # Create inventory entry - with correct datetime and without user_id
            inventory_entry = InventoryEntry(
                product_id=product_id,
                quantity=-quantity,  # Negative for sales
                date=current_time,
                notes=f'Storefront Sale - Order #{order.id}'
                # No user_id parameter
            )
            db.session.add(inventory_entry)
            
            # Add to total
            total_amount += product.price * quantity
        
        # Update order total
        order.total_amount = total_amount
        
        # Commit all changes
        try:
            db.session.commit()
            flash('บันทึกการขายเรียบร้อยแล้ว', 'success')
            return redirect(url_for('view_order', id=order.id))
        except Exception as e:
            db.session.rollback()
            flash(f'เกิดข้อผิดพลาด: {str(e)}', 'danger')
    
    # GET request - show form
    products = Product.query.filter(Product.stock > 0).all()
    return render_template('storefront_sale.html', products=products)

@app.route('/backup_data')
def backup_data():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการสำรองข้อมูล', 'danger')
        return redirect(url_for('dashboard'))
    
    # สร้างไดเรกทอรีสำรองข้อมูลถ้ายังไม่มี
    backup_dir = os.path.join(app.config['UPLOAD_FOLDER'], 'backups')  # จะได้ static/backups
    os.makedirs(backup_dir, exist_ok=True)
    
    # สร้างไฟล์สำรองฐานข้อมูล
    timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    db_backup_filename = f'db_backup_{timestamp}.sql'
    db_backup_path = os.path.join(backup_dir, db_backup_filename)
    
    # สำหรับ MySQL/MariaDB
    backup_success = False
    if 'mysql' in app.config['SQLALCHEMY_DATABASE_URI']:
        import subprocess
        db_name = 'marbo9k'  # ชื่อฐานข้อมูลจาก URI
        try:
            # คำสั่ง mysqldump (จัดการกรณีที่ไม่มีรหัสผ่าน)
            cmd = ['mysqldump', '-u', 'root', '-p', db_name]
            with open(db_backup_path, 'w', encoding='utf-8') as f:
                subprocess.run(cmd, stdout=f, check=True, text=True)
            backup_success = True
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            flash('ไม่สามารถใช้ mysqldump ได้ กำลังสำรองข้อมูลด้วยวิธีสำรอง', 'warning')
            print(f"mysqldump error: {e}")
            
            # ใช้ SQLAlchemy ดึงข้อมูลเป็น SQL แทน
            try:
                with open(db_backup_path, 'w', encoding='utf-8') as f:
                    # ดึงโครงสร้างตารางและข้อมูล
                    tables = ['user', 'customer', 'product', 'order', 'order_item', 'inventory_entry', 'activity_log', 'notification', 'settings']
                    for table in tables:
                        # สร้างคำสั่ง CREATE TABLE
                        result = db.session.execute(text(f"SHOW CREATE TABLE `{table}`"))
                        create_table_stmt = result.fetchone()[1]
                        f.write(f"{create_table_stmt};\n\n")
                        
                        # ดึงข้อมูลทั้งหมด
                        result = db.session.execute(text(f"SELECT * FROM `{table}`"))
                        for row in result:
                            # แก้ไขส่วนนี้: ย้ายการหนีอักขระออกจาก f-string
                            values = []
                            for v in row:
                                if v is None:
                                    values.append('NULL')
                                else:
                                    # หนีอักขระ single quote ก่อน แล้วค่อยใส่ในสตริง
                                    escaped_value = str(v).replace("'", "''")  # MySQL ใช้ '' เพื่อหนี '
                                    values.append(f"'{escaped_value}'")
                            values_str = ','.join(values)
                            f.write(f"INSERT INTO `{table}` VALUES ({values_str});\n")
                        f.write("\n")
                backup_success = True
            except Exception as e:
                flash(f'เกิดข้อผิดพลาดในการสำรองข้อมูลด้วย SQLAlchemy: {str(e)}', 'danger')
                print(f"SQLAlchemy backup error: {e}")
                return redirect(url_for('dashboard'))
    else:
        # สำหรับ SQLite (กรณีทดสอบ)
        try:
            db_path = app.config['SQLALCHEMY_DATABASE_URI'].replace('sqlite:///', '')
            shutil.copy2(db_path, db_backup_path)
            backup_success = True
        except Exception as e:
            flash(f'เกิดข้อผิดพลาดในการสำรองฐานข้อมูล SQLite: {str(e)}', 'danger')
            print(f"SQLite backup error: {e}")
            return redirect(url_for('dashboard'))
    
    # สร้างไฟล์ Excel
    excel_filename = f'data_export_{timestamp}.xlsx'
    excel_path = os.path.join(backup_dir, excel_filename)
    
    # สร้าง Excel writer
    try:
        with pd.ExcelWriter(excel_path, engine='xlsxwriter') as writer:
            # ส่งออกข้อมูลสินค้า
            products = pd.read_sql_query("SELECT * FROM product", db.engine)
            products.to_excel(writer, sheet_name='Products', index=False)
            
            # ส่งออกข้อมูลลูกค้า
            customers = pd.read_sql_query("SELECT * FROM customer", db.engine)
            customers.to_excel(writer, sheet_name='Customers', index=False)
            
            # ส่งออกข้อมูลคำสั่งซื้อ
            orders = pd.read_sql_query("SELECT * FROM `order`", db.engine)
            orders.to_excel(writer, sheet_name='Orders', index=False)
            
            # ส่งออกข้อมูลรายการสั่งซื้อ
            order_items = pd.read_sql_query("SELECT * FROM order_item", db.engine)
            order_items.to_excel(writer, sheet_name='Order Items', index=False)
            
            # ส่งออกข้อมูลคลังสินค้า
            inventory = pd.read_sql_query("SELECT * FROM inventory_entry", db.engine)
            inventory.to_excel(writer, sheet_name='Inventory', index=False)
            
            # ส่งออกข้อมูลผู้ใช้
            users = pd.read_sql_query("SELECT * FROM user", db.engine)
            users.to_excel(writer, sheet_name='Users', index=False)
            
            # ส่งออกข้อมูลบันทึกกิจกรรม
            activity_logs = pd.read_sql_query("SELECT * FROM activity_log", db.engine)
            activity_logs.to_excel(writer, sheet_name='Activity Logs', index=False)
            
            # ส่งออกข้อมูลการแจ้งเตือน
            notifications = pd.read_sql_query("SELECT * FROM notification", db.engine)
            notifications.to_excel(writer, sheet_name='Notifications', index=False)
            
            # ส่งออกข้อมูลการตั้งค่า
            settings = pd.read_sql_query("SELECT * FROM settings", db.engine)
            settings.to_excel(writer, sheet_name='Settings', index=False)
    except Exception as e:
        flash(f'เกิดข้อผิดพลาดในการสร้างไฟล์ Excel: {str(e)}', 'danger')
        print(f"Excel export error: {e}")
        return redirect(url_for('dashboard'))
    
    log_activity('backup_data', details=f'Created backup: {db_backup_filename} and {excel_filename}')
    
    if backup_success:
        flash('สำรองข้อมูลสำเร็จ', 'success')
    return render_template('admin/backup.html', db_backup=f'backups/{db_backup_filename}', excel_export=f'backups/{excel_filename}')

@app.route('/download_backup/<path:filename>')
def download_backup(filename):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการดาวน์โหลดไฟล์สำรอง', 'danger')
        return redirect(url_for('dashboard'))
    
    return send_file(os.path.join(app.config['UPLOAD_FOLDER'], filename), as_attachment=True)

@app.route('/settings', methods=['GET', 'POST'])
def settings():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการตั้งค่าระบบ', 'danger')
        return redirect(url_for('dashboard'))
    
    settings = Settings.query.first()
    if not settings:
        settings = Settings(
            company_name='Marbo 9k Shop',
            company_address='123 ถนนสุขุมวิท, กรุงเทพฯ 10110',
            company_phone='099-999-9999',
            company_email='info@marbo9k.com',
            low_stock_threshold=10
        )
        db.session.add(settings)
        db.session.commit()
    
    if request.method == 'POST':
        settings.company_name = request.form['company_name']
        settings.company_address = request.form['company_address']
        settings.company_phone = request.form['company_phone']
        settings.company_email = request.form['company_email']
        settings.low_stock_threshold = int(request.form['low_stock_threshold'])
        
        # Handle logo upload
        if 'company_logo' in request.files and request.files['company_logo'].filename:
            file = request.files['company_logo']
            
            # Validate file type
            if not allowed_file(file.filename):
                flash('รูปแบบไฟล์ไม่ถูกต้อง กรุณาอัปโหลดไฟล์รูปภาพเท่านั้น (JPG, PNG, GIF)', 'danger')
                return redirect(url_for('settings'))
            
            # Validate file size
            if file.content_length and file.content_length > MAX_CONTENT_LENGTH:
                flash('ขนาดไฟล์ใหญ่เกินไป กรุณาอัปโหลดไฟล์ขนาดไม่เกิน 16MB', 'danger')
                return redirect(url_for('settings'))
            
            # Delete old logo if exists
            if settings.company_logo:
                delete_file(settings.company_logo)
            
            # Save new logo
            settings.company_logo = save_file(file, 'logos')
        
        db.session.commit()
        
        log_activity('update_settings', details='Updated system settings')
        flash('บันทึกการตั้งค่าสำเร็จ', 'success')
        return redirect(url_for('settings'))
    
    return render_template('admin/settings.html', settings=settings)

@app.route('/activity_logs')
def activity_logs():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการดูบันทึกกิจกรรม', 'danger')
        return redirect(url_for('dashboard'))
    
    # Use pagination for better performance
    page = request.args.get('page', 1, type=int)
    per_page = 50  # Adjust based on your needs
    
    logs_paginated = ActivityLog.query.order_by(ActivityLog.timestamp.desc()).paginate(page=page, per_page=per_page, error_out=False)
    logs = logs_paginated.items
    
    return render_template('admin/activity_logs.html', logs=logs, pagination=logs_paginated)

@app.route('/notifications')
def notifications():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    # Use pagination for better performance
    page = request.args.get('page', 1, type=int)
    per_page = 20  # Adjust based on your needs
    
    notifications_paginated = Notification.query.filter_by(user_id=session['user_id']).order_by(Notification.created_at.desc()).paginate(page=page, per_page=per_page, error_out=False)
    notifications = notifications_paginated.items
    
    # Mark all as read
    for notification in notifications:
        notification.is_read = True
    
    db.session.commit()
    
    return render_template('notifications.html', notifications=notifications, pagination=notifications_paginated)

@app.route('/api/activity_logs')
def api_activity_logs():
    if 'user_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    if session.get('role') != 'admin':
        return jsonify({'error': 'Permission denied'}), 403
    
    # Get filter parameters
    user_id = request.args.get('user_id', type=int)
    action_type = request.args.get('action_type')
    date_from = request.args.get('date_from')
    date_to = request.args.get('date_to')
    
    # Build query
    query = ActivityLog.query
    
    if user_id:
        query = query.filter(ActivityLog.user_id == user_id)
    
    if action_type:
        query = query.filter(ActivityLog.action == action_type)
    
    if date_from:
        date_from = datetime.datetime.strptime(date_from, '%Y-%m-%d')
        query = query.filter(ActivityLog.timestamp >= date_from)
    
    if date_to:
        date_to = datetime.datetime.strptime(date_to, '%Y-%m-%d')
        date_to = date_to + datetime.timedelta(days=1)  # Include the end date
        query = query.filter(ActivityLog.timestamp < date_to)
    
    # Paginate results
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 50, type=int)
    
    logs_paginated = query.order_by(ActivityLog.timestamp.desc()).paginate(
        page=page, per_page=per_page, error_out=False
    )
    
    # Format logs for JSON response
    logs = []
    for log in logs_paginated.items:
        logs.append({
            'id': log.id,
            'user': log.user.username if log.user else None,
            'action': log.action,
            'entity_type': log.entity_type,
            'entity_id': log.entity_id,
            'details': log.details,
            'ip_address': log.ip_address,
            'timestamp': log.timestamp.strftime('%Y-%m-%d %H:%M:%S')
        })
    
    return jsonify({
        'logs': logs,
        'total': logs_paginated.total,
        'pages': logs_paginated.pages,
        'current_page': logs_paginated.page
    })


@app.route('/api/customer_analysis')
def api_customer_analysis():
    if 'user_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    # Get top customers by total spent
    top_customers_query = db.session.query(
        Customer.id,
        Customer.name,
        func.count(Order.id).label('order_count'),
        func.sum(Order.total_amount).label('total_spent'),
        func.max(Order.order_date).label('last_order_date')
    ).join(Order).group_by(Customer.id).order_by(func.sum(Order.total_amount).desc()).limit(10)
    
    top_customers = []
    for c in top_customers_query.all():
        top_customers.append({
            'id': c.id,
            'name': c.name,
            'order_count': c.order_count,
            'total_spent': float(c.total_spent) if c.total_spent else 0,
            'last_order_date': c.last_order_date.strftime('%Y-%m-%d') if c.last_order_date else None
        })
    
    # Get inactive customers (haven't ordered in 30 days)
    thirty_days_ago = datetime.datetime.now() - datetime.timedelta(days=30)
    
    inactive_customers_query = db.session.query(
        Customer.id,
        Customer.name,
        func.max(Order.order_date).label('last_order_date'),
        func.sum(Order.total_amount).label('total_spent')
    ).join(Order).group_by(Customer.id).having(
        func.max(Order.order_date) < thirty_days_ago
    ).order_by(func.max(Order.order_date)).limit(10)
    
    inactive_customers = []
    for c in inactive_customers_query.all():
        inactive_customers.append({
            'id': c.id,
            'name': c.name,
            'last_order_date': c.last_order_date.strftime('%Y-%m-%d') if c.last_order_date else None,
            'total_spent': float(c.total_spent) if c.total_spent else 0
        })
    
    # Calculate customer distribution
    # Regular: ordered more than once in last 30 days
    # Casual: ordered once in last 30 days
    # New: first order in last 30 days
    # Inactive: no orders in last 30 days
    
    # Get all customers with their last order date
    customer_stats = db.session.query(
        Customer.id,
        func.count(Order.id).label('order_count'),
        func.max(Order.order_date).label('last_order_date'),
        func.min(Order.order_date).label('first_order_date')
    ).outerjoin(Order).group_by(Customer.id).all()
    
    regular_count = 0
    casual_count = 0
    new_count = 0
    inactive_count = 0
    
    for stat in customer_stats:
        if not stat.last_order_date:
            # No orders
            continue
            
        if stat.last_order_date >= thirty_days_ago:
            # Active in last 30 days
            if stat.first_order_date >= thirty_days_ago:
                # First order in last 30 days
                new_count += 1
            elif stat.order_count > 1:
                # Multiple orders
                regular_count += 1
            else:
                # Single order
                casual_count += 1
        else:
            # No orders in last 30 days
            inactive_count += 1
    
    customer_distribution = [regular_count, casual_count, new_count, inactive_count]
    
    # Calculate purchase frequency
    purchase_frequency = [0, 0, 0, 0, 0]  # [1, 2-3, 4-6, 7-12, >12]
    
    for stat in customer_stats:
        if not stat.order_count:
            continue
            
        if stat.order_count == 1:
            purchase_frequency[0] += 1
        elif 2 <= stat.order_count <= 3:
            purchase_frequency[1] += 1
        elif 4 <= stat.order_count <= 6:
            purchase_frequency[2] += 1
        elif 7 <= stat.order_count <= 12:
            purchase_frequency[3] += 1
        else:
            purchase_frequency[4] += 1
    
    return jsonify({
        'top_customers': top_customers,
        'inactive_customers': inactive_customers,
        'customer_distribution': customer_distribution,
        'purchase_frequency': purchase_frequency
    })

@app.route('/api/sales_trend')
def api_sales_trend():
    if 'user_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    # Get daily sales data for the last 30 days
    end_date = datetime.datetime.now().date()
    start_date = end_date - datetime.timedelta(days=29)  # 30 days including today
    
    daily_dates = []
    daily_sales = []
    
    current_date = start_date
    while current_date <= end_date:
        daily_dates.append(current_date.strftime('%Y-%m-%d'))
        
        # Get sales for this day
        day_sales = db.session.query(func.sum(Order.total_amount)).filter(
            func.date(Order.order_date) == current_date
        ).scalar() or 0
        
        daily_sales.append(float(day_sales))
        current_date += datetime.timedelta(days=1)
    
    # Get sales by day of week (แก้ไขจาก strftime เป็น DAYOFWEEK)
    weekday_sales = [0] * 7  # Monday to Sunday
    
    # DAYOFWEEK: 1=Sunday, 2=Monday, ..., 7=Saturday
    weekday_data = db.session.query(
        func.dayofweek(Order.order_date).label('weekday'),
        func.avg(Order.total_amount).label('avg_sales')
    ).group_by(func.dayofweek(Order.order_date)).all()
    
    for day in weekday_data:
        if day.weekday is not None:
            # Convert DAYOFWEEK (1=Sun, 2=Mon) to Monday=0 format
            idx = (int(day.weekday) - 2) % 7
            weekday_sales[idx] = float(day.avg_sales or 0)
    
    # Get sales by hour of day (แก้ไขจาก strftime เป็น HOUR)
    hourly_sales = [0] * 24
    
    hourly_data = db.session.query(
        func.hour(Order.order_date).label('hour'),
        func.avg(Order.total_amount).label('avg_sales')
    ).group_by(func.hour(Order.order_date)).all()
    
    for hour in hourly_data:
        if hour.hour is not None:
            hourly_sales[int(hour.hour)] = float(hour.avg_sales or 0)
    
    # Generate forecast data (เหมือนเดิม)
    today = datetime.datetime.now()
    
    forecast_dates = []
    actual_sales = []
    forecast_sales = []
    
    # Past 6 months + current month
    for i in range(6, -1, -1):
        month_date = today.replace(day=1) - datetime.timedelta(days=30 * i)
        month_name = month_date.strftime('%b %Y')
        forecast_dates.append(month_name)
        
        month_start = month_date.replace(day=1)
        if month_date.month == 12:
            month_end = month_date.replace(year=month_date.year + 1, month=1, day=1) - datetime.timedelta(days=1)
        else:
            month_end = month_date.replace(month=month_date.month + 1, day=1) - datetime.timedelta(days=1)
        
        month_sales = db.session.query(func.sum(Order.total_amount)).filter(
            Order.order_date >= month_start,
            Order.order_date <= month_end
        ).scalar() or 0
        
        actual_sales.append(float(month_sales))
    
    # Future 5 months (forecast)
    for i in range(1, 6):
        month_date = today.replace(day=1) + datetime.timedelta(days=30 * i)
        month_name = month_date.strftime('%b %Y')
        forecast_dates.append(month_name)
        actual_sales.append(None)
    
    # Simple forecast: average of last 3 months with slight growth
    last_3_months_avg = sum([s for s in actual_sales[-3:] if s is not None]) / 3
    growth_rate = 0.05  # 5% monthly growth
    
    # Add forecasts for all months
    for i in range(len(forecast_dates)):
        if i < len(actual_sales) and actual_sales[i] is not None:
            forecast_sales.append(None)
        else:
            forecast = last_3_months_avg * (1 + growth_rate) ** (i - 6)
            forecast_sales.append(float(forecast))
    
    forecast_next_month = last_3_months_avg * (1 + growth_rate)
    current_month_sales = actual_sales[-1] if actual_sales[-1] is not None else 0
    forecast_change_percentage = ((forecast_next_month - current_month_sales) / current_month_sales * 100) if current_month_sales > 0 else 0
    
    # Get top products for forecast
    top_products = db.session.query(
        Product.id,
        Product.name,
        Product.flavor,
        func.sum(OrderItem.quantity).label('total_sold')
    ).join(OrderItem).join(Order).filter(
        Order.order_date >= today - datetime.timedelta(days=90)
    ).group_by(Product.id).order_by(func.sum(OrderItem.quantity).desc()).limit(5).all()
    
    forecast_top_products = []
    for product in top_products:
        forecast_top_products.append({
            'id': product.id,
            'name': product.name,
            'flavor': product.flavor
        })
    
    return jsonify({
        'daily_dates': daily_dates,
        'daily_sales': daily_sales,
        'weekday_sales': weekday_sales,
        'hourly_sales': hourly_sales,
        'forecast_dates': forecast_dates,
        'actual_sales': actual_sales,
        'forecast_sales': forecast_sales,
        'forecast_next_month': float(forecast_next_month),
        'forecast_change_percentage': float(forecast_change_percentage),
        'forecast_top_products': forecast_top_products
    })

@app.route('/api/notifications/unread')
def unread_notifications():
    if 'user_id' not in session:
        return jsonify({'error': 'Unauthorized'}), 401
    
    # Get unread notifications
    notifications = Notification.query.filter_by(user_id=session['user_id'], is_read=False).order_by(Notification.created_at.desc()).limit(5).all()
    
    # Count total unread
    count = Notification.query.filter_by(user_id=session['user_id'], is_read=False).count()
    
    # Format notifications
    formatted_notifications = []
    for notification in notifications:
        formatted_notifications.append({
            'id': notification.id,
            'message': notification.message,
            'type': notification.type,
            'related_id': notification.related_id,
            'created_at': notification.created_at.strftime('%d/%m/%Y %H:%M')
        })
    
    return jsonify({
        'count': count,
        'notifications': formatted_notifications
    })

@app.route('/api/check_payment_status/<int:order_id>')
def check_payment_status(order_id):
    order = Order.query.get_or_404(order_id)
    
    return jsonify({
        'status': 'paid' if order.payment_status == 'paid' else 'pending'
    })

@app.route('/upload_slip/<int:id>', methods=['GET', 'POST'])
def upload_slip(id):
    order = Order.query.get_or_404(id)
    
    if request.method == 'POST':
        # Handle payment slip upload
        if 'payment_slip' in request.files and request.files['payment_slip'].filename:
            file = request.files['payment_slip']
            
            # Validate file type
            if not allowed_file(file.filename):
                flash('รูปแบบไฟล์ไม่ถูกต้อง กรุณาอัปโหลดไฟล์รูปภาพเท่านั้น (JPG, PNG, GIF)', 'danger')
                return redirect(url_for('upload_slip', id=id))
            
            # Validate file size
            if file.content_length and file.content_length > MAX_CONTENT_LENGTH:
                flash('ขนาดไฟล์ใหญ่เกินไป กรุณาอัปโหลดไฟล์ขนาดไม่เกิน 16MB', 'danger')
                return redirect(url_for('upload_slip', id=id))
            
            # Delete old slip if exists
            if order.payment_slip:
                delete_file(order.payment_slip)
            
            # Save new slip
            payment_slip = save_file(file, 'slips')
            order.payment_slip = payment_slip
            order.payment_date = datetime.datetime.now()
            order.payment_status = 'paid'
            
            # Get location
            location = request.form.get('location', '')
            if location:
                order.pickup_location = location
            
            db.session.commit()
            
            # Create notification
            create_notification(f'มีการชำระเงินสำหรับคำสั่งซื้อ #{order.id} จากลูกค้า {order.customer.name}', 'payment', order.id)
            
            flash('อัปโหลดสลิปสำเร็จ', 'success')
            return redirect(url_for('receipt', order_id=id))
    
    has_slip = bool(order.payment_slip)
    has_location = bool(order.pickup_location)
    
    return render_template('upload_slip_and_location.html', order=order, has_slip=has_slip, has_location=has_location)


#Manage interface website 
# ตรวจสอบว่ามีการตั้งค่าร้านค้าหรือไม่ ถ้าไม่มีให้สร้างใหม่
def get_shop_settings():
    settings = ShopSettings.query.first()
    if not settings:
        settings = ShopSettings()
        db.session.add(settings)
        db.session.commit()
    return settings

# หน้าจัดการร้านค้า
@app.route('/shop_editor')
def shop_editor():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if session.get('role') != 'admin':
        flash('คุณไม่มีสิทธิ์ในการจัดการหน้าร้านค้า', 'danger')
        return redirect(url_for('dashboard'))
    
    # ดึงข้อมูลการตั้งค่าร้านค้า
    shop_settings = get_shop_settings()
    
    # ดึงข้อมูลแบนเนอร์
    banners = Banner.query.all()
    
    # ดึงข้อมูลสินค้าทั้งหมด
    products = Product.query.all()
    
    # ดึงข้อมูลสินค้าแนะนำ
    featured_products = FeaturedProduct.query.order_by(FeaturedProduct.position).all()
    featured_product_ids = [fp.product_id for fp in featured_products]
    
    return render_template('shop_editor.html', 
                          shop_settings=shop_settings,
                          banners=banners,
                          products=products,
                          featured_product_ids=featured_product_ids)

# อัปเดตส่วนหัวของร้านค้า
@app.route('/update_shop_hero', methods=['POST'])
def update_shop_hero():
    if 'user_id' not in session or session.get('role') != 'admin':
        return redirect(url_for('login'))
    
    shop_settings = get_shop_settings()
    
    shop_settings.hero_title = request.form['hero_title']
    shop_settings.hero_subtitle = request.form.get('hero_subtitle', '')
    shop_settings.hero_text_color = request.form['hero_text_color']
    shop_settings.hero_button_text = request.form.get('hero_button_text', '')
    
    # จัดการอัปโหลดภาพพื้นหลัง
    if 'hero_background' in request.files and request.files['hero_background'].filename:
        # ลบภาพเก่าถ้ามี
        if shop_settings.hero_background:
            delete_file(shop_settings.hero_background)
        
        # บันทึกภาพใหม่
        hero_background = save_file(request.files['hero_background'], 'shop')
        if hero_background:
            shop_settings.hero_background = hero_background
    
    db.session.commit()
    
    log_activity('update_shop_hero', details='Updated shop hero section')
    flash('อัปเดตส่วนหัวของร้านค้าสำเร็จ', 'success')
    return redirect(url_for('shop_editor'))

# อัปเดตธีมและสีของร้านค้า
@app.route('/update_shop_theme', methods=['POST'])
def update_shop_theme():
    if 'user_id' not in session or session.get('role') != 'admin':
        return redirect(url_for('login'))
    
    shop_settings = get_shop_settings()
    
    shop_settings.primary_color = request.form['primary_color']
    shop_settings.secondary_color = request.form['secondary_color']
    shop_settings.accent_color = request.form['accent_color']
    shop_settings.text_color = request.form['text_color']
    shop_settings.font_family = request.form['font_family']
    shop_settings.border_radius = int(request.form['border_radius'])
    
    db.session.commit()
    
    log_activity('update_shop_theme', details='Updated shop theme settings')
    flash('อัปเดตธีมและสีของร้านค้าสำเร็จ', 'success')
    return redirect(url_for('shop_editor'))

# อัปเดตส่วนท้ายของร้านค้า
@app.route('/update_shop_footer', methods=['POST'])
def update_shop_footer():
    if 'user_id' not in session or session.get('role') != 'admin':
        return redirect(url_for('login'))
    
    shop_settings = get_shop_settings()
    
    shop_settings.footer_text = request.form['footer_text']
    shop_settings.contact_phone = request.form.get('contact_phone', '')
    shop_settings.contact_email = request.form.get('contact_email', '')
    shop_settings.social_facebook = request.form.get('social_facebook', '')
    shop_settings.social_instagram = request.form.get('social_instagram', '')
    shop_settings.social_line = request.form.get('social_line', '')
    
    db.session.commit()
    
    log_activity('update_shop_footer', details='Updated shop footer settings')
    flash('อัปเดตส่วนท้ายของร้านค้าสำเร็จ', 'success')
    return redirect(url_for('shop_editor'))

# เพิ่มแบนเนอร์
@app.route('/add_banner', methods=['POST'])
def add_banner():
    if 'user_id' not in session or session.get('role') != 'admin':
        return redirect(url_for('login'))
    
    title = request.form['banner_title']
    link = request.form.get('banner_link', '')
    position = request.form['banner_position']
    is_active = 'banner_active' in request.form
    
    # จัดการอัปโหลดภาพแบนเนอร์
    if 'banner_image' not in request.files or not request.files['banner_image'].filename:
        flash('กรุณาอัปโหลดรูปภาพแบนเนอร์', 'danger')
        return redirect(url_for('shop_editor'))
    
    image_path = save_file(request.files['banner_image'], 'banners')
    if not image_path:
        flash('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ', 'danger')
        return redirect(url_for('shop_editor'))
    
    banner = Banner(
        title=title,
        image_path=image_path,
        link=link,
        position=position,
        is_active=is_active
    )
    
    db.session.add(banner)
    db.session.commit()
    
    log_activity('add_banner', details=f'Added banner: {title}')
    flash('เพิ่มแบนเนอร์สำเร็จ', 'success')
    return redirect(url_for('shop_editor'))

# ลบแบนเนอร์
@app.route('/delete_banner', methods=['POST'])
def delete_banner():
    if 'user_id' not in session or session.get('role') != 'admin':
        return redirect(url_for('login'))
    
    banner_id = request.form['banner_id']
    banner = Banner.query.get_or_404(banner_id)
    
    # ลบไฟล์รูปภาพ
    if banner.image_path:
        delete_file(banner.image_path)
    
    db.session.delete(banner)
    db.session.commit()
    
    log_activity('delete_banner', details=f'Deleted banner: {banner.title}')
    flash('ลบแบนเนอร์สำเร็จ', 'success')
    return redirect(url_for('shop_editor'))

# อัปเดตสินค้าแนะนำ
@app.route('/update_featured_products', methods=['POST'])
def update_featured_products():
    if 'user_id' not in session or session.get('role') != 'admin':
        return redirect(url_for('login'))
    
    # อัปเดตการตั้งค่าสินค้าแนะนำ
    shop_settings = get_shop_settings()
    shop_settings.featured_title = request.form['featured_title']
    shop_settings.featured_subtitle = request.form.get('featured_subtitle', '')
    
    # ลบสินค้าแนะนำเดิมทั้งหมด
    FeaturedProduct.query.delete()
    
    # เพิ่มสินค้าแนะนำใหม่
    featured_product_ids = request.form.getlist('featured_products[]')
    for i, product_id in enumerate(featured_product_ids):
        featured_product = FeaturedProduct(
            product_id=product_id,
            position=i
        )
        db.session.add(featured_product)
    
    db.session.commit()
    
    log_activity('update_featured_products', details='Updated featured products')
    flash('อัปเดตสินค้าแนะนำสำเร็จ', 'success')
    return redirect(url_for('shop_editor'))

# แก้ไขหน้า shop.html เพื่อใช้การตั้งค่าจากฐานข้อมูล
@app.route('/shop')
def shop():
    # ดึงการตั้งค่าร้านค้า
    shop_settings = get_shop_settings()
    
    # ดึงแบนเนอร์ที่เปิดใช้งาน
    top_banners = Banner.query.filter_by(position='top', is_active=True).all()
    middle_banners = Banner.query.filter_by(position='middle', is_active=True).all()
    bottom_banners = Banner.query.filter_by(position='bottom', is_active=True).all()
    
    # ดึงสินค้าแนะนำ
    featured_products_query = FeaturedProduct.query.order_by(FeaturedProduct.position)
    featured_products = [fp.product for fp in featured_products_query.all() if fp.product.stock > 0]
    
    # ดึงสินค้าทั้งหมดที่มีในสต็อก
    page = request.args.get('page', 1, type=int)
    per_page = 20
    products_paginated = Product.query.filter(Product.stock > 0).paginate(page=page, per_page=per_page, error_out=False)
    products = products_paginated.items
    
    return render_template('shop.html', 
                          shop_settings=shop_settings,
                          top_banners=top_banners,
                          middle_banners=middle_banners,
                          bottom_banners=bottom_banners,
                          featured_products=featured_products,
                          products=products,
                          pagination=products_paginated)


#orderfunction 
@app.route('/shop/order', methods=['POST'])
def shop_order():
    if request.method == 'POST':
        customer_name = request.form['customer_name']
        customer_phone = request.form['customer_phone']
        shipping_address = request.form['shipping_address']
        
        # Check if customer exists
        customer = Customer.query.filter_by(phone=customer_phone).first()
        if not customer:
            # Create new customer
            customer = Customer(
                name=customer_name,
                phone=customer_phone,
                address=shipping_address
            )
            db.session.add(customer)
            db.session.flush()  # Get customer ID without committing
        
        # Create new order
        order = Order(
            customer_id=customer.id,
            shipping_address=shipping_address
        )
        
        db.session.add(order)
        db.session.flush()  # Get order ID without committing
        
        # Process order items
        product_ids = request.form.getlist('product_id[]')
        quantities = request.form.getlist('quantity[]')
        
        total_amount = 0
        has_items = False
        
        for i in range(len(product_ids)):
            product_id = int(product_ids[i])
            quantity = int(quantities[i])
            
            if quantity <= 0:
                continue
            
            has_items = True
            
            # Get product with lock to prevent race conditions
            with stock_update_lock:
                product = Product.query.get(product_id)
                
                if not product:
                    continue
                
                # Check if enough stock
                if product.stock < quantity:
                    flash(f'สินค้า {product.name} {product.flavor} มีไม่เพียงพอ (มี {product.stock} ชิ้น)', 'danger')
                    db.session.rollback()
                    return redirect(url_for('shop'))
                
                # Create order item
                order_item = OrderItem(
                    order_id=order.id,
                    product_id=product_id,
                    quantity=quantity,
                    price=product.price
                )
                
                db.session.add(order_item)
                
                # Update product stock
                product.stock -= quantity
                
                # Update total amount
                total_amount += product.price * quantity
        
        if not has_items:
            flash('กรุณาเลือกสินค้าอย่างน้อย 1 รายการ', 'danger')
            db.session.rollback()
            return redirect(url_for('shop'))
        
        # Handle payment slip upload
        payment_slip = None
        if 'payment_slip' in request.files and request.files['payment_slip'].filename:
            file = request.files['payment_slip']
            
            # Validate file type
            if not allowed_file(file.filename):
                flash('รูปแบบไฟล์ไม่ถูกต้อง กรุณาอัปโหลดไฟล์รูปภาพเท่านั้น (JPG, PNG, GIF)', 'danger')
                db.session.rollback()
                return redirect(url_for('shop'))
            
            # Validate file size
            if file.content_length and file.content_length > MAX_CONTENT_LENGTH:
                flash('ขนาดไฟล์ใหญ่เกินไป กรุณาอัปโหลดไฟล์ขนาดไม่เกิน 16MB', 'danger')
                db.session.rollback()
                return redirect(url_for('shop'))
            
            payment_slip = save_file(file, 'slips')
            order.payment_slip = payment_slip
            order.payment_date = datetime.datetime.now()
            order.payment_status = 'paid'
        
        # Update order total
        order.total_amount = total_amount
        
        # Generate QR code for payment
        qr_code_path = generate_qr_code(order.id)
        order.qr_code_path = qr_code_path
        
        db.session.commit()
        
        # Create notification
        create_notification(f'มีคำสั่งซื้อใหม่ #{order.id} จากลูกค้า {customer.name}', 'new_order', order.id)
        
        # Generate QR code for display
        qr_code_base64 = generate_qr_code_base64(order.id)
        
        flash('สั่งซื้อสำเร็จ', 'success')
        return render_template('shop_success.html', order=order, qr_code=qr_code_base64)
    
    return redirect(url_for('shop'))

# Error handlers
@app.errorhandler(404)
def page_not_found(e):
    return render_template('errors/404.html'), 404

@app.errorhandler(500)
def internal_server_error(e):
    return render_template('errors/500.html'), 500

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        
        # Create admin user if not exists
        admin = User.query.filter_by(username='admin').first()
        if not admin:
            admin = User(
                username='admin',
                password=generate_password_hash('admin'),
                role='admin'
            )
            db.session.add(admin)
            db.session.commit()
    
    app.run(debug=True)

# เพิ่มโค้ดนี้ต่อท้ายไฟล์ app.py เดิม

# นำเข้าโมเดลและเส้นทางสำหรับการจัดการหน้าร้านค้า
#from shop_models import ShopSettings, Banner, FeaturedProduct
#rom shop_models import ShopSettings, Banner, FeaturedProduct
#from shop_routes import *

# เพิ่มเมนูจัดการหน้าร้านค้าใน base.html
@app.context_processor
def inject_shop_editor_menu():
    def is_admin():
        return session.get('role') == 'admin'
    return dict(is_admin=is_admin)

# เพิ่มเส้นทางสำหรับการจัดการหน้าร้านค้า
#from shop_routes import *

# สร้างตารางฐานข้อมูลสำหรับการจัดการหน้าร้านค้า
with app.app_context():
    db.create_all()
    
    # สร้างการตั้งค่าร้านค้าเริ่มต้นถ้ายังไม่มี
    shop_settings = ShopSettings.query.first()
    if not shop_settings:
        shop_settings = ShopSettings()
        db.session.add(shop_settings)
        db.session.commit()

app.run(debug=True)