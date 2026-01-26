"use client"

export const HomeClient = ({ user }: any) => {
  return (
    <div className="px-4 py-3 lg:px-6 overflow-y-auto">
      <pre>{JSON.stringify(user, null, 2)}</pre>
    </div>
  )
}
