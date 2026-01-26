"use client"

import { useState } from "react"
import { Prism as SyntaxHighlighter } from "react-syntax-highlighter"
import { vscDarkPlus } from "react-syntax-highlighter/dist/esm/styles/prism"

import { Badge } from "@/components/ui/badge"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"

interface Props {
  query: string
  data: any[] | null
  executionTime?: string
  error?: string
}

export const SqlResultViewer = ({ query, data, executionTime, error }: Props) => {
  const [isExpanded, setIsExpanded] = useState(true)

  const columns = data && data.length > 0 ? Object.keys(data[0]) : []

  const renderCellValue = (value: any) => {
    if (value === null || value === undefined) {
      return <span className="text-gray-300">NULL</span>
    }

    if (typeof value === "boolean") {
      return value ? (
        <span className="text-green-600 font-bold">True</span>
      ) : (
        <span className="text-red-600 font-bold">False</span>
      )
    }

    if (value instanceof Date) {
      return value.toLocaleString("vi-VN")
    }

    if (typeof value === "object") {
      return (
        <div className="overflow-auto rounded-md border border-slate-700">
          <SyntaxHighlighter
            language="json"
            style={vscDarkPlus}
            customStyle={{
              margin: 0,
              padding: "0.5rem",
              fontSize: "0.7rem",
              backgroundColor: "#1e1e1e",
              lineHeight: "1.2"
            }}
            wrapLongLines={true}
          >
            {JSON.stringify(value, null, 2)}
          </SyntaxHighlighter>
        </div>
      )
    }

    return String(value)
  }

  return (
    <div className="space-y-4 w-full max-w-4xl mx-auto my-4">
      {/* SQL TEXT */}
      <Card className="border-l-4 border-l-blue-500 bg-slate-950 text-white shadow-lg">
        <CardHeader className="px-4 border-b border-slate-800 flex flex-row justify-between items-center py-3">
          <div className="flex items-center gap-2">
            <span className="font-mono text-sm text-blue-400 font-bold">SQL QUERY</span>
            {executionTime && (
              <Badge variant="secondary" className="text-xs">
                {executionTime}
              </Badge>
            )}
          </div>
          <button
            onClick={() => setIsExpanded(!isExpanded)}
            className="text-xs text-slate-400 hover:text-white"
          >
            {isExpanded ? "Thu gọn" : "Mở rộng"}
          </button>
        </CardHeader>

        {isExpanded && (
          <div className="p-0 overflow-x-auto">
            <SyntaxHighlighter
              language="sql"
              style={vscDarkPlus}
              customStyle={{ margin: 0, padding: "1rem", background: "transparent" }}
              wrapLongLines={true}
            >
              {query}
            </SyntaxHighlighter>
          </div>
        )}
      </Card>

      {/* RESULT */}
      {error ? (
        <div className="p-4 bg-red-100 text-red-700 border border-red-300 rounded-md">
          <strong>Lỗi truy vấn:</strong> {error}
        </div>
      ) : (
        <Card className="overflow-hidden gap-4 py-4">
          <CardHeader className="py-2">
            <CardTitle className="text-sm font-medium uppercase tracking-wide text-gray-600">
              Kết quả ({data?.length || 0} dòng)
            </CardTitle>
          </CardHeader>
          <CardContent className="p-0">
            {data && data.length > 0 ? (
              <div className="max-h-80 overflow-auto">
                <Table>
                  <TableHeader className="bg-gray-100 sticky top-0 z-10">
                    <TableRow>
                      {columns.map((col) => (
                        <TableHead
                          key={col}
                          className="font-bold text-black whitespace-nowrap px-4"
                        >
                          {col}
                        </TableHead>
                      ))}
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {data.map((row, index) => (
                      <TableRow key={index} className="hover:bg-gray-50">
                        {columns.map((col) => (
                          <TableCell key={`${index}-${col}`} className="font-mono text-xs px-4">
                            {/* Gọi hàm renderCellValue đã viết ở trên */}
                            {renderCellValue(row[col])}
                          </TableCell>
                        ))}
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
            ) : (
              <div className="p-8 text-center text-gray-500 italic">Không có dữ liệu trả về</div>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  )
}
