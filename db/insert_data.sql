USE BOOK_STORE;
GO

-- ===================================== INSERT USERS =====================================

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'QUẢN TRỊ VIÊN', 'ADMIN@BOOKSTORE.COM', '$2b$10$QeXM481oMfBKKW65DCQH0OW9TG2zF9kJk7rqV0PYQDXsgI/zUqQqi', '0909000111', N'TP. HỒ CHÍ MINH', 'ADMIN', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'NGUYỄN VĂN AN', 'AN.NGUYEN@GMAIL.COM', '$2b$10$QeXM481oMfBKKW65DCQH0OW9TG2zF9kJk7rqV0PYQDXsgI/zUqQqi', '0912345678', N'123 LÊ LỢI, Q1, TP.HCM', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'TRẦN THỊ BÍCH', 'BICH.TRAN@YAHOO.COM', '$2b$10$5jh/1J6MWITNBbGaSy0ggeUZsj2G2qMA8ndZvCw2oKqyTOVDVfIM.', '0987654321', N'45 NGUYỄN TRÃI, Q5, TP.HCM', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'LÊ HOÀNG NAM', 'NAM.LE@OUTLOOK.COM', '$2b$10$QeXM481oMfBKKW65DCQH0OW9TG2zF9kJk7rqV0PYQDXsgI/zUqQqi', '0901234567', N'12 XUÂN THỦY, CẦU GIẤY, HÀ NỘI', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'PHẠM MINH TÚ', 'TU.PHAM@GMAIL.COM', '$2b$10$5jh/1J6MWITNBbGaSy0ggeUZsj2G2qMA8ndZvCw2oKqyTOVDVfIM.', '0933444555', N'88 TRẦN HƯNG ĐẠO, ĐÀ NẴNG', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'HOÀNG THÙY LINH', 'LINH.HOANG@GMAIL.COM', '$2b$10$5jh/1J6MWITNBbGaSy0ggeUZsj2G2qMA8ndZvCw2oKqyTOVDVfIM.', '0977888999', N'CẦN THƠ', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'VŨ ĐỨC ĐAM', 'DAM.VU@COMPANY.VN', '$2b$10$5jh/1J6MWITNBbGaSy0ggeUZsj2G2qMA8ndZvCw2oKqyTOVDVfIM.', '0911223344', N'BIÊN HÒA, ĐỒNG NAI', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'NGUYỄN ANH DƯƠNG', 'DUONG.NGUYEN@GMAIL.COM', '$2b$10$QeXM481oMfBKKW65DCQH0OW9TG2zF9kJk7rqV0PYQDXsgI/zUqQqi', '0944556677', N'HẢI PHÒNG', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'NGÔ BÁ KIẾN', 'KIEN.NGO@GMAIL.COM', '$2b$10$5jh/1J6MWITNBbGaSy0ggeUZsj2G2qMA8ndZvCw2oKqyTOVDVfIM.', '0966778899', N'VINH, NGHỆ AN', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'BÙI THỊ XUÂN', 'XUAN.BUI@EDU.VN', '$2b$10$QeXM481oMfBKKW65DCQH0OW9TG2zF9kJk7rqV0PYQDXsgI/zUqQqi', '0999888777', N'ĐÀ LẠT, LÂM ĐỒNG', 'USER', 1, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));

INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD_HASH, PHONE, ADDRESS, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES (N'HACKER LỎ', 'BADGUY@DARKWEB.COM', '$2b$10$5jh/1J6MWITNBbGaSy0ggeUZsj2G2qMA8ndZvCw2oKqyTOVDVfIM.', '0000000000', N'UNKNOWN', 'USER', 0, CAST('2026-01-11T20:24:47.690' AS DATETIME), CAST('2026-01-11T20:24:47.690' AS DATETIME));


-- ===================================== INSERT CATEGORIES =====================================

INSERT INTO CATEGORIES (CATEGORY_NAME) VALUES (N'Văn học');
INSERT INTO CATEGORIES (CATEGORY_NAME) VALUES (N'Thiếu nhi');
INSERT INTO CATEGORIES (CATEGORY_NAME) VALUES (N'Kỹ năng sống');
INSERT INTO CATEGORIES (CATEGORY_NAME) VALUES (N'Kinh tế - Kinh doanh');
INSERT INTO CATEGORIES (CATEGORY_NAME) VALUES (N'Giáo dục');
INSERT INTO CATEGORIES (CATEGORY_NAME) VALUES (N'Khoa học - Lịch sử');
INSERT INTO CATEGORIES (CATEGORY_NAME) VALUES (N'Tâm lý học');
INSERT INTO CATEGORIES (CATEGORY_NAME) VALUES (N'Văn hóa - Nghệ thuật');


