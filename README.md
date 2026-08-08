
# 🎮 Yumerei-MCsetup

Một bộ công cụ tự động giúp cài đặt, quản lý và tối ưu hóa máy chủ Minecraft **Fabric** trên Linux một cách nhanh chóng, tiện lợi qua giao diện Panel tiện ích.

---

## ℹ️ Thông tin Máy chủ & Phụ kiện

* **Server Core:** Fabric 
* **Phiên bản:** `26.2` *(Phiên bản hiện tại)*
* **Bộ Plugin / Modpack cho Server:** [Mcpackfabric26.2set](https://github.com/namvietnamfight-hub/Mcpackfabric26.2set)

---

## ✨ Tính năng chính

* ⚡ **Cài đặt siêu nhanh:** Tự động chuẩn bị môi trường và các phụ thuộc cần thiết.
* 🖥️ **Giao diện Panel tiện lợi:** Quản lý máy chủ dễ dàng thông qua menu điều khiển trực quan.
* ☕ **Hỗ trợ đa phiên bản Java:** Tự động tải và cấu hình các phiên bản Java phù hợp.
* 🛡️ **Tối ưu hóa máy chủ:** Cấu hình sẵn giúp giảm lag và tối ưu hiệu năng VPS/Server.
* 🔄 **Mở lại Panel dễ dàng:** Mở lại bảng điều khiển bất cứ lúc nào bằng lệnh với tham số `--panel`.
* 🧹 **Khôi phục khẩn cấp (Emergency Reset):** Script làm sạch hoàn toàn giúp reset về trạng thái ban đầu khi gặp sự cố.

---

## 🚀 Cài đặt nhanh (One-liner)

Chạy duy nhất câu lệnh sau trên Terminal Linux để tự động cài đặt `git`, tải repository và khởi chạy script:

```bash
sudo bash -c "if ! command -v git &> /dev/null; then if command -v apt-get &> /dev/null; then apt-get update -y && apt-get install -y git; elif command -v dnf &> /dev/null; then dnf install -y git; elif command -v yum &> /dev/null; then yum install -y git; fi; fi && git clone [https://github.com/Zero12RB/Yumerei-MCsetup.git](https://github.com/Zero12RB/Yumerei-MCsetup.git) && cd Yumerei-MCsetup && chmod +x install-yumereiii.sh && ./install-yumereiii.sh"

```

---

## 🛠️ Cài đặt thủ công

Nếu muốn tự thực hiện từng bước:

### 1. Cài đặt Git (nếu máy chưa có)

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



### 2. Clone Repository & Cài đặt

```bash
# Tải repository
git clone [https://github.com/Zero12RB/Yumerei-MCsetup.git](https://github.com/Zero12RB/Yumerei-MCsetup.git)

# Di chuyển vào thư mục dự án
cd Yumerei-MCsetup

# Cấp quyền và chạy script
chmod +x install-yumereiii.sh
./install-yumereiii.sh

```

---

## 🖥️ Mở lại bảng điều khiển (Panel)

Nếu bạn đã thoát ra ngoài Terminal và muốn **mở lại giao diện Panel** để quản lý server, chỉ cần chạy lại file script với tham số `--panel`:

```bash
cd Yumerei-MCsetup
./install-yumereiii.sh --panel

```

---

## 🚨 Xóa sạch & Cài đặt lại từ đầu (Khẩn cấp)

Trong trường hợp xảy ra lỗi nghiêm trọng hoặc bạn muốn **xóa sạch toàn bộ cấu hình cũ** để làm lại từ đầu, hãy chạy file script dọn dẹp khẩn cấp:

```bash
cd Yumerei-MCsetup
chmod +x uninstall-yumereiii.sh  # Cấp quyền cho file dọn dẹp (nếu chưa có)
./uninstall-yumereiii.sh          # Chạy script xóa sạch dữ liệu

```

> ⚠️ **Lưu ý:** Thao tác này sẽ xóa toàn bộ dữ liệu máy chủ và cấu hình liên quan. Hãy cân nhắc sao lưu (backup) trước khi thực hiện!

---

## 📋 Yêu cầu hệ thống

* **Hệ điều hành:** Linux (Ubuntu, Debian, CentOS, AlmaLinux, v.v.)
* Quyền **`sudo`** hoặc tài khoản **`root`**

---

## 👤 Tác giả

* **GitHub:** [@Zero12RB](https://github.com/Zero12RB)

```

```
