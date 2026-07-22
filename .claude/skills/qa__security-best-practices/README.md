# Security Best Practices Skill

Comprehensive skill for implementing security controls and preventing vulnerabilities in applications.

## Overview

This skill covers **6 core security principles**:
1. **HTTPS & Security Headers** — Encrypt traffic, set security headers
2. **Input Validation & Output Encoding** — Prevent injection attacks
3. **Rate Limiting & DDoS Protection** — Protect against brute force
4. **CSRF Protection** — Prevent cross-site request forgery
5. **Secret Management** — Store credentials safely
6. **Authentication & Authorization** — Secure user access

Plus **OWASP Top 10** vulnerability coverage.

## When to Use This Skill

Use the security-best-practices skill when you need to:
- ✅ Secure web applications or APIs
- ✅ Prevent common vulnerabilities (SQL injection, XSS, CSRF)
- ✅ Implement authentication and authorization
- ✅ Configure security headers
- ✅ Set up rate limiting
- ✅ Review code for security issues
- ✅ Harden infrastructure
- ✅ Prepare for compliance (SOC 2, GDPR, etc.)

## Quick Start

### For Beginners

1. Read **6 Core Security Principles** in SKILL.md
2. See **Code Examples** — Understand each principle
3. Use **Security Checklist** — Verify coverage
4. Reference **Do's and Don'ts** — Common mistakes
5. Start implementing!

### For Security Professionals

1. Check **OWASP Top 10** section
2. Reference **Code Examples** for implementation details
3. Use **Security Checklist** for audits
4. Review **Regular Security Tasks**

## 6 Core Security Principles

| Principle | Focus | Priority |
|-----------|-------|----------|
| HTTPS & Headers | Traffic encryption | Critical |
| Input Validation | Prevent injection | Critical |
| Rate Limiting | Prevent brute force | High |
| CSRF Protection | Prevent forgery | High |
| Secret Management | Protect credentials | Critical |
| Authentication | Verify identity | Critical |

## OWASP Top 10

| # | Vulnerability | Impact | Prevention |
|---|---|---|---|
| A01 | Broken Access Control | Unauthorized access | RBAC, authorization checks |
| A02 | Cryptographic Failures | Data exposure | HTTPS, encryption |
| A03 | Injection | Code injection | Parameterized queries |
| A04 | Insecure Design | Missing controls | Security-by-design |
| A05 | Misconfiguration | Exposed systems | Secure configuration |
| A06 | Vulnerable Components | Known exploits | Dependency updates |
| A07 | Authentication Failures | Account takeover | Strong auth, MFA |
| A08 | Data Integrity Failures | Data modification | CSRF, signatures |
| A09 | Logging Failures | No visibility | Event logging |
| A10 | SSRF | Unintended requests | URL validation |

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
- [ ] Password hashing (bcrypt, min 12 rounds)
- [ ] Access control implemented
- [ ] MFA available

### Regular Security Tasks
- [ ] Run `npm audit` monthly
- [ ] Review access logs weekly
- [ ] Update dependencies regularly
- [ ] Test authentication flows
- [ ] Review role-based access
- [ ] Rotate secrets quarterly
- [ ] Conduct security reviews
- [ ] Penetration testing annually

## Implementation Examples

### Minimal Express.js Setup
```javascript
const express = require('express');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const csrf = require('csurf');

const app = express();

// Security middleware
app.use(helmet());  // Security headers

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
app.use('/api/', limiter);

// CSRF protection
const csrfProtection = csrf({ cookie: false });
app.post('/form', csrfProtection, (req, res) => {
  res.json({ success: true });
});

// Start server with HTTPS
https.createServer(credentials, app).listen(3000);
```

### Input Validation with Joi
```javascript
const schema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(8).required()
});

app.post('/register', (req, res) => {
  const { error, value } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details });
  
  // Use validated value
});
```

### Secure Authentication
```javascript
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Hash password
const hash = await bcrypt.hash(password, 12);

// Verify password
const valid = await bcrypt.compare(password, hash);

// JWT token
const token = jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '15m' });
```

## Common Vulnerabilities & Fixes

