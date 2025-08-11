const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(express.json());

let invoices = [];
let users = [{ id: 1, email: 'admin@taxmyma.ma', password: 'admin123' }];

// تسجيل الدخول
app.post('/api/login', (req, res) => {
  const { email, password } = req.body;
  const user = users.find(u => u.email === email && u.password === password);
  if (user) res.json({ success: true, user });
  else res.status(401).json({ success: false, message: 'خطأ في الدخول' });
});

// حفظ فاتورة
app.post('/api/invoices', (req, res) => {
  const invoice = { id: Date.now(), ...req.body, createdAt: new Date().toISOString() };
  invoices.push(invoice);
  res.status(201).json(invoice);
});

// جلب الفواتير
app.get('/api/invoices', (req, res) => {
  res.json(invoices);
});

// تقرير TVA بصيغة XML
app.get('/api/reports/tva/xml', (req, res) => {
  const totalHT = invoices.reduce((sum, i) => sum + i.ht, 0);
  const totalTVA = invoices.reduce((sum, i) => sum + i.tva, 0);
  const ttc = totalHT + totalTVA;

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<TVA_Declaration xmlns="http://www.tax.gov.ma/xml/tva/2025">
  <IdentifiantFiscal>123456789</IdentifiantFiscal>
  <ICE>12345678901234</ICE>
  <Periode>2025-01</Periode>
  <TotalHT>${totalHT.toFixed(2)}</TotalHT>
  <TotalTVA>${totalTVA.toFixed(2)}</TotalTVA>
  <TotalTTC>${ttc.toFixed(2)}</TotalTTC>
  <Devise>MAD</Devise>
</TVA_Declaration>`;
  res.type('application/xml');
  res.send(xml);
});

app.listen(3000, () => {
  console.log('🚀 الخادم يعمل على http://localhost:3000');
});
