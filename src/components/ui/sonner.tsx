"use client"

import {
  CircleCheckIcon,
  InfoIcon,
  LoaderIcon,
  OctagonXIcon,
  TriangleAlertIcon
} from "lucide-react"
import { useTheme } from "next-themes"
import { Toaster as Sonner, type ToasterProps } from "sonner"

const Toaster = ({ ...props }: ToasterProps) => {
  const { theme = "system" } = useTheme()

  return (
    <Sonner
      theme={theme as ToasterProps["theme"]}
      className="toaster group"
      icons={{
        success: <CircleCheckIcon className="size-4 mt-0.5" />,
        info: <InfoIcon className="size-4 mt-0.5" />,
        warning: <TriangleAlertIcon className="size-4 mt-0.5" />,
        error: <OctagonXIcon className="size-4 mt-0.5" />,
        loading: <LoaderIcon className="size-4 animate-spin mt-0.5" />
      }}
      style={
        {
          "--normal-bg": "var(--popover)",
          "--normal-text": "var(--popover-foreground)",
          "--normal-border": "var(--border)",
          "--border-radius": "var(--radius)"
        } as ToasterProps["style"]
      }
      {...props}
    />
  )
}

export { Toaster }
