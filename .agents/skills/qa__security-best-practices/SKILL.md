---
name: security-best-practices
description: Implement security best practices covering HTTPS, input validation, authentication, OWASP Top 10 vulnerabilities, and secure coding. Use this skill when building secure applications, hardening infrastructure, preventing vulnerabilities, implementing authentication, or reviewing code for security issues. Use when requested "secure the app", "fix security issues", "implement authentication", or "prevent vulnerabilities".
compatibility:
  - Web applications (Express, Django, Rails, Laravel)
  - REST APIs, GraphQL
  - Database systems (SQL, NoSQL)
  - Cloud infrastructure (AWS, GCP, Azure)
  - All programming languages
---

# Security Best Practices Skill

Comprehensive skill for implementing security controls and preventing vulnerabilities in applications.

## Overview

This skill covers **6 core security principles**:
1. **HTTPS & Security Headers** — Encrypt traffic, set security headers
2. **Input Validation & Output Encoding** — Prevent injection attacks
3. **Rate Limiting & DDoS Protection** — Protect against brute force and DoS
4. **CSRF Protection** — Prevent cross-site request forgery
5. **Secret Management** — Store credentials safely
6. **Authentication & Authorization** — Secure user access

## Core Security Principles

### 1. HTTPS & Security Headers

Enforce HTTPS in production and implement security headers.

**MUST DO:**
- ✓ HTTPS mandatory in production
- ✓ Implement Helmet middleware (Express.js)
- ✓ Set Content-Security-Policy (CSP)
- ✓ Enable HSTS with preload

**Example (Express.js):**
```javascript
const helmet = require('helmet');

app.use(helmet());

// Custom CSP
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'", "'unsafe-inline'"],
    styleSrc: ["'self'", "'unsafe-inline'"],
    imgSrc: ["'self'", "data:", "https:"],
  }
}));

// HSTS
app.use(helmet.hsts({
  maxAge: 31536000,     // 1 year
  includeSubDomains: true,
  preload: true
}));
```

**Security Headers to Set:**
| Header | Purpose |
|--------|---------|
| `X-Content-Type-Options: nosniff` | Prevent MIME type sniffing |
| `X-Frame-Options: DENY` | Prevent clickjacking |
| `X-XSS-Protection: 1; mode=block` | Prevent XSS attacks |
| `Strict-Transport-Security` | Enforce HTTPS |
| `Content-Security-Policy` | Control allowed resources |

---

### 2. Input Validation & Output Encoding

Validate all input and encode output to prevent injection attacks.

**MUST DO:**
- ✓ Validate all user input
- ✓ Use schema validation (Joi, Yup, Zod)
- ✓ Use parameterized queries
- ✓ Encode output before rendering

**Example: Input Validation (Joi)**
```javascript
const schema = Joi.object({
  email: Joi.string()
    .email()
    .required(),
  password: Joi.string()
    .min(8)
    .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .required(),
  age: Joi.number()
    .integer()
    .min(18)
    .max(120)
});

app.post('/register', (req, res) => {
  const { error, value } = schema.validate(req.body);
  
  if (error) {
    return res.status(400).json({
      error: 'Validation failed',
      details: error.details
    });
  }
  
  // Use validated value
  registerUser(value);
});
```

**Example: Prevent SQL Injection**
```javascript
// ✗ VULNERABLE
const query = `SELECT * FROM users WHERE email = '${email}'`;
db.query(query);

// ✓ SAFE - Parameterized query
const query = 'SELECT * FROM users WHERE email = ?';
db.query(query, [email]);

// ✓ SAFE - ORM
const user = await User.findOne({ email });
```

**Example: Prevent XSS**
```javascript
// ✗ VULNERABLE
app.get('/profile/:id', (req, res) => {
  const user = getUser(req.params.id);
  res.send(`<h1>${user.name}</h1>`);  // XSS risk
});

// ✓ SAFE - Use templating engine
app.get('/profile/:id', (req, res) => {
  const user = getUser(req.params.id);
  res.render('profile', { user });
});

// Template (EJS)
<h1><%= user.name %></h1>  <!-- Auto-escaped -->

// ✓ SAFE - Explicit encoding (client-side)
const userName = document.createElement('h1');
userName.textContent = user.name;  // textContent is safe
document.body.appendChild(userName);
```