### SQL Injection
```javascript
// ✗ Vulnerable
db.query(`SELECT * FROM users WHERE id = ${id}`);

// ✓ Safe
db.query('SELECT * FROM users WHERE id = ?', [id]);
```

### XSS (Cross-Site Scripting)
```javascript
// ✗ Vulnerable
res.send(`<h1>${userData}</h1>`);

// ✓ Safe
res.render('template', { data: userData });  // Auto-escaped
```

### Hardcoded Secrets
```javascript
// ✗ Vulnerable
const apiKey = 'sk_live_abc123xyz';

// ✓ Safe
const apiKey = process.env.API_KEY;
```

### Missing Rate Limiting
```javascript
// ✓ Add rate limiting
const limiter = rateLimit({
  max: 5,           // 5 attempts
  windowMs: 15 * 60 * 1000  // per 15 minutes
});
app.post('/login', limiter, handleLogin);
```

## Do's and Don'ts

### ✓ DO
- Use HTTPS everywhere in production
- Hash passwords (bcrypt, min 12 rounds)
- Validate all input
- Use parameterized queries
- Implement rate limiting
- Log security events
- Keep dependencies updated
- Use environment variables for secrets
- Implement MFA
- Regular security audits

### ✗ DON'T
- Hardcode credentials
- Use eval() or similar
- Trust user input
- Use string concatenation in SQL
- Store passwords in plain text
- Commit .env files
- Use default passwords
- Log sensitive information
- Disable security headers
- Ignore security warnings

## Tools & Resources

### Security Scanning
- `npm audit` — Vulnerability scanning
- `snyk` — Dependency security
- `OWASP ZAP` — Web app scanning
- `Burp Suite` — Penetration testing

### Monitoring
- `fail2ban` — Intrusion prevention
- `WAF` — Web Application Firewall
- `Sentry` — Error tracking
- `Datadog` — Security monitoring

### Learning Resources
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)
- [Node.js Security](https://nodejs.org/en/docs/guides/security/)
- [CWE Top 25](https://cwe.mitre.org/top25/)

## Security Maturity Levels

### Level 1: Basic
- HTTPS enabled
- Input validation
- Password hashing

### Level 2: Intermediate
- Security headers
- Rate limiting
- CSRF protection
- Logging

### Level 3: Advanced
- MFA implementation
- API security
- Vulnerability scanning
- Penetration testing

### Level 4: Enterprise
- Zero-trust security
- SIEM implementation
- Security monitoring
- Compliance (SOC 2, GDPR)

## File References

### SKILL.md
Complete security guide with:
- 6 core security principles
- Code examples for each principle
- OWASP Top 10 coverage
- Security checklist
- Do's and Don'ts

### references/ (Coming Soon)
- `owasp-checklist.md` — OWASP Top 10 checklist
- `incident-response.md` — How to respond to security incidents
- `secure-coding-guide.md` — Secure coding practices by language

## Quick Security Audit

Use this checklist for a quick security audit:

```
HTTPS & Headers
- [ ] HTTPS in production
- [ ] Helmet or equivalent middleware
- [ ] CSP configured
- [ ] HSTS enabled

Input & Data
- [ ] Input validation implemented
- [ ] Output encoding used
- [ ] No hardcoded secrets
- [ ] Secrets in .env

Authentication
- [ ] Strong password requirements
- [ ] Password hashing (bcrypt)
- [ ] JWT/OAuth implemented
- [ ] Session secure settings

Protection
- [ ] Rate limiting enabled
- [ ] CSRF protection active
- [ ] SQL injection prevention
- [ ] XSS prevention

Maintenance
- [ ] Dependencies up to date
- [ ] npm audit passed
- [ ] Logging configured
- [ ] Error handling secure
```

## Integration with CI/CD

Add security checks to your pipeline:

```yaml
# GitHub Actions
- name: Security audit
  run: npm audit

- name: SAST scanning
  run: snyk test

- name: Dependency check
  run: npm outdated
```

---

**Security is not optional—it's essential!** Every application needs these protections. 🔒

Ready to secure your app? Read **SKILL.md** to start! 💪