-- ===================================== INSERT PUBLISHERS =====================================

INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Văn Học', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Thanh Niên', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Trẻ', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Kim Đồng', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Thế Giới', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Tổng Hợp TP.HCM', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Giáo Dục', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Hội Nhà Văn', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Phụ Nữ', N'Việt Nam');
INSERT INTO PUBLISHERS (PUBLISHER_NAME, COUNTRY) VALUES (N'NXB Lao Động', N'Việt Nam');


-- ===================================== INSERT AUTHOR =====================================

INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyễn Du', N'Đại thi hào dân tộc, danh nhân văn hóa thế giới.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Vũ Trọng Phụng', N'Ông vua phóng sự đất Bắc.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Bảo Ninh', N'Tác giả tiêu biểu của văn học hậu chiến.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Phùng Quán', N'Nhà văn, nhà thơ tài năng của nhóm Nhân văn Giai phẩm.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Keith Ferrazzi', N'Doanh nhân và tác giả nổi tiếng người Mỹ.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyễn Nhật Ánh', N'Nhà văn chuyên viết cho tuổi mới lớn.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Tô Hoài', N'Cây bút văn xuôi hàng đầu của văn học hiện đại Việt Nam.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Dan Senor', N'Tác giả và nhà tư vấn chính trị người Mỹ.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Dale Carnegie', N'Tác giả của những cuốn sách nghệ thuật ứng xử nổi tiếng.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyễn Mộng Giác', N'Nhà văn với những bộ tiểu thuyết lịch sử đồ sộ.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Fukuzawa Yukichi', N'Nhà tư tưởng vĩ đại của Nhật Bản thời Minh Trị.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyên Hồng', N'Nhà văn của những người cùng khổ.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nam Cao', N'Đại biểu xuất sắc của dòng văn học hiện thực phê phán.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Ngô Tất Tố', N'Nhà văn, nhà báo, nhà nghiên cứu văn hóa tiêu biểu.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyễn Tuân', N'Bậc thầy của thể tùy bút và tiếng Việt.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Đoàn Giỏi', N'Nhà văn gắn liền với mảnh đất phương Nam.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Paulo Coelho', N'Tiểu thuyết gia nổi tiếng người Brazil.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyễn Ngọc Tư', N'Nữ nhà văn tiêu biểu của vùng đất Nam Bộ.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Yuval Noah Harari', N'Nhà sử học và giáo sư người Israel.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Robert T. Kiyosaki', N'Doanh nhân và tác giả bộ sách Cha Giàu Cha Nghèo.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Song Hongbing', N'Chuyên gia tài chính, tác giả Chiến tranh tiền tệ.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyễn Huy Thiệp', N'Hiện tượng độc đáo của văn học Việt Nam đương đại.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Lê Lựu', N'Nhà văn quân đội, nổi tiếng với tiểu thuyết Thời xa vắng.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyễn Việt Hà', N'Nhà văn hiện đại với bút pháp sắc sảo về Hà Nội.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Ocean Vuong', N'Nhà thơ, nhà văn người Mỹ gốc Việt nổi tiếng thế giới.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Nguyễn Chỉnh', N'Tác giả văn học đương đại.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Võ Quảng', N'Nhà văn chuyên viết cho thiếu nhi.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Lê Văn Thành', N'Chuyên gia kinh tế và chứng khoán.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Kim Lân', N'Nhà văn chuyên viết về nông thôn và người nông dân.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Haemin Sunim', N'Nhà sư và tác giả nổi tiếng của Hàn Quốc.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Daniel Kahneman', N'Nhà tâm lý học đoạt giải Nobel Kinh tế.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Anh Đức', N'Nhà văn với những tác phẩm về kháng chiến.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Trần Dần', N'Nhà thơ cách tân của văn học Việt Nam.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Viktor Frankl', N'Bác sĩ tâm thần và tác giả người Áo.');
INSERT INTO AUTHORS (AUTHOR_NAME, BIO) VALUES (N'Ayn Rand', N'Triết gia và tiểu thuyết gia người Mỹ gốc Nga.');


