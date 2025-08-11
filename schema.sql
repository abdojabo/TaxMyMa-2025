-- إنشاء جدول المستخدمين
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL
);

-- إنشاء جدول الفواتير
CREATE TABLE invoices (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  invoice_number VARCHAR(50) NOT NULL,
  invoice_date DATE NOT NULL,
  ht DECIMAL(12,2) NOT NULL,
  tva_rate DECIMAL(4,2) NOT NULL,
  tva DECIMAL(12,2) NOT NULL,
  ttc DECIMAL(12,2) NOT NULL
);

-- فهرس لتحسين الأداء
CREATE INDEX idx_invoices_user ON invoices(user_id);
