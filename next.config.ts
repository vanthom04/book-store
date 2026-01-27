import { type NextConfig } from "next"

const nextConfig: NextConfig = {
  reactCompiler: true,
  images: {
    remotePatterns: [
      { protocol: "http", hostname: "**" },
      { protocol: "https", hostname: "**" }
    ]
  },
  serverExternalPackages: ["mssql"],
  experimental: {
    serverActions: {
      bodySizeLimit: "5mb"
    }
  }
}

export default nextConfig
