# MCP Playwright Setup

MCP (Model Context Protocol) Playwright memungkinkan Claude mengontrol browser
secara langsung — bukan hanya menulis kode, tapi benar-benar membuka halaman,
klik, isi form, dan generate test dari interaksi nyata.

---

## Cek Apakah MCP Sudah Ada

```bash
# Cek konfigurasi MCP lokal project
cat .claude/mcp_settings.json 2>/dev/null

# Cek konfigurasi MCP global
cat ~/.claude/mcp_settings.json 2>/dev/null

# Cek apakah package sudah tersedia
npx @playwright/mcp --version 2>/dev/null
```

Jika sudah terkonfigurasi dan `playwright` muncul di daftar MCP server → skip ke Verifikasi.

---

## Opsi A — Gunakan MCP Playwright Resmi (Direkomendasikan)

Ini adalah MCP server resmi dari tim Playwright. Tidak perlu install permanen
— cukup konfigurasi agar Claude bisa memanggilnya via `npx`.

### Konfigurasi di Project (Lokal)

Buat atau update `.claude/mcp_settings.json`:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "description": "Playwright MCP — kontrol browser langsung dari Claude"
    }
  }
}
```

### Konfigurasi Global (Berlaku untuk Semua Project)

```bash
# Buat folder jika belum ada
mkdir -p ~/.claude

# Buat atau edit file konfigurasi global
cat > ~/.claude/mcp_settings.json << 'EOF'
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
EOF
```

### Opsi dengan Browser Spesifik

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "@playwright/mcp@latest",
        "--browser", "chromium",
        "--headless"
      ]
    }
  }
}
```

---

## Verifikasi MCP

Setelah konfigurasi, verifikasi dengan cara meminta Claude melakukan:

1. Buka halaman utama aplikasi
2. Ambil screenshot
3. Deskripsikan apa yang terlihat

Jika Claude bisa mendeskripsikan isi halaman dari screenshot → MCP berjalan dengan benar.

---

## Kapan Gunakan MCP vs Tanpa MCP

| Kebutuhan | Gunakan MCP | Tanpa MCP |
|---|---|---|
| Exploratory testing — lihat tampilan nyata | ✅ | ❌ |
| Generate test dari interaksi browser | ✅ | ❌ |
| Debug visual — elemen tidak muncul | ✅ | ❌ |
| Tulis test dari deskripsi atau kode | ❌ | ✅ |
| Jalankan test suite di CI | ❌ | ✅ |
| Review dan refactor test yang ada | ❌ | ✅ |