---

### 3. Rate Limiting & DDoS Protection

Protect against brute force and denial of service attacks.

**MUST DO:**
- ✓ Implement rate limiting
- ✓ Use tiered approach (different limits for different endpoints)
- ✓ Implement account lockout for failed login
- ✓ Monitor for suspicious activity

**Example: Rate Limiting (Express)**
```javascript
const rateLimit = require('express-rate-limit');

// General API rate limiter
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,    // 15 minutes
  max: 100,                      // 100 requests per windowMs
  message: 'Too many requests, please try again later',
  standardHeaders: true,         // Return rate limit info in the `RateLimit-*` headers
  legacyHeaders: false,
});

// Strict limiter for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,    // 15 minutes
  max: 5,                        // 5 attempts per windowMs
  skipSuccessfulRequests: true,  // Don't count successful requests
  message: 'Too many login attempts, please try again later'
});

app.use('/api/', generalLimiter);        // Apply to all API routes
app.post('/auth/login', authLimiter, handleLogin);
app.post('/auth/register', authLimiter, handleRegister);
```

**Rate Limiting Strategy:**
| Endpoint | Limit | Window |
|----------|-------|--------|
| `/api/*` | 100 requests | 15 minutes |
| `/auth/login` | 5 attempts | 15 minutes |
| `/auth/register` | 5 attempts | 15 minutes |
| `/api/password-reset` | 3 attempts | 1 hour |

---

### 4. CSRF Protection

Prevent cross-site request forgery attacks.

**MUST DO:**
- ✓ Implement token-based CSRF protection
- ✓ Use SameSite cookie attribute
- ✓ Validate origin header
- ✓ Require token for state-changing requests (POST, PUT, DELETE)

**Example: CSRF Protection (Express)**
```javascript
const csrf = require('csurf');
const cookieParser = require('cookie-parser');
const session = require('express-session');

app.use(cookieParser());
app.use(session({ secret: 'your-secret-key' }));

const csrfProtection = csrf({ cookie: false });

// Generate CSRF token
app.get('/form', csrfProtection, (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});

// Validate CSRF token on POST
app.post('/form', csrfProtection, (req, res) => {
  // Token is automatically validated
  res.json({ success: true });
});
```

**HTML Form (with CSRF token):**
```html
<form method="POST" action="/form">
  <input type="hidden" name="_csrf" value="<%= csrfToken %>">
  <input type="email" name="email" required>
  <button type="submit">Submit</button>
</form>
```

**SameSite Cookie Attribute:**
```javascript
app.use(session({
  cookie: {
    secure: true,           // HTTPS only
    httpOnly: true,         // No JavaScript access
    sameSite: 'strict'      // Prevent CSRF
  }
}));
```

---

### 5. Secret Management

Store sensitive data safely, never hardcode credentials.

**MUST DO:**
- ✓ Use environment variables for secrets
- ✓ Use .env files in development only
- ✓ Never commit .env to version control
- ✓ Use secrets manager in production (AWS Secrets Manager, Vault)
- ✓ Rotate secrets regularly

**.env File (Development Only)**
```
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
JWT_SECRET=your-super-secret-key-do-not-use-in-production
API_KEY=sk_live_abc123xyz
STRIPE_SECRET_KEY=sk_test_123456
```

**.gitignore**
```
.env
.env.local
.env.*.local
```

**Code: Using Environment Variables**
```javascript
// ✓ SAFE - Use environment variables
const dbUrl = process.env.DATABASE_URL;
const jwtSecret = process.env.JWT_SECRET;

if (!dbUrl || !jwtSecret) {
  throw new Error('Missing required environment variables');
}

const database = new Database(dbUrl);
const jwtService = new JwtService(jwtSecret);
```

