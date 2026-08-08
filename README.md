
# 🎮 Yumerei-MCsetup

Một bộ script tự động hỗ trợ cài đặt và thiết lập máy chủ Minecraft trên Linux nhanh chóng và tiện lợi.

---

## 🚀 Cài đặt nhanh (One-liner)

Bạn có thể chạy trực tiếp lệnh sau trên terminal của Linux để tự động cài đặt `git`, tải repo và chạy script cài đặt:

```bash
sudo bash -c "if ! command -v git &> /dev/null; then if command -v apt-get &> /dev/null; then apt-get update -y && apt-get install -y git; elif command -v dnf &> /dev/null; then dnf install -y git; elif command -v yum &> /dev/null; then yum install -y git; fi; fi && git clone [https://github.com/Zero12RB/Yumerei-MCsetup.git](https://github.com/Zero12RB/Yumerei-MCsetup.git) && cd Yumerei-MCsetup && chmod +x install-yumereiii.sh && ./install-yumereiii.sh"

```

---

## 🛠️ Cài đặt thủ công

Nếu muốn thực hiện từng bước, bạn làm theo hướng dẫn dưới đây:

### 1. Cài đặt Git (nếu chưa có)

* **Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install -y git

```


* **CentOS/RHEL/AlmaLinux:**
```bash
sudo yum install -y git
# hoặc
sudo dnf install -y git

```



### 2. Clone Repository & Chạy Script

```bash
# Tải repository về máy
git clone [https://github.com/Zero12RB/Yumerei-MCsetup.git](https://github.com/Zero12RB/Yumerei-MCsetup.git)

# Di chuyển vào thư mục dự án
cd Yumerei-MCsetup

# Cấp quyền thực thi cho file script
chmod +x install-yumereiii.sh

# Chạy script cài đặt
./install-yumereiii.sh

```

---

## 📋 Yêu cầu hệ thống

* **HĐH:** Linux (Ubuntu, Debian, CentOS, AlmaLinux, v.v.)
* Quyền **`sudo`** hoặc tài khoản **`root`**

---

## 👤 Tác giả

* **GitHub:** [@Zero12RB](https://www.google.com/search?q=https://github.com/Zero12RB)

```

