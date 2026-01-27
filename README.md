# 📚 Book Store Management System - Team 9 (QLTT - IE103.F12.LT.CNTT)

Hệ thống quản lý cửa hàng bán sách được xây dựng bằng **Next.js** với cơ sở dữ liệu **SQL Server**. Dự án demo các tính năng quản lý sách, đơn hàng, khách hàng và tài khoản người dùng.

## 📂 Cấu trúc dự án

- `app/`: Chứa các trang giao diện (Login, Dashboard...).
- `components/`: Các thành phần giao diện nhỏ (Nút bấm, bảng, popup...).
- `lib/db.ts`: File cấu hình kết nối CSDL.
- `actions/`: Chứa code xử lý Logic (Đăng nhập, thêm sửa xóa...).


## 🛠️ 1. Cài đặt các công cụ cần thiết (Chỉ làm 1 lần đầu)

Trước khi bắt đầu, hãy đảm bảo máy tính của bạn đã có những thứ sau:

1. **Node.js**: Môi trường để chạy web.
    - Tải bản **LTS** (Recommended) tại đây: [Download Node.js](https://nodejs.org/en)
    - Cài đặt cứ bấm "Next" liên tục là được.
2. **SQL Server & SSMS**: Cơ sở dữ liệu.
    - Đảm bảo đã cài SQL Server (bản Developer hoặc Express).
    - Đã cài **SSMS** (SQL Server Management Studio) để quản lý dữ liệu.
3. **Visual Studio Code (VS Code)**: Để mở code (nếu chưa có).


## 🚀 2. Cách tải và chạy dự án

### Bước 1: Tải code về máy

- **Cách 1:** Nếu dùng Git, mở terminal và gõ:
  ```bash
  git clone https://github.com/vanthom04/book-store.git
  ```
- **Cách 2:** Tải file **ZIP** từ GitHub về và giải nén ra một thư mục.

### Bước 2: Cài đặt thư viện

1. Mở thư mục dự án vừa giải nén bằng **VS Code**.
2. Mở cửa sổ dòng lệnh (**Terminal**) trong VS Code bằng cách nhấn tổ hợp phím: `Ctrl` + `~` (dấu ngã bên cạnh số 1).
3. Cài đặt các thư viện cho dự án bằng lệnh:

    ```bash
    npm install
    ```

    _(Chờ một chút cho nó chạy xong)_

### Bước 3: Cấu hình kết nối CSDL (Quan trọng)

1.  Trong thư mục code, tìm file `.env.example`, đổi tên nó thành `.env`.
2.  Mở file `.env` lên và điền thông tin SQL Server của bạn vào:

    ```env
    # Tên User đăng nhập SQL
    DB_USER=username
    # Mật khẩu SQL của bạn (lúc cài SQL Server bạn đặt là gì thì điền vào)
    DB_PASSWORD=your_password_here
    # Tên Server (thường là localhost hoặc tên máy của bạn)
    DB_SERVER=localhost
    # Tên Database
    DB_NAME=BOOK_STORE
    ```

### Bước 4: Chạy dự án

Các bạn có thể chọn 1 trong 2 cách sau để chạy web.

* **Cách 1:** Dành cho ai muốn sửa code.
* **Cách 2:** Dành cho ai chỉ muốn xem web hoặc **dùng để Demo báo cáo** (Khuyên dùng vì web sẽ chạy rất nhanh và mượt).

#### Cách 1: Chạy chế độ phát triển (Dev Mode)

Dùng cách này nếu đang phát triển tính năng, code sẽ tự cập nhật khi lưu file.

1. Gõ lệnh:

```bash
npm run dev
```

2. Chờ thấy dòng `Ready in ...` thì vào link: [http://localhost:3000](http://localhost:3000)

#### Cách 2: Chạy chế độ Demo (Production Mode - Khuyên dùng)

Dùng cách này để web chạy ổn định nhất, không bị giật lag.

1. **Bước A: Đóng gói dự án (Build project)** (Chỉ cần chạy lệnh này 1 lần sau khi tải code về, hoặc khi code có thay đổi mới):

```bash
npm run build
```

*(Chờ một lúc cho máy nó đóng gói code, khi nào thấy hiện danh sách các file màu xanh lá cây là xong).*

2. **Bước B: Chạy web**:

```bash
npm run start
```


3. Mở trình duyệt và vào link: [http://localhost:3000](http://localhost:3000)

*Lưu ý: Để tắt server đang chạy, hãy bấm tổ hợp phím `Ctrl + C` trong Terminal.*


## ⚠️ 3. SỬA LỖI KẾT NỐI SQL SERVER (Đọc kỹ nếu bị lỗi)

Nếu khi chạy web hoặc đăng nhập mà bị báo lỗi **"Connection failed"** hoặc **"Login failed"**, 99% là do máy bạn chưa bật chế độ cho phép kết nối từ bên ngoài. Hãy làm theo 2 bước sau:

### BƯỚC A: Bật chế độ đăng nhập bằng mật khẩu (SQL Server Authentication)

Mặc định SQL Server chỉ cho Windows đăng nhập, code web cần đăng nhập bằng User/Pass nên phải bật cái này.

1. Mở **SQL Server Management Studio (SSMS)** và đăng nhập.
2. Chuột phải vào tên Server (dòng đầu tiên bên trái) -> Chọn **Properties**.
3. Chọn mục **Security** ở menu bên trái.
4. Ở phần "Server authentication", tích vào ô: **SQL Server and Windows Authentication mode**.
5. Nhấn **OK**. (Nó sẽ bảo cần restart, cứ kệ nó, làm tiếp Bước B).

### BƯỚC B: Bật giao thức TCP/IP (Quan trọng nhất)

Code Node.js kết nối qua cổng mạng (TCP/IP), mặc định cái này bị TẮT.

1. Bấm phím `Windows`, gõ tìm kiếm: **Sql Server Configuration Manager** và mở nó lên (Có icon hộp đồ nghề màu đỏ).
2. Mở mục **SQL Server Network Configuration** -> Chọn **Protocols for MSSQLSERVER** (hoặc tên máy của bạn).
3. Nhìn bên phải, dòng **TCP/IP** đang là `Disabled` đúng không?

- Chuột phải vào **TCP/IP** -> Chọn **Enable**.

4. Vẫn chuột phải vào **TCP/IP** -> Chọn **Properties**.

- Chuyển sang tab **IP Addresses**.
- Kéo xuống dưới cùng mục **IPAll**.
- Đảm bảo dòng **TCP Port** là số `1433`. (Nếu trống thì gõ 1433 vào).
- Nhấn **OK**.

### BƯỚC C: Khởi động lại SQL Server (Bắt buộc)

Làm xong A và B mà không làm bước này thì cũng vô dụng.

1. Vẫn trong **Sql Server Configuration Manager**.
2. Chọn mục **SQL Server Services**.
3. Chuột phải vào **SQL Server (MSSQLSERVER)** -> Chọn **Restart**.

=> **XONG!** Bây giờ quay lại VS Code chạy `npm run dev` là sẽ kết nối được ngon lành.


## Một số lưu ý:
1.  **Database Script**: Em có gửi kèm file script `.sql` (Tạo bảng, Trigger, Stored Procedure) ở trong thư mục `db` cho mọi người rồi nên nếu ai mà chưa chạy SQL thì hãy chạy SQL trước khi chạy web nha. (Nhớ chạy file `insert_data.sql` trước khi chạy file `trigger_function_stored_cursor.sql`)

---
Authored by Team 9 - QLTT (IE103.F12.LT.CNTT)

*Happy Coding! 🚀*
