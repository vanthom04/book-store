interface Props {
  children: React.ReactNode
}

export default function AuthLayout({ children }: Props) {
  return (
    <div className="min-h-screen flex-1 flex items-center justify-center p-10 bg-gray-50">
      <div className="w-full max-w-md">{children}</div>
    </div>
  )
}