-- ===================================== INSERT BOOKS =====================================

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Truyện Kiều', 2023, N'Vietnamese', 325, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/370/339/products/truyen-kieu-chu-giai.jpg', 100, 150000, 1, 1, 1, 0, N'Kiệt tác văn học của đại thi hào Nguyễn Du, kể về cuộc đời đầy thăng trầm và bi kịch của nàng Kiều, qua đó phản ánh hiện thực xã hội phong kiến.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Số Đỏ', 2022, N'Vietnamese', 250, 'https://product.hstatic.net/1000237375/product/thiet_ke_chua_co_ten_-_2024-08-30t094519.197_549f30009de045a79ace8f6f151401e7.png', 100, 95000, 1, 2, 2, 0, N'Tiểu thuyết trào phúng xuất sắc đả kích thói hư tật xấu và sự lố lăng của xã hội tư sản thành thị Việt Nam qua nhân vật Xuân Tóc Đỏ.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Tuổi Thơ Dữ Dội', 2023, N'Vietnamese', 800, 'https://product.hstatic.net/200000343865/product/tuoi-tho-du-doi_tap-1---tb-2023_37610d8b4cd0453aa96ab4f7873defee.png', 100, 185000, 2, 1, 4, 0, N'Bản hùng ca bi tráng về cuộc đời chiến đấu hy sinh của những chiến sĩ nhỏ tuổi trong hàng ngũ Vệ quốc đoàn thời kỳ kháng chiến chống Pháp.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Đừng Bao Giờ Đi Ăn Một Mình', 2022, N'Vietnamese', 380, 'https://www.nxbtre.com.vn/Images/Book/copy_10_nxbtre_full_10272022_032717.jpg', 100, 145000, 3, 3, 5, 0, N'Cuốn sách chia sẻ bí quyết xây dựng mối quan hệ bền vững và mạng lưới kết nối hiệu quả để đạt được thành công trong sự nghiệp và cuộc sống.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Cho Tôi Xin Một Vé Đi Tuổi Thơ', 2023, N'Vietnamese', 220, 'https://www.nxbtre.com.vn/Images/Book/nxbtre_thumb_08142018_091438.jpg', 100, 85000, 2, 3, 6, 0, N'Tác phẩm đưa người đọc trở về với thế giới hồn nhiên, trong trẻo của trẻ thơ, gợi lại những ký ức đẹp đẽ mà ai cũng từng trải qua.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Dế Mèn Phiêu Lưu Ký', 2024, N'Vietnamese', 150, 'https://cdn1.fahasa.com/media/catalog/product/d/e/de-men-50k_1.jpg', 100, 60000, 2, 4, 7, 0, N'Câu chuyện phiêu lưu đầy thú vị của chú Dế Mèn qua nhiều vùng đất, mang đến những bài học sâu sắc về tình bạn và lẽ sống.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Quốc Gia Khởi Nghiệp', 2021, N'Vietnamese', 450, 'https://pos.nvncdn.com/fd5775-40602/ps/20220118_mqUAopDZEMMZ7zmsl0PntPnF.jpg', 100, 168000, 4, 5, 8, 0, N'Câu chuyện về sự phát triển thần kỳ của nền kinh tế Israel, từ một quốc gia nhỏ bé trở thành trung tâm công nghệ và khởi nghiệp hàng đầu thế giới.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Đắc Nhân Tâm', 2023, N'Vietnamese', 320, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvRHdvS-Arg4qRx6UCfZvxF5SamBVQkza5Mg&s', 100, 110000, 3, 6, 9, 0, N'Cuốn sách kinh điển về nghệ thuật ứng xử, giúp bạn thấu hiểu tâm lý con người và thu phục lòng người để gặt hái thành công.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Sông Côn Mùa Lũ', 2020, N'Vietnamese', 1200, 'https://minhkhai.com.vn/hinhlon/8932000124481.jpg', 100, 350000, 1, 1, 10, 0, N'Bộ trường thiên tiểu thuyết tái hiện sinh động bối cảnh lịch sử đầy biến động và hào hùng của phong trào Tây Sơn.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Khuyến Học', 2022, N'Vietnamese', 280, 'https://cdn1.fahasa.com/media/catalog/product/8/9/8935235242661.jpg', 100, 75000, 5, 5, 11, 0, N'Tác phẩm khai sáng tư tưởng người Nhật, nhấn mạnh tầm quan trọng của sự học, độc lập và tự cường dân tộc.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Những Ngày Thơ Ấu', 2021, N'Vietnamese', 180, 'https://www.netabooks.vn/Data/Sites/1/Product/77811/nhung-ngay-au-tho-thuong-nho.jpg', 100, 55000, 1, 2, 12, 0, N'Hồi ký đầy xúc động về tuổi thơ cay đắng, thiếu thốn tình thương nhưng giàu nghị lực sống của nhà văn Nguyên Hồng.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Bàn Có Năm Chỗ Ngồi', 2023, N'Vietnamese', 210, 'https://www.nxbtre.com.vn/Images/Book/copy_21_NXBTreStoryFull_13312014_023129.jpg', 100, 78000, 2, 3, 6, 0, N'Câu chuyện học đường nhẹ nhàng, ấm áp về tình bạn của nhóm năm người bạn cùng tiến, chia sẻ những vui buồn tuổi học trò.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Chí Phèo', 2024, N'Vietnamese', 200, 'https://minhkhai.com.vn/hinhlon/9786043940305.jpg', 100, 65000, 1, 1, 13, 0, N'Bi kịch của người nông dân bị tha hóa và cự tuyệt quyền làm người trong xã hội cũ, qua hình tượng kinh điển Chí Phèo.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Tắt Đèn', 2022, N'Vietnamese', 240, 'https://upload.wikimedia.org/wikipedia/vi/b/b1/T%E1%BA%AFt_%C4%91%C3%A8n-Nh%C3%A3_Nam.jpeg', 100, 70000, 1, 1, 14, 0, N'Bức tranh chân thực và tăm tối về cuộc sống khốn cùng của người nông dân Việt Nam dưới ách sưu thuế nặng nề.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Vang Bóng Một Thời', 2021, N'Vietnamese', 210, 'https://online.anyflip.com/mhnd/qpld/files/mobile/1.jpg?1672678754', 100, 85000, 1, 2, 15, 0, N'Tập tùy bút tuyệt đẹp tôn vinh những nét đẹp văn hóa truyền thống, những thú chơi tao nhã và khí phách của người xưa.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Đất Rừng Phương Nam', 2023, N'Vietnamese', 350, 'https://www.netabooks.vn/Data/Sites/1/Product/47567/dat-rung-phuong-nam-ki-niem-65-nam-nxb-kim-dong-bia-cung.jpg', 100, 115000, 2, 4, 16, 0, N'Cuộc phiêu lưu của cậu bé An giữa thiên nhiên hoang sơ, hùng vĩ và những con người hào sảng, chất phác vùng sông nước Nam Bộ.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh', 2022, N'Vietnamese', 300, 'https://nhasachmienphi.com/images/thumbnail/nhasachmienphi-toi-thay-hoa-vang-tren-co-xanh.jpg', 100, 125000, 2, 3, 6, 0, N'Những rung động đầu đời, tình anh em cảm động và những kỷ niệm tuổi thơ êm đềm tại làng quê nghèo khó nhưng đầy tình thương.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Nhà Giả Kim', 2024, N'Vietnamese', 250, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/363/455/products/nhagiakimnew03.jpg?v=1705552576547', 100, 89000, 1, 1, 17, 0, N'Hành trình đầy triết lý của chàng chăn cừu Santiago đi tìm kho báu, nhắc nhở chúng ta hãy luôn theo đuổi ước mơ của mình.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Cánh Đồng Bất Tận', 2021, N'Vietnamese', 230, 'https://upload.wikimedia.org/wikipedia/vi/0/01/Canh-dong-bat-tan.jpg', 100, 98000, 1, 3, 18, 0, N'Tuyển tập truyện ngắn khắc họa sâu sắc những phận người nhỏ bé, lênh đênh và bi kịch trên vùng sông nước miền Tây.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Lược Sử Loài Người', 2022, N'Vietnamese', 550, 'https://bizweb.dktcdn.net/100/197/269/products/sapiens-luoc-su-ve-loai-nguoi-outline-5-7-2017-02.jpg?v=1520935327270', 100, 280000, 6, 5, 19, 0, N'Hành trình phát triển của loài người từ thời tiền sử đến thế giới hiện đại, giải mã cách Homo Sapiens thống trị hành tinh.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Cha Giàu Cha Nghèo', 2023, N'Vietnamese', 380, 'https://sbsvietnam.com/wp-content/uploads/2021/03/review-sach-cha-giau-cha-ngheo.jpg', 100, 145000, 4, 3, 20, 0, N'Sự khác biệt trong tư duy tài chính giữa người giàu và người nghèo, giúp bạn thay đổi cách nhìn về tiền bạc và đầu tư.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Chiến Tranh Tiền Tệ', 2020, N'Vietnamese', 600, 'https://cdn1.fahasa.com/media/catalog/product/b/i/bia-truoc-chien-tranh-tien-te-phan-1.jpg', 100, 220000, 4, 6, 21, 0, N'Những bí mật gây sốc đằng sau lịch sử tiền tệ thế giới và các cuộc chiến tranh tài chính âm thầm chi phối nền kinh tế toàn cầu.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Những Ngọn Gió Hua Tát', 2021, N'Vietnamese', 280, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/363/455/products/nhung-ngon-gio-hua-tat-01.jpg?v=1728274539880', 100, 110000, 1, 1, 22, 0, N'Tập truyện ngắn mang đậm màu sắc huyền thoại và văn hóa dân gian, kể về nỗi buồn và thân phận con người ở bản Hua Tát.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Mắt Biếc', 2023, N'Vietnamese', 280, 'https://upload.wikimedia.org/wikipedia/vi/9/92/Mat_Biec.gif', 100, 105000, 2, 3, 6, 0, N'Câu chuyện tình yêu đơn phương đầy day dứt, thuần khiết nhưng cũng đượm buồn giữa Ngạn và Hà Lan qua bao thăng trầm.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Thời Xa Vắng', 2021, N'Vietnamese', 420, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6vETnpi3vC8ebonCdUNsxz3nDSnOcXBw6DQ&s', 100, 135000, 1, 1, 23, 0, N'Bi kịch của con người không được sống là chính mình trong bối cảnh xã hội cũ, luôn phải chạy theo những giá trị áp đặt.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Cơ Hội Của Chúa', 2022, N'Vietnamese', 500, 'https://www.nxbtre.com.vn/Images/Book/nxbtre_full_28172021_021747.jpg', 100, 165000, 1, 6, 24, 0, N'Bức tranh xã hội hiện đại đầy biến động của giới trẻ Hà Nội, nơi đức tin, cơ hội và những toan tính đời thường đan xen.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Một Thoáng Ta Rực Rỡ', 2023, N'Vietnamese', 320, 'https://upload.wikimedia.org/wikipedia/vi/6/65/Mot_thoang_ta_ruc_ro_o_nhan_gian_bia.png', 100, 155000, 1, 1, 25, 0, N'Bức thư đầy chất thơ và nỗi đau của một người con trai gửi cho người mẹ không biết chữ, về tình yêu, chiến tranh và sự mất mát.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Ba Nghìn Thế Giới Thơm', 2021, N'Vietnamese', 250, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/363/455/products/ba-nghin-the-gioi-thom-01-e1721272224593.jpg?v=1721272269160', 100, 220000, 1, 2, 13, 0, N'Những trang viết tản văn nhẹ nhàng, sâu lắng về những trải nghiệm tuổi trẻ, những chuyến đi và góc nhìn tinh tế về cuộc sống.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Quê Nội', 2024, N'Vietnamese', 450, 'https://upload.wikimedia.org/wikipedia/vi/c/c5/Que_Noi.jpg', 100, 120000, 2, 4, 27, 0, N'Tác phẩm thiếu nhi xuất sắc tái hiện không khí hào hùng và đổi mới của làng quê miền Trung những ngày sau Cách mạng tháng Tám.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Sống Mòn', 2022, N'Vietnamese', 320, 'https://vbookshop.com/wp-content/uploads/2022/06/song-mon.png', 100, 95000, 1, 1, 13, 0, N'Cuộc sống bế tắc, mòn mỏi và những dằn vặt nội tâm của người trí thức nghèo trong xã hội cũ, khao khát thay đổi nhưng bất lực.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Để Thành Công Trong Chứng Khoán', 2023, N'Vietnamese', 400, 'https://cdn1.fahasa.com/media/catalog/product/i/m/image_116587.jpg', 100, 185000, 4, 6, 28, 0, N'Hệ thống đầu tư CAN SLIM nổi tiếng, mang đến những nguyên tắc vàng để lựa chọn cổ phiếu và tối đa hóa lợi nhuận.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Vợ Nhặt', 2024, N'Vietnamese', 120, 'https://product.hstatic.net/1000237375/product/thiet_ke_chua_co_ten__81__51d105537c8544b8945d7e1eb59d57fb.png', 100, 45000, 1, 1, 29, 0, N'Câu chuyện bi hài nhưng thấm đẫm tình người về hạnh phúc giản dị của người nông dân trong bối cảnh nạn đói năm 1945.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Bước Chậm Lại Giữa Thế Gian Vội Vã', 2023, N'Vietnamese', 260, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/363/455/products/buocchamlaigiuathegianvoiva01-4e74490c-3e27-444a-8edc-eb3d5278892e.jpg?v=1731981615520', 100, 92000, 3, 5, 30, 0, N'Những lời khuyên thông thái và nhẹ nhàng giúp bạn tìm lại sự bình yên, cân bằng trong tâm hồn giữa cuộc sống hối hả.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Tư Duy Nhanh Và Chậm', 2021, N'Vietnamese', 650, 'https://bizweb.dktcdn.net/thumb/grande/100/197/269/products/462558750-1083111936819329-1957541486232979466-n.png?v=1730363480047', 100, 265000, 7, 6, 31, 0, N'Khám phá sâu sắc về hai hệ thống tư duy chi phối nhận thức, giúp chúng ta hiểu rõ hơn về cách con người đưa ra quyết định.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Người Mẹ Cầm Súng', 2022, N'Vietnamese', 180, 'https://media.metaisach.com/2025/05/nguoi-me-cam-sung-5157ff9c.jpeg', 100, 58000, 1, 4, 32, 0, N'Câu chuyện có thật về chị Út Tịch, một người mẹ miền Nam anh hùng, kiên cường bất khuất trong cuộc kháng chiến chống Mỹ.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Bỉ Vỏ', 2021, N'Vietnamese', 240, 'https://product.hstatic.net/200000017360/product/bia-1_bi-vo_f4edca62e6b14f9990c81770585a0642_master.png', 100, 75000, 1, 2, 12, 0, N'Số phận bi thảm của người phụ nữ bị xã hội cũ xô đẩy vào con đường tội lỗi, trở thành nạn nhân của những bất công.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Những Ngã Tư Và Cột Đèn', 2023, N'Vietnamese', 380, 'https://www.sachbaokhang.vn/uploads/files/2025/08/27/gen-h-z6951500168169_1de36f6a44a656625fc7861ac021caa1.jpg', 100, 145000, 1, 1, 33, 0, N'Tiểu thuyết trinh thám ly kỳ với bút pháp hiện đại, tái hiện không khí Hà Nội những ngày kháng chiến đầy ám ảnh và bí ẩn.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Đi Tìm Lẽ Sống', 2024, N'Vietnamese', 220, 'https://307a0e78.vws.vegacdn.vn/view/v2/image/img.book/0/0/0/11703.jpg?v=4&w=480&h=700', 100, 88000, 3, 5, 34, 0, N'Hành trình tìm kiếm ý nghĩa cuộc sống từ trải nghiệm đau thương trong trại tập trung Đức Quốc xã, mang lại niềm tin và hy vọng.');