**Production: Use Secrets Manager**
```javascript
// AWS Secrets Manager
const AWS = require('aws-sdk');
const secretsManager = new AWS.SecretsManager();

async function getSecret(secretName) {
  const data = await secretsManager.getSecretValue({
    SecretId: secretName
  }).promise();
  
  return JSON.parse(data.SecretString);
}

const dbUrl = await getSecret('prod/database-url');
```

---

### 6. Authentication & Authorization

Implement secure authentication and proper authorization.

**MUST DO:**
- ✓ Use strong authentication (JWT, OAuth, SAML)
- ✓ Hash passwords with bcrypt (min 12 rounds)
- ✓ Implement refresh token rotation
- ✓ Use short-lived access tokens (15 minutes)
- ✓ Implement authorization checks on all protected routes
- ✓ Support multi-factor authentication (MFA)

**Example: JWT with Refresh Token**
```javascript
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

// Hash password on registration
async function hashPassword(password) {
  return bcrypt.hash(password, 12);
}

// Verify password on login
async function verifyPassword(password, hash) {
  return bcrypt.compare(password, hash);
}

// Generate access token (short-lived)
function generateAccessToken(user) {
  return jwt.sign(
    { id: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: '15m' }
  );
}

// Generate refresh token (long-lived)
function generateRefreshToken(user) {
  return jwt.sign(
    { id: user.id },
    process.env.JWT_REFRESH_SECRET,
    { expiresIn: '7d' }
  );
}

// Login endpoint
app.post('/auth/login', async (req, res) => {
  const { email, password } = req.body;
  
  const user = await User.findOne({ email });
  if (!user) return res.status(401).json({ error: 'Invalid credentials' });
  
  const validPassword = await verifyPassword(password, user.passwordHash);
  if (!validPassword) return res.status(401).json({ error: 'Invalid credentials' });
  
  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);
  
  // Store refresh token in database
  await RefreshToken.create({ userId: user.id, token: refreshToken });
  
  res.json({ accessToken, refreshToken });
});

// Refresh token endpoint
app.post('/auth/refresh', async (req, res) => {
  const { refreshToken } = req.body;
  
  try {
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    
    // Verify token exists in database
    const storedToken = await RefreshToken.findOne({
      userId: decoded.id,
      token: refreshToken
    });
    
    if (!storedToken) {
      return res.status(401).json({ error: 'Invalid refresh token' });
    }
    
    const user = await User.findById(decoded.id);
    const newAccessToken = generateAccessToken(user);
    const newRefreshToken = generateRefreshToken(user);
    
    // Invalidate old refresh token
    await RefreshToken.deleteOne({ token: refreshToken });
    // Store new refresh token
    await RefreshToken.create({ userId: user.id, token: newRefreshToken });
    
    res.json({ accessToken: newAccessToken, refreshToken: newRefreshToken });
  } catch (error) {
    res.status(401).json({ error: 'Invalid refresh token' });
  }
});

// Protected route middleware
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) return res.status(401).json({ error: 'No token provided' });
  
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ error: 'Invalid token' });
    req.user = user;
    next();
  });
}

// Protected route
app.get('/api/profile', authenticateToken, (req, res) => {
  // User is authenticated
  res.json({ profile: req.user });
});
```

---

## OWASP Top 10 Vulnerabilities

### A01: Broken Access Control
**What:** Unauthorized access to protected resources

**Prevention:**
- ✓ Implement role-based access control (RBAC)
- ✓ Check authorization on every route
- ✓ Use principle of least privilege

```javascript
function checkRole(requiredRole) {
  return (req, res, next) => {
    if (req.user.role !== requiredRole) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    next();
  };
}

app.delete('/users/:id', authenticateToken, checkRole('admin'), deleteUser);
```

### A02: Cryptographic Failures
**What:** Sensitive data exposed due to weak encryption

**Prevention:**
- ✓ Use HTTPS for all traffic
- ✓ Encrypt data at rest
- ✓ Encrypt data in transit
- ✓ Use strong algorithms (AES-256, TLS 1.2+)

