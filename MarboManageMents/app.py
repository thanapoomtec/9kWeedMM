from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, session
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
from datetime import datetime
import os

app = Flask(__name__)
app.config['SECRET_KEY'] = 'marbo9ksecretkey'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///marbo9k.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = 'static/uploads'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max upload

# สร้างโฟลเดอร์สำหรับอัปโหลดถ้ายังไม่มี
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# โมเดลสำหรับผู้ใช้งาน
class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(200), nullable=False)
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
        
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

# โมเดลสำหรับสินค้า
class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    flavor = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    price = db.Column(db.Float, default=380.0)
    cost = db.Column(db.Float, default=310.0)
    stock = db.Column(db.Integer, default=0)
    image_path = db.Column(db.String(200))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

# โมเดลสำหรับลูกค้า
class Customer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    phone = db.Column(db.String(20))
    address = db.Column(db.Text)
    line_id = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    orders = db.relationship('Order', backref='customer', lazy=True)

# โมเดลสำหรับคำสั่งซื้อ
class Order(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    customer_id = db.Column(db.Integer, db.ForeignKey('customer.id'), nullable=False)
    order_date = db.Column(db.DateTime, default=datetime.utcnow)  # บันทึกเวลาโดยอัตโนมัติ
    total_amount = db.Column(db.Float, default=0.0)
    payment_slip = db.Column(db.String(200))
    payment_date = db.Column(db.DateTime)
    shipping_address = db.Column(db.Text)
    notes = db.Column(db.Text)
    
    order_items = db.relationship('OrderItem', backref='order', lazy=True, cascade="all, delete-orphan")
# โมเดลสำหรับรายการสินค้าในคำสั่งซื้อ
class OrderItem(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('order.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    quantity = db.Column(db.Integer, default=1)
    price = db.Column(db.Float)
    
    product = db.relationship('Product')

# โมเดลสำหรับการนำเข้าสินค้า
class Inventory(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    quantity = db.Column(db.Integer, default=0)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    notes = db.Column(db.Text)
    
    product = db.relationship('Product')

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# ฟังก์ชันสำหรับสร้างตารางและข้อมูลเริ่มต้น
def init_db():
    with app.app_context():
        db.create_all()
        if not User.query.first():
            admin = User(username='admin')
            admin.set_password('admin123')
            db.session.add(admin)
            
            flavors = [
                {'name': 'Marbo 9k', 'flavor': 'Grape', 'price': 380, 'cost': 310},
                {'name': 'Marbo 9k', 'flavor': 'Blue Ice', 'price': 380, 'cost': 310},
                {'name': 'Marbo 9k', 'flavor': 'Cola', 'price': 380, 'cost': 310},
                {'name': 'Marbo 9k', 'flavor': 'Strawberry', 'price': 380, 'cost': 310},
                {'name': 'Marbo 9k', 'flavor': 'Watermelon', 'price': 380, 'cost': 310}
            ]
            for flavor_info in flavors:
                product = Product(name=flavor_info['name'], flavor=flavor_info['flavor'], 
                                price=flavor_info['price'], cost=flavor_info['cost'], stock=10)
                db.session.add(product)
            
            db.session.commit()

# เส้นทางหลัก
@app.route('/', methods=['GET'])
def index():
    if current_user.is_authenticated:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        user = User.query.filter_by(username=username).first()
        
        if user and user.check_password(password):
            login_user(user)
            return redirect(url_for('dashboard'))
        else:
            flash('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง', 'error')
    
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

# Route Dashboard
@app.route('/dashboard')
@login_required
def dashboard():
    total_sales = db.session.query(db.func.sum(Order.total_amount)).scalar() or 0
    pending_orders = Order.query.filter(Order.payment_slip.is_(None)).count()
    low_stock_products = Product.query.filter(Product.stock < 10).count()
    total_profit = calculate_total_profit()
    recent_orders = Order.query.order_by(Order.order_date.desc()).limit(5).all()
    
    return render_template('dashboard.html', 
                           total_sales=total_sales,
                           pending_orders=pending_orders,
                           low_stock_products=low_stock_products,
                           total_profit=total_profit,
                           recent_orders=recent_orders)

# Route สำหรับดึงข้อมูล Real-time และ Historical Data
@app.route('/dashboard/realtime-data')
@login_required
def realtime_data():
    try:
        # ยอดขายวันนี้ (Real-time)
        today = datetime.utcnow().date()
        today_sales = db.session.query(db.func.sum(Order.total_amount))\
            .filter(db.func.date(Order.order_date) == today).scalar() or 0
        
        # ยอดขายรายชั่วโมงในวันนี้
        hourly_sales = db.session.query(
            db.func.strftime('%H', Order.order_date).label('hour'),
            db.func.sum(Order.total_amount).label('amount')
        ).filter(db.func.date(Order.order_date) == today)\
         .group_by(db.func.strftime('%H', Order.order_date))\
         .all()
        
        # ยอดขายรายเดือน (Historical Data)
        monthly_sales = db.session.query(
            db.func.strftime('%Y-%m', Order.order_date).label('month'),
            db.func.sum(Order.total_amount).label('amount')
        ).group_by(db.func.strftime('%Y-%m', Order.order_date))\
         .order_by(db.func.strftime('%Y-%m', Order.order_date))\
         .all()
        
        # จำนวนสินค้าที่ขายไปทั้งหมด
        total_units_sold = db.session.query(db.func.sum(OrderItem.quantity)).scalar() or 0
        
        # สินค้าขายดี (Top 5 พร้อมจำนวนหน่วยที่ขาย)
        top_products = db.session.query(
            Product.name, Product.flavor, db.func.sum(OrderItem.quantity).label('quantity')
        ).join(OrderItem).join(Order)\
         .group_by(Product.id, Product.name, Product.flavor)\
         .order_by(db.func.sum(OrderItem.quantity).desc())\
         .limit(5).all()
        
        return jsonify({
            'today_sales': float(today_sales),
            'hourly_sales': [{'hour': f"{int(hour):02d}:00", 'amount': float(amount or 0)} for hour, amount in hourly_sales],
            'monthly_sales': [{'month': month, 'amount': float(amount or 0)} for month, amount in monthly_sales],
            'total_units_sold': int(total_units_sold),
            'top_products': [{'name': f"{name} ({flavor})", 'quantity': int(quantity or 0)} for name, flavor, quantity in top_products]
        })
    except Exception as e:
        print(f"Error in realtime_data: {str(e)}")
        return jsonify({'error': str(e)}), 500

def calculate_total_profit():
    profit = 0
    orders = Order.query.all()
    for order in orders:
        for item in order.order_items:
            if item.product and hasattr(item.product, 'cost'):
                profit += (item.price - item.product.cost) * item.quantity
            else:
                print(f"Warning: Missing product or cost for OrderItem ID: {item.id}, Product ID: {item.product_id}")
    return profit

# Route Shop
@app.route('/shop', methods=['GET', 'POST'])
def shop():
    products_list = Product.query.all()
    if request.method == 'POST':
        customer_name = request.form.get('customer_name')
        shipping_address = request.form.get('shipping_address')
        product_ids = request.form.getlist('product_id[]')
        quantities = request.form.getlist('quantity[]')
        
        customer = Customer.query.filter_by(name=customer_name).first()
        if not customer:
            customer = Customer(name=customer_name, address=shipping_address)
            db.session.add(customer)
            db.session.flush()
        
        new_order = Order(customer_id=customer.id, shipping_address=shipping_address)
        db.session.add(new_order)
        db.session.flush()
        
        total_amount = 0
        for i in range(len(product_ids)):
            if product_ids[i] and quantities[i] and int(quantities[i]) > 0:
                product_id = int(product_ids[i])
                quantity = int(quantities[i])
                product = Product.query.get(product_id)
                if product and product.stock >= quantity:
                    order_item = OrderItem(order_id=new_order.id, product_id=product_id, quantity=quantity, price=product.price)
                    db.session.add(order_item)
                    product.stock -= quantity
                    total_amount += product.price * quantity
                else:
                    db.session.rollback()
                    flash(f'สินค้า {product.flavor if product else "ไม่ระบุ"} มีไม่เพียงพอ (คงเหลือ {product.stock if product else 0})', 'error')
                    return redirect(url_for('shop'))
        
        new_order.total_amount = total_amount
        if 'payment_slip' in request.files:
            payment_slip = request.files['payment_slip']
            if payment_slip.filename != '':
                filename = secure_filename(f"slip_{new_order.id}_{datetime.utcnow().strftime('%Y%m%d%H%M%S')}.jpg")
                slip_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                payment_slip.save(slip_path)
                new_order.payment_slip = os.path.join('uploads', filename).replace(os.sep, '/')
                new_order.payment_date = datetime.utcnow()
        
        db.session.commit()
        flash('ยืนยันการสั่งซื้อสำเร็จ', 'success')
        return redirect(url_for('shop_success', order_id=new_order.id))
    
    return render_template('shop.html', products=products_list)

@app.route('/shop/success/<int:order_id>')
def shop_success(order_id):
    order = Order.query.get_or_404(order_id)
    return render_template('shop_success.html', order=order)


@app.route('/dashboard/chart-data')
@login_required
def chart_data():
    sales_data = db.session.query(Order.order_date, db.func.sum(Order.total_amount))\
        .group_by(db.func.strftime('%Y-%m', Order.order_date))\
        .all()
    
    top_products = db.session.query(Product.name, Product.flavor, db.func.sum(OrderItem.quantity))\
        .join(OrderItem).join(Order)\
        .group_by(Product.id, Product.name, Product.flavor)\
        .order_by(db.func.sum(OrderItem.quantity).desc())\
        .limit(5).all()
    
    return jsonify({
        'sales': [{'month': date.strftime('%Y-%m'), 'amount': float(amount or 0)} for date, amount in sales_data],
        'top_products': [{'name': f"{name} ({flavor})", 'quantity': int(quantity or 0)} for name, flavor, quantity in top_products]
    })

# Products
@app.route('/products')
@login_required
def products():
    products_list = Product.query.all()
    return render_template('products.html', products=products_list)

@app.route('/product/add', methods=['GET', 'POST'])
@login_required
def add_product():
    if request.method == 'POST':
        name = request.form.get('name')
        flavor = request.form.get('flavor')
        description = request.form.get('description')
        price = float(request.form.get('price', 380.0))
        cost = float(request.form.get('cost', 310.0))
        stock = int(request.form.get('stock', 0))
        
        image_path = None
        if 'image' in request.files:
            image = request.files['image']
            if image.filename != '':
                filename = secure_filename(image.filename)
                image_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                image.save(image_path)
                image_path = os.path.join('uploads', filename).replace(os.sep, '/')
        
        new_product = Product(
            name=name, flavor=flavor, description=description,
            price=price, cost=cost, stock=stock, image_path=image_path
        )
        
        db.session.add(new_product)
        db.session.commit()
        flash('เพิ่มสินค้าสำเร็จ', 'success')
        return redirect(url_for('products'))
    return render_template('add_product.html')

@app.route('/product/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_product(id):
    product = Product.query.get_or_404(id)
    if request.method == 'POST':
        product.name = request.form.get('name')
        product.flavor = request.form.get('flavor')
        product.description = request.form.get('description')
        product.price = float(request.form.get('price', 380.0))
        product.cost = float(request.form.get('cost', 310.0))
        product.stock = int(request.form.get('stock', 0))
        
        if 'image' in request.files:
            image = request.files['image']
            if image.filename != '':
                filename = secure_filename(image.filename)
                image_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                image.save(image_path)
                product.image_path = os.path.join('uploads', filename).replace(os.sep, '/')
        
        db.session.commit()
        flash('อัปเดตสินค้าสำเร็จ', 'success')
        return redirect(url_for('products'))
    return render_template('edit_product.html', product=product)

@app.route('/product/delete/<int:id>', methods=['POST'])
@login_required
def delete_product(id):
    product = Product.query.get_or_404(id)
    try:
        db.session.delete(product)
        db.session.commit()
        flash('ลบสินค้าสำเร็จ', 'success')
    except:
        db.session.rollback()
        flash('ไม่สามารถลบสินค้าได้ เนื่องจากมีข้อมูลที่เกี่ยวข้อง', 'error')
    return redirect(url_for('products'))

# Customers
@app.route('/customers')
@login_required
def customers():
    customers_list = Customer.query.all()
    return render_template('customers.html', customers=customers_list)

@app.route('/customer/add', methods=['GET', 'POST'])
@login_required
def add_customer():
    if request.method == 'POST':
        name = request.form.get('name')
        phone = request.form.get('phone')
        address = request.form.get('address')
        line_id = request.form.get('line_id')
        
        new_customer = Customer(name=name, phone=phone, address=address, line_id=line_id)
        db.session.add(new_customer)
        db.session.commit()
        flash('เพิ่มลูกค้าสำเร็จ', 'success')
        return redirect(url_for('customers'))
    return render_template('add_customer.html')

@app.route('/customer/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_customer(id):
    customer = Customer.query.get_or_404(id)
    if request.method == 'POST':
        customer.name = request.form.get('name')
        customer.phone = request.form.get('phone')
        customer.address = request.form.get('address')
        customer.line_id = request.form.get('line_id')
        db.session.commit()
        flash('อัปเดตข้อมูลลูกค้าสำเร็จ', 'success')
        return redirect(url_for('customers'))
    return render_template('edit_customer.html', customer=customer)

@app.route('/customer/view/<int:id>')
@login_required
def view_customer(id):
    customer = Customer.query.get_or_404(id)
    orders = Order.query.filter_by(customer_id=customer.id).order_by(Order.order_date.desc()).all()
    return render_template('view_customer.html', customer=customer, orders=orders)

# Orders
@app.route('/orders')
@login_required
def orders():
    orders_list = Order.query.order_by(Order.order_date.desc()).all()
    return render_template('orders.html', orders=orders_list)

@app.route('/order/add', methods=['GET', 'POST'])
@login_required
def add_order():
    customers_list = Customer.query.all()
    products_list = Product.query.all()
    if request.method == 'POST':
        customer_id = request.form.get('customer_id')
        shipping_address = request.form.get('shipping_address')
        notes = request.form.get('notes')
        
        new_order = Order(customer_id=customer_id, shipping_address=shipping_address, notes=notes)
        db.session.add(new_order)
        db.session.flush()
        
        total_amount = 0
        product_ids = request.form.getlist('product_id[]')
        quantities = request.form.getlist('quantity[]')
        
        for i in range(len(product_ids)):
            if product_ids[i] and quantities[i]:
                product_id = int(product_ids[i])
                quantity = int(quantities[i])
                product = Product.query.get(product_id)
                
                if product.stock >= quantity:
                    order_item = OrderItem(order_id=new_order.id, product_id=product_id, quantity=quantity, price=product.price)
                    db.session.add(order_item)
                    product.stock -= quantity
                    total_amount += product.price * quantity
                else:
                    db.session.rollback()
                    flash(f'สินค้า {product.name} ({product.flavor}) มีไม่เพียงพอ', 'error')
                    return redirect(url_for('add_order'))
        
        new_order.total_amount = total_amount
        if 'payment_slip' in request.files:
            payment_slip = request.files['payment_slip']
            if payment_slip.filename != '':
                filename = secure_filename(f"slip_{new_order.id}_{datetime.utcnow().strftime('%Y%m%d%H%M%S')}.jpg")
                slip_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                payment_slip.save(slip_path)
                new_order.payment_slip = os.path.join('uploads', filename).replace(os.sep, '/')
                new_order.payment_date = datetime.utcnow()
        
        db.session.commit()
        flash('เพิ่มคำสั่งซื้อสำเร็จ', 'success')
        return redirect(url_for('orders'))
    return render_template('add_order.html', customers=customers_list, products=products_list)

@app.route('/order/view/<int:id>')
@login_required
def view_order(id):
    order = Order.query.get_or_404(id)
    return render_template('view_order.html', order=order)

@app.route('/order/update_payment/<int:id>', methods=['POST'])
@login_required
def update_payment(id):
    order = Order.query.get_or_404(id)
    if 'payment_slip' in request.files:
        payment_slip = request.files['payment_slip']
        if payment_slip.filename != '':
            filename = secure_filename(f"slip_{order.id}_{datetime.utcnow().strftime('%Y%m%d%H%M%S')}.jpg")
            slip_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            payment_slip.save(slip_path)
            order.payment_slip = os.path.join('uploads', filename).replace(os.sep, '/')
            order.payment_date = datetime.utcnow()
            db.session.commit()
            flash('อัปโหลดสลิปสำเร็จ', 'success')
    return redirect(url_for('view_order', id=id))

# Inventory
@app.route('/inventory')
@login_required
def inventory():
    products_list = Product.query.all()
    return render_template('inventory.html', products=products_list)

@app.route('/inventory/add', methods=['GET', 'POST'])
@login_required
def add_inventory():
    if request.method == 'POST':
        name = request.form.get('name')
        flavor = request.form.get('flavor')
        price = float(request.form.get('price', 0.0))
        cost = float(request.form.get('cost', 0.0))
        quantity = int(request.form.get('quantity', 0))
        notes = request.form.get('notes', '')
        
        if not all([name, flavor, quantity > 0]):
            flash('กรุณากรอกข้อมูลให้ครบถ้วน (ชื่อ, รสชาติ, และจำนวนต้องมากกว่า 0)', 'error')
            return redirect(url_for('add_inventory'))
        
        product = Product.query.filter_by(name=name, flavor=flavor).first()
        if not product:
            product = Product(name=name, flavor=flavor, price=price, cost=cost, stock=0)
            db.session.add(product)
            db.session.flush()
        
        product.stock += quantity
        inventory_entry = Inventory(product_id=product.id, quantity=quantity, notes=notes)
        db.session.add(inventory_entry)
        db.session.commit()
        flash('เพิ่มสต็อกสินค้าสำเร็จ', 'success')
        return redirect(url_for('inventory'))
    
    return render_template('add_inventory.html')

@app.route('/inventory/history')
@login_required
def inventory_history():
    history = Inventory.query.order_by(Inventory.date.desc()).all()
    return render_template('inventory_history.html', history=history)

# Reports
@app.route('/reports')
@login_required
def reports():
    return render_template('reports.html')

@app.route('/report/sales', methods=['GET', 'POST'])
@login_required
def sales_report():
    if request.method == 'POST':
        start_date = request.form.get('start_date')
        end_date = request.form.get('end_date')
        
        start_date = datetime.strptime(start_date, '%Y-%m-%d') if start_date else datetime(1900, 1, 1)
        end_date = datetime.strptime(end_date + ' 23:59:59', '%Y-%m-%d %H:%M:%S') if end_date else datetime.utcnow()
        
        orders = Order.query.filter(Order.order_date.between(start_date, end_date)).all()
        
        total_sales = sum(order.total_amount for order in orders)
        total_orders = len(orders)
        
        product_sales = {}
        for order in orders:
            for item in order.order_items:
                product_name = f"{item.product.name} ({item.product.flavor})"
                if product_name not in product_sales:
                    product_sales[product_name] = {'quantity': 0, 'amount': 0, 'cost': 0, 'profit': 0}
                product_sales[product_name]['quantity'] += item.quantity
                product_sales[product_name]['amount'] += item.price * item.quantity
                product_sales[product_name]['cost'] += item.product.cost * item.quantity
                product_sales[product_name]['profit'] += (item.price - item.product.cost) * item.quantity
        
        total_cost = sum(product_sales[product]['cost'] for product in product_sales)
        total_profit = sum(product_sales[product]['profit'] for product in product_sales)
        
        return render_template(
            'sales_report.html', orders=orders, total_sales=total_sales, total_orders=total_orders,
            product_sales=product_sales, total_cost=total_cost, total_profit=total_profit,
            start_date=start_date.strftime('%Y-%m-%d'), end_date=end_date.strftime('%Y-%m-%d')
        )
    return render_template('sales_report.html')

@app.route('/report/product', methods=['GET', 'POST'])
@login_required
def product_report():
    if request.method == 'POST':
        product_id = request.form.get('product_id')
        product = Product.query.get(product_id)
        order_items = OrderItem.query.filter_by(product_id=product_id).all()
        
        orders = []
        for item in order_items:
            if item.order not in orders:
                orders.append(item.order)
        
        total_sold = sum(item.quantity for item in order_items)
        total_revenue = sum(item.price * item.quantity for item in order_items)
        total_cost = product.cost * total_sold
        total_profit = total_revenue - total_cost
        
        return render_template(
            'product_report.html', product=product, orders=orders, total_sold=total_sold,
            total_revenue=total_revenue, total_cost=total_cost, total_profit=total_profit
        )
    products_list = Product.query.all()
    return render_template('product_report.html', products=products_list)

# รันแอป
if __name__ == '__main__':
    init_db()
    app.run(debug=True)