INSERT INTO BOOKS (BOOK_NAME, PUBLISH_YEAR, LANGUAGE, PAGES, IMAGE, QUANTITY, PRICE, CATEGORY_ID, PUBLISHER_ID, AUTHOR_ID, IS_DELETED, DESCRIPTION)
VALUES (N'Suối Nguồn', 2022, N'Vietnamese', 1200, 'https://www.nxbtre.com.vn/Images/Book/nxbtre_full_01372023_083700.jpg', 100, 450000, 1, 3, 35, 0, N'Tiểu thuyết triết học đồ sộ tôn vinh chủ nghĩa cá nhân, sự sáng tạo và bản lĩnh kiên định của kiến trúc sư Howard Roark.');


-- ===================================== INSERT CARTS =====================================

INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (1, '2026-01-16 10:00:00', '2026-01-16 10:00:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (2, '2026-01-16 11:30:00', '2026-01-16 11:30:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (3, '2026-01-16 12:15:00', '2026-01-16 12:15:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (4, '2026-01-16 13:45:00', '2026-01-16 13:45:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (5, '2026-01-16 14:20:00', '2026-01-16 14:20:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (6, '2026-01-16 15:10:00', '2026-01-16 15:10:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (7, '2026-01-16 16:05:00', '2026-01-16 16:05:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (8, '2026-01-16 17:30:00', '2026-01-16 17:30:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (9, '2026-01-16 18:55:00', '2026-01-16 18:55:00');
INSERT INTO CARTS (USER_ID, CREATED_AT, UPDATED_AT) VALUES (10, '2026-01-16 20:40:00', '2026-01-16 20:40:00');


-- ===================================== INSERT CART ITEMS =====================================

INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (1, 5, 1);
INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (1, 12, 2);
INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (3, 20, 1);
INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (3, 8, 3);
INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (4, 15, 1);
INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (5, 1, 2);
INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (6, 30, 1);
INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (7, 25, 2);
INSERT INTO CART_ITEMS (CART_ID, BOOK_ID, QUANTITY) VALUES (8, 10, 1);


-- ===================================== INSERT ORDERS =====================================
INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (1, N'Nguyễn Văn An', '0901234567', N'123 Lê Lợi, Quận 1, TP.HCM', 250000, 'Pending', 'COD');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (2, N'Trần Thị Bình', '0912345678', N'456 Nguyễn Huệ, Quận 1, TP.HCM', 120000, 'Delivering', 'BANK_TRANSFER');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (3, N'Lê Hoàng Cường', '0923456789', N'789 Cách Mạng Tháng 8, Tân Bình, TP.HCM', 500000, 'Completed', 'COD');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (4, N'Phạm Minh Đức', '0934567890', N'12 Hòa Bình, Quận 11, TP.HCM', 320000, 'Pending', 'MOMO');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (5, N'Đỗ Hải Yến', '0945678901', N'34 Phan Xích Long, Phú Nhuận, TP.HCM', 450000, 'Completed', 'COD');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (6, N'Hoàng Thanh Nam', '0956789012', N'56 Quang Trung, Gò Vấp, TP.HCM', 180000, 'Pending', 'COD');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (7, N'Ngô Kim Liên', '0967890123', N'78 Võ Văn Tần, Quận 3, TP.HCM', 950000, 'Completed', 'BANK_TRANSFER');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (8, N'Bùi Tiến Dũng', '0978901234', N'90 Nguyễn Trãi, Quận 5, TP.HCM', 210000, 'Cancelled', 'COD');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (9, N'Vũ Thu Thảo', '0989012345', N'11 Trần Hưng Đạo, Quận 1, TP.HCM', 380000, 'Delivering', 'ZALOPAY');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (10, N'Đặng Quốc Bảo', '0990123456', N'22 Lý Thường Kiệt, Hoàn Kiếm, Hà Nội', 670000, 'Completed', 'COD');

INSERT INTO ORDERS (USER_ID, RECEIVER_NAME, RECEIVER_PHONE, SHIPPING_ADDRESS, TOTAL_AMOUNT, STATUS, PAYMENT_METHOD)
VALUES (11, N'Mai Phương Chi', '0909876543', N'33 Tràng Thi, Hoàn Kiếm, Hà Nội', 150000, 'Pending', 'BANK_TRANSFER');


-- ===================================== INSERT ORDER DETAILS =====================================

INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (1, 1, 1, 150000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (1, 10, 1, 100000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (2, 2, 1, 120000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (3, 7, 2, 250000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (4, 19, 1, 320000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (5, 5, 2, 225000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (6, 25, 1, 180000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (7, 39, 1, 450000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (7, 21, 1, 500000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (8, 33, 3, 70000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (9, 39, 1, 380000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (10, 14, 2, 335000);
INSERT INTO ORDER_DETAILS (ORDER_ID, BOOK_ID, QUANTITY, PRICE) VALUES (11, 34, 1, 150000);
