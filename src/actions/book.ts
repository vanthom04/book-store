"use server"

import { executeSP, getPool } from "@/lib/db"
import { withTiming } from "@/lib/utils"
import { getCurrentUser } from "./user"

export async function getAuthors(): Promise<any> {
  return withTiming(async () => {
    const queryText = `SELECT
    AUTHOR_ID AS ID,
    AUTHOR_NAME AS [Tên tác giả]
FROM AUTHORS
ORDER BY AUTHOR_NAME ASC
`

    try {
      const pool = await getPool()
      const result = await pool.request().query(queryText)
      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error fetching authors: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy danh sách tác giả."
      }
    }
  })
}

export async function getCategories(): Promise<any> {
  return withTiming(async () => {
    const queryText = `SELECT
    CATEGORY_ID AS ID,
    CATEGORY_NAME AS [Tên thể loại]
FROM CATEGORIES
ORDER BY CATEGORY_NAME ASC
`

    try {
      const pool = await getPool()
      const result = await pool.request().query(queryText)
      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error fetching categories: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy danh sách thể loại."
      }
    }
  })
}

export async function getPublishers(): Promise<any> {
  return withTiming(async () => {
    const queryText = `SELECT
    PUBLISHER_ID AS ID,
    PUBLISHER_NAME AS [Tên nhà xuất bản]
FROM PUBLISHERS
ORDER BY PUBLISHER_NAME ASC
`

    try {
      const pool = await getPool()
      const result = await pool.request().query(queryText)
      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error fetching publishers: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy danh sách nhà xuất bản."
      }
    }
  })
}

export async function createBook({
  bookName,
  authorId,
  categoryId,
  price,
  quantity,
  description,
  pages,
  language,
  publishYear,
  publisherId,
  image
}: any) {
  const user = await getCurrentUser()

  if (!user || user.ROLE !== "ADMIN") {
    return { success: false, error: "Unauthorized" }
  }

  return withTiming(async () => {
    const queryText = `EXEC sp_CreateBook
      @RequestUserID = ${user.USER_ID},
      @BookName = '${bookName}',
      @AuthorID = ${authorId},
      @CategoryID = ${categoryId},
      @Price = ${price},
      @Quantity = ${quantity},
      @Description = '${description}',
      @Pages = ${pages},
      @Language = '${language}',
      @PublishYear = ${publishYear},
      @PublisherID = ${publisherId},
      @Image = ${image || 'NULL'}
  `

    try {
      const result = await executeSP("sp_CreateBook", {
        RequestUserID: user.USER_ID,
        BookName: bookName,
        AuthorID: authorId,
        CategoryID: categoryId,
        Price: price,
        Quantity: quantity,
        Description: description,
        Pages: pages,
        Language: language,
        PublishYear: publishYear,
        PublisherID: publisherId,
        ...(image && { Image: image })
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error creating book:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi tạo sách."
      }
    }
  })
}

export async function updateBook({
  bookId,
  bookName,
  authorId,
  categoryId,
  price,
  quantity,
  description,
  pages,
  language,
  publishYear,
  publisherId,
  image
}: any) {
  const user = await getCurrentUser()

  if (!user || user.ROLE !== "ADMIN") {
    return { success: false, error: "Unauthorized" }
  }

  return withTiming(async () => {
    const queryText = `EXEC sp_UpdateBookInfo
      @RequestUserID = ${user.USER_ID},
      @BookID = ${bookId},
      @BookName = ${bookName},
      @AuthorID = ${authorId},
      @CategoryID = ${categoryId},
      @Price = ${price},
      @Quantity = ${quantity},
      @Description = ${description},
      @Pages = ${pages},
      @Language = ${language},
      @PublishYear = ${publishYear},
      @PublisherID = ${publisherId},
      @Image = ${image || 'NULL'}
  `

    try {
      const result = await executeSP("sp_UpdateBookInfo", {
        RequestUserID: user.USER_ID,
        BookID: bookId,
        BookName: bookName,
        AuthorID: authorId,
        CategoryID: categoryId,
        Price: price,
        Quantity: quantity,
        Description: description,
        Pages: pages,
        Language: language,
        PublishYear: publishYear,
        PublisherID: publisherId,
        ...(image && { Image: image })
      })

      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error updating book:", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi cập nhật sách."
      }
    }
  })
}

export async function getBooks(): Promise<any> {
  return withTiming(async () => {
    const queryText = `SELECT
    BOOK_ID AS ID,
    BOOK_NAME AS [Tên sách],
    BOOKS.AUTHOR_ID AS AuthorID,
    AUTHOR_NAME AS [Tác giả],
    BOOKS.CATEGORY_ID AS CategoryID,
    CATEGORY_NAME AS [Thể loại],
    PRICE AS [Giá],
    QUANTITY AS [Số lượng],
    IMAGE AS [URL ảnh bìa],
    DESCRIPTION AS [Mô tả],
    PAGES AS [Số trang],
    LANGUAGE AS [Ngôn ngữ],
    PUBLISH_YEAR AS [Năm xuất bản],
    BOOKS.PUBLISHER_ID AS PublisherID,
    PUBLISHER_NAME AS [Nhà xuất bản],
    CREATED_AT AS [Ngày tạo]
FROM BOOKS
JOIN AUTHORS ON BOOKS.AUTHOR_ID = AUTHORS.AUTHOR_ID
JOIN CATEGORIES ON CATEGORIES.CATEGORY_ID = BOOKS.CATEGORY_ID
JOIN PUBLISHERS ON PUBLISHERS.PUBLISHER_ID = BOOKS.PUBLISHER_ID
WHERE IS_DELETED = 0
ORDER BY CREATED_AT DESC
`

    try {
      const pool = await getPool()
      const result = await pool.request().query(queryText)
      return {
        success: true,
        sqlText: queryText,
        result: result.recordset
      }
    } catch (error: any) {
      console.error("Error fetching books: ", error)
      return {
        success: false,
        sqlText: queryText,
        result: null,
        error: error.message || "Lỗi khi lấy danh sách sản phẩm."
      }
    }
  })
}