### A03: Injection
**What:** Attackers inject malicious code into queries

**Prevention:**
- ✓ Use parameterized queries
- ✓ Input validation
- ✓ Avoid eval() and similar functions
- ✓ Use ORMs with protection

### A04: Insecure Design
**What:** Missing security controls during design phase

**Prevention:**
- ✓ Design security in from the start
- ✓ Threat modeling
- ✓ Security requirements in specifications
- ✓ Secure coding standards

### A05: Misconfiguration
**What:** Default credentials, unnecessary services enabled

**Prevention:**
- ✓ Change default credentials
- ✓ Remove unnecessary services
- ✓ Secure server configuration
- ✓ Regular security audits

### A06: Vulnerable Components
**What:** Using libraries with known vulnerabilities

**Prevention:**
- ✓ Keep dependencies updated
- ✓ Regular `npm audit` or `pip check`
- ✓ Monitor security advisories
- ✓ Remove unused dependencies

```bash
# Check for vulnerabilities
npm audit
npm audit fix

# Update dependencies
npm update
npm outdated
```

### A07: Authentication Failures
**What:** Weak passwords, missing MFA, session hijacking

**Prevention:**
- ✓ Enforce strong passwords
- ✓ Implement MFA
- ✓ Secure session management
- ✓ Protect against brute force

### A08: Data Integrity Failures
**What:** Modification of data without detection

**Prevention:**
- ✓ CSRF protection
- ✓ Signature verification
- ✓ Database constraints
- ✓ Audit logging

### A09: Logging & Monitoring Failures
**What:** No visibility into security events

**Prevention:**
- ✓ Log security events
- ✓ Monitor suspicious activity
- ✓ Set up alerts
- ✓ Regular log review

```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  defaultMeta: { service: 'user-service' },
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

// Log security events
logger.warn('Failed login attempt', { email, ip: req.ip });
logger.error('Unauthorized access attempt', { userId, resource });
```

### A10: SSRF (Server-Side Request Forgery)
**What:** Application makes requests to unintended locations

**Prevention:**
- ✓ Validate URLs before making requests
- ✓ Use allowlists for external APIs
- ✓ Disable redirects to internal URLs
- ✓ Limit network access

---

## Security Checklist

### Before Deployment
- [ ] HTTPS enforced
- [ ] Security headers configured
- [ ] Input validation implemented
- [ ] Output encoding applied
- [ ] Rate limiting enabled
- [ ] CSRF protection active
- [ ] Secrets in environment variables
- [ ] Authentication/Authorization working
- [ ] No hardcoded secrets
- [ ] Dependencies audited
- [ ] Logging configured
- [ ] Error messages don't expose info

### Regular Security Tasks
- [ ] Run `npm audit` monthly
- [ ] Review access logs weekly
- [ ] Update dependencies regularly
- [ ] Test authentication flows
- [ ] Review role-based access
- [ ] Rotate secrets quarterly
- [ ] Conduct security reviews
- [ ] Penetration testing annually

---

## Do's and Don'ts

### DO
- ✓ Use HTTPS everywhere in production
- ✓ Hash passwords with bcrypt (min 12 rounds)
- ✓ Validate all input
- ✓ Use parameterized queries
- ✓ Implement rate limiting
- ✓ Log security events
- ✓ Keep dependencies updated
- ✓ Use secure defaults
- ✓ Implement MFA
- ✓ Rotate secrets regularly

### DON'T
- ✗ Hardcode secrets or credentials
- ✗ Use eval() or similar functions
- ✗ Trust user input
- ✗ Use direct string concatenation in SQL
- ✗ Store passwords in plain text
- ✗ Commit .env files
- ✗ Use default passwords in production
- ✗ Log sensitive information
- ✗ Disable security headers
- ✗ Ignore security warnings

---

## Security Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [npm Security Advisories](https://www.npmjs.com/advisories/)
- [Node.js Security](https://nodejs.org/en/docs/guides/security/)

---

**Remember:** Security is not a feature, it's a requirement. Build it in from day one! 🔒